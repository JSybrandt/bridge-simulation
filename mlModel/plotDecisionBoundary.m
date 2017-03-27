function plotDecisionBoundary(labelA, labelB, model, range)
%PLOTDECISIONBOUNDARY Summary of this function goes here
%   Detailed explanation goes here
[w,d] = getWB(labelA,labelB, model);

a = w(1);
b = w(2);
c = w(3);

pX = combnk([range range],2);
pY = pX(:,2);
pX = pX(:,1);

[pX,pY] = meshgrid(range,range);
pZ = (d - (pX * a) - (pY * b))/c;

surf(pX,pY,pZ);

end

