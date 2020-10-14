# NARX-Neural-Network-Hyper-Parameter-Tuning-And-Training--Matlab

This work includes the hyper parameter tuning of a NARX neural network in Matlab.

This is used to determine the ideal number of delays in both the inputs and outputs, just as the number of neurons in the hidden layer.
The flowchart below describes this process. 

<img src="https://user-images.githubusercontent.com/40301612/96038758-87535700-0e5f-11eb-9243-aa4bfd7c9d02.png" width="500">


The process requires the input of the
iteration limits: number of trials, numTrials, maximum and minimum number of hidden
layer neurons, Hmax and Hmin respectively, and maximum memory depth, Mmax. In
order to minimize the bad start problem, present in the Levenberg-Marquardt algorithm, the
process starts by iterating over a set number of trials, numT rials, with a fixed memory depth
and number of neurons in the hidden layer. At each iteration of this inner loop, the initial
parameter solution is randomized and subsequently optimized by the minimization algorithm.
This procedure is carried out with the network in an open loop, or series-parallel configuration,
meaning the delayed outputs fed into the network are real values taken from the extraction
signals. For extraction of the network’s parameters, the data set is first divided into three
contiguous parts, where the first 70% of the data is used to update the weight’s and biases, 15%
for online validation whose error is monitored during extraction and 15% for model validation.

When the number of trials reaches its maximum, the structure’s accuracy is calculated in
terms of the mean value of validation NMSEs across the trials. This process is then repeated
for all combinations of memory depth and number of hidden layer neurons.
The described procedure was realized with numT rials, Hmin, Hmax and Mmax set to
20, 5, 20 and 10 respectively. The results are shown in a 3D plot.

<img src="https://user-images.githubusercontent.com/40301612/96039042-faf56400-0e5f-11eb-9f58-d70020f2ccdd.png" width="500">

By analysing figure it was decided that a memory depth of 4 with 10 neurons in the
hidden layer would be a good compromise between complexity and accuracy.

The optimal structure was trained in a single loop akin to
the inner loop of the previous procedure. The overall procedure is described by the flowchart below.
The difference is that, at each iteration, after doing the open loop extraction with
randomized initial solutions, the network is converted into closed loop or parallel configuration,
meaning its previous predictions are used as inputs.

![paraExtraction (3)](https://user-images.githubusercontent.com/40301612/96039037-f92ba080-0e5f-11eb-8e2d-ad5b14bec51c.png)

The network’s performance is then evaluated on both validation and extraction data in
terms of its NMSE. The end result is the weights and biases that led to the smallest overall
NMSE.
During the extraction, the number of trials was set to 100 while a regularization
performance ratio of 0.3, set by trial and error, was used in order to diminish the variance of
the solutions. Open and closed loop results are shown below

