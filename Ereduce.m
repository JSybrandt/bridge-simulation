function [Er]=Ereduce(nn,E,D1,D2,D3,Pd1,Pd2,Pd3)
if nn>=D3
    Er=E-Pd1*E-Pd2*E-Pd3*E; % New Modulous of Elasticity
elseif nn>=D2
    Er=E-Pd1*E-Pd2*E; % New Modulous of Elasticity 
elseif nn>=D1
    Er=E-Pd1*E; % New Modulous of Elasticity
else
    Er=E; % Means no damage has occured yet
end
