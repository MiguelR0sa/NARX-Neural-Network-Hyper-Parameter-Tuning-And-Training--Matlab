clear
clc
close all
%Dados filtrados
% load inFilt.mat
% load outFilt.mat
addpath('C:\Users\Miguel Rosa\Desktop\NNSYSID20');

%DADOS NORMAIS
load inputs.mat
load outputs.mat



X=inputs;
T=outputs;
in=cell2mat(inputs);
out=cell2mat(outputs);
 
 





X=con2seq(in);
T=con2seq(out);
inputs=X;
outputs=T;

trainFcn = 'trainlm';  % Levenberg-Marquardt backpropagation.
% Create a Nonlinear Autoregressive Network with External Input



numTrials=20;

minLoopNMSE=0;
minNMSE=0;

Hmax=10
Hmin=10
Mmax=4
Mmin=4
numNeurons=Hmin:Hmax;

nmsePerNeuron=zeros(Hmax-Hmin+1,1);

numDelays=Mmin:Mmax;
nmsePerDelay=zeros(Mmax-Mmin+1,1);

nmseProfile=zeros(Hmax-Hmin+1,Mmax-Mmin+1)
 for m=Mmin:Mmax
     inputDelays = 1:m;
     feedbackDelays = 1:m;
     
     for i=Hmin:Hmax

        hiddenLayerSize = i;

        for j=1:numTrials
            net = narxnet(inputDelays,feedbackDelays,hiddenLayerSize,'open',trainFcn); 
            net.inputs{:}.processFcns = {'removeconstantrows','mapstd'}; %%normalização por desvio padrao
            %net.inputs{:}.processFcns = {'removeconstantrows','mapminmax'};
                
            [x,xi,ai,t] = preparets(net,X,{},T);
            net.divideFcn = 'divideblock';  %%%%%% divide into contiguous block
%             net.trainParam.max_fail=100;
             net.trainParam.epochs=200;
           % net.trainParam.goal=0.01*mean(var(cell2mat(T),1));
           % net.trainParam.max_fail=200; %num validation checks
            net.performParam.regularization = 0.3;
   
            [net,tr] = train(net,x,t,xi,ai,nn7);
            y = net(x,xi,ai,nn7);
            nmse_open_ext=nmseCell_M(t,y,tr.trainMask);
            nmse_open_val=nmseCell_M(t,y,tr.testMask);
            
            

            %closed loop 

            netc = closeloop(net);
           % netc.performFcn='mae';

            netc.trainParam.goal= 0.01*mean(var(cell2mat(T),1));
            [xc,xic,aic,tc] = preparets(netc,inputs,{},outputs);
            % Train the Network
             netc.trainParam.max_fail=20;
%             [netc,trc] = train(netc,xc,tc,xic,aic);
            yc = netc(xc,xic,aic,nn7);
            nmse_closed=NMSE_M(cell2mat(tc),cell2mat(yc));
           
            nmse_closed_ext=nmseCell_M(tc,yc,tr.trainMask);
            
            
            nmse_closed_val=nmseCell_M(tc,yc,tr.testMask);

            if(nmse_closed < minLoopNMSE)
               minLoopNMSE=nmse_closed; 
               if(minLoopNMSE<minNMSE)
                   
                    figure(99)
                     xlabel('Time(s)')
                     
                    subplot(2,1,1)
                    plot([cell2mat(gmultiply(t,tr.trainMask))' cell2mat(gmultiply(y,tr.trainMask))'])
                    legend('real','model')
                    title(['Open loop, Extraction NMSE: ',num2str(nmse_open_ext),'dB'])
                    subplot(2,1,2)
                    plot([cell2mat(gmultiply(t,tr.testMask))' cell2mat(gmultiply(y,tr.testMask))'])
                    %plot([cell2mat(outputs(3002:end)') cell2mat(y_val')])
                    legend('real','model')
                    title(['Open loop, Validation NMSE: ',num2str(nmse_open_val),'dB'])
                    
                    finalNetO=net;
                    trfO=tr;
                    tof=t;
                    minNMSE=nmse_closed
                    finalNet=netc;
                    yf=yc;
                    tf=tc;
                 %   trf=trc;    
                    if(m==2)
                    mem2net=finalNet;
                    end    


                     figure(101)
                     xlabel('Time(s)')
                    subplot(2,1,1)
                    plot([cell2mat(gmultiply(tc,tr.trainMask))' cell2mat(gmultiply(yc,tr.trainMask))'])
                    legend('real','model')
                    title(['Closed loop, Extraction NMSE: ',num2str(nmse_closed_ext),'dB'])
                    subplot(2,1,2)
                    plot([cell2mat(gmultiply(tc,tr.testMask))' cell2mat(gmultiply(yc,tr.testMask))'])
                    %plot([cell2mat(outputs(3002:end)') cell2mat(y_val')])
                    legend('real','model')
                    title(['Closed loop, Validation NMSE: ',num2str(nmse_closed_val),'dB'])
                    
                    figure(102)
                    subplot(2,1,1)
                    ep = gsubtract(t,y);
                    ploterrcorr(ep)
                   figure(103)
                    ep = gsubtract(tc,yc);
                    ploterrcorr(ep)
                    
                    drawnow
                    
               end
            end    

        end
         nmsePerNeuron(i-Hmin+1)=minLoopNMSE;

         minLoopNMSE=0;
        figure(m)
         
        plot(numNeurons,nmsePerNeuron')
        title(['Memory depth =',num2str(m)])
     end
  nmseProfile(:,m)=nmsePerNeuron;
 end
 

