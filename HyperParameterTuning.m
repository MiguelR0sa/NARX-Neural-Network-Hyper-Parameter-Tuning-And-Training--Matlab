clear
clc
close all

addpath('C:\Users\Miguel Rosa\Desktop\NNSYSID20');

%DADOS NORMAIS
load inputs.mat
load outputs.mat

X=inputs;
T=outputs;

 in=cell2mat(inputs);
 out=cell2mat(outputs);
 
 
trainFcn = 'trainlm';  % Levenberg-Marquardt backpropagation.
% Create a Nonlinear Autoregressive Network with External Input





 [num,den]=butter(2,0.1,'low')
%  freqz(num,den)
save('fir.mat','num','den')

numTrials=10;

minLoopNMSE=0;
minNMSE=0;

Hmax=20
Hmin=5
Mmax=10
Mmin=1
numNeurons=Hmin:Hmax;

nmsePerNeuron=zeros(Hmax-Hmin+1,1);

numDelays=Mmin:Mmax;
nmsePerDelay=zeros(Mmax-Mmin+1,1);

nmseProfile=zeros(Hmax-Hmin+1,Mmax-Mmin+1);
nmse_total=0;

[XX,YY]=meshgrid(numNeurons,numDelays)
 for m=Mmin:Mmax
     inputDelays = 0:m;
     feedbackDelays = 1:m;
     
     for i=Hmin:Hmax

        hiddenLayerSize = i;

        for j=1:numTrials
            net = narxnet(inputDelays,feedbackDelays,hiddenLayerSize,'open',trainFcn); 
            
            net.inputs{:}.processFcns = {'removeconstantrows','mapminmax'};
                
            [x,xi,ai,t,ew] = preparets(net,X,{},T);
            net.divideFcn = 'divideblock';  
             
            [net,tr] = train(net,x,t,xi,ai);
            y = net(x,xi,ai);               
           
            nmse=nmseCell_M(t,y,tr.valMask);
            nmse_total=nmse_total+nmse;     
    
        end
        mean_nmse=nmse_total/numTrials
        nmse_total=0;
        nmseProfile(i-Hmin+1,m-Mmin+1)=mean_nmse;
        
        figure(1)
        surf(XX,YY,nmseProfile')
        xlabel('Number of hidden layer neurons ')
        ylabel('Memory Depth')
        zlabel('Mean NMSE (dB)')
        figure(2)
        plot(nmseProfile)
        xlabel('Number of hidden layer neurons ')
        ylabel('Mean NMSE (dB)')
        legend('M = 1','M = 2','M = 3','M = 4','M = 5')
        drawnow
     end

 end
 
 




