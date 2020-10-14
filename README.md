# NARX-Neural-Network-Hyper-Parameter-Tuning-And-Training--Matlab

This work includes the hyper parameter tuning of a NARX neural network in Matlab.

This is used to determine the ideal number of delays in both the inputs and outputs, just as the number of neurons in the hidden layer.
The flowchart below describes this process. 


The process requires the input of the
iteration limits: number of trials, numT rials, maximum and minimum number of hidden
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

By analysing figure it was decided that a memory depth of 4 with 10 neurons in the
hidden layer would be a good compromise between complexity and accuracy
