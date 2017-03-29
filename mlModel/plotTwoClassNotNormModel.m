clc; close all; clear all;

load('../data/singleBridgeTwoClassModel.mat','twoClassModel','mu','sig')
load('../data/singleBridgeData.mat');
range = -1:0.2:1;

model = twoClassModel;

disp('Standardizing:')
%standardize data
[bridgeData(:,2:end),mu,sig] = zscore(bridgeData(:,2:end)); 
disp('Randomizing:')
%randomize data
ordering = randperm(size(bridgeData,1));
bridgeData = bridgeData(ordering,:);

disp('Sparcifying:')
bridgeData = bridgeData(1:1000,:);

PURPlE = [0.41,0,0.88];
RED = [0.808,0,0.02];
ORANGE = [0.776, 0.443, 0];
YELLOW = [0.761, 0.663, 0];
GREEN = [0.616, 0.749, 0];

colors = [GREEN; YELLOW; RED; PURPlE];
figure(1)

plotDecisionBoundary(0,1,model,range);
hold on;

scatter3(bridgeData(:,2),...
    bridgeData(:,3),...
    bridgeData(:,4),...
    ones(size(bridgeData,1),1)*5,...
    colors(bridgeData(:,1)+1, :),...
    'filled');
xlabel('Modified Density');
ylabel('Max Displacement');
zlabel('Temperature');
title('Color shows health');
