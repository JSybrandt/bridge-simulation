clc; close all; clear all;
load('../data/singleBridgeData.mat');
load('../data/model.mat');

RED = [1,0,0];
ORANGE = [1, 0.63, 0];
YELLOW = [0.9, 1, 0];
GREEN = [0, 1, 0];

colors = [GREEN; YELLOW; ORANGE; RED];

disp('Standardizing:')
%standardize data
bridgeData(:,2:end) = zscore(bridgeData(:,2:end));

scatter3(model.SVs(:,1), model.SVs(:,2), model.SVs(:,3));


scatter3(bridgeData(:,2),...
    bridgeData(:,3),...
    bridgeData(:,4),...
    ones(size(bridgeData,1),1),...
    colors(bridgeData(:,1)+1, :));
xlabel('Modified Density');
ylabel('Max Displacement');
zlabel('Temperature');
title('Variable Bridge Length (Color shows health)');