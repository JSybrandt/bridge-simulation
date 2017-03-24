clc; close all; clear all;
load('../data/multiBridgeData.mat');

% Note: The following applies to initial trials
% Features : 
%   1        2        3        4          5              6          7
% [label, damange, maxDisp, natFreq, cStiffness, modifiedDensity, cMass, ...
%    8              9         10           11         12
% speedVehicle, pointLoad, tempAct, relativeHumidity, day]

%bridgeData = bridgeData(:,[1 8 9 10 11]);


disp('Standardizing:')
%standardize data
bridgeData(:,2:end) = zscore(bridgeData(:,2:end));

numPoints = size(bridgeData, 1);

disp('Randomizing:')
%randomize data
ordering = randperm(numPoints);
bridgeData = bridgeData(ordering,:);

trainingSetSize = floor(numPoints*0.8);

trainingLabels = bridgeData(1:trainingSetSize, 1);
trainingSet = bridgeData(1:trainingSetSize,2:end);

disp('Training:')
model = svmtrain(trainingLabels, trainingSet, ...
    '-s 0 -t 2 -h 0 -q');

disp('TRAINING SET:')
trainingPredictions = svmpredict(...
    trainingLabels, trainingSet, ...
    model);

disp('CROSS VALIDATION SET:')
[validationPredictions, acc, decVals] = svmpredict(...
    bridgeData(trainingSetSize:end, 1),... validation labels
    bridgeData(trainingSetSize:end, 2:end),... validation set
    model);
