clc; close all; clear all;
load('../simulator/singleBridge.mat');
% the name of the var
% singleBridgeData
% Features : 
% [label, damange, maxDisp, natFreq, cStiffness, modifiedDensity, cMass, speedVehicle, pointLoad, tempAct, relativeHumidity, day]

%standardize data
[singleBridgeData,mu,sig] = zscore(singleBridgeData);
mu = mu';
sig = sig';

numPoints = size(singleBridgeData, 1);

%randomize data
ordering = randperm(numPoints);
singleBridgeData = singleBridgeData(ordering,:);

trainingSetSize = floor(numPoints*0.8);

trainingLabels = singleBridgeData(1:trainingSetSize, 1);
trainingSet = singleBridgeData(1:trainingSetSize,2:end);

validationLabels = singleBridgeData(trainingSetSize:end, 1);
validationSet = singleBridgeData(trainingSetSize:end, 2:end);

model = svmtrain(trainingLabels, trainingSet, '-s 1 -t 1 -h 0');

disp('TRAINING SET:')
trainingPredictions = svmpredict(trainingLabels, trainingSet, model);
disp('CROSS VALIDATION SET:')
[validationPredictions, acc, decVals] = svmpredict(validationLabels, validationSet,model);