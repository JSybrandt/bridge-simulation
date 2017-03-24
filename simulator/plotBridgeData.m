clc; close all; clear all;
load('../data/multiBridgeData.mat');

RED = [1,0,0];
ORANGE = [1, 0.63, 0];
YELLOW = [0.9, 1, 0];
GREEN = [0, 1, 0];

colors = [GREEN; YELLOW; ORANGE; RED];


scatter3(bridgeData(:,2),...
    bridgeData(:,3),...
    bridgeData(:,5),...
    ones(size(bridgeData,1),1),...
    colors(bridgeData(:,1)+1, :));
xlabel('Modified Density');
ylabel('Max Displacement');
zlabel('LEngth');
title('Variable Bridge Length (Color shows health)');