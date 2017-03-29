function plotDecisionBoundary(labelA, labelB, model, range, mu, sig)

if nargin < 5
    mu = [0 0 0];
end
if nargin < 6
    sig = [1 1 1];
end
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

pX = pX * sig(1) + mu(1);
pY = pY * sig(2) + mu(2);
pZ = pZ * sig(3) + mu(3);

surf(pX,pY,pZ);

end

