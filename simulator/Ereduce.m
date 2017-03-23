function [Er]=Ereduce(nn,E,Pd1,Pd2,Pd3)
if nn>=3
    Er=E-Pd1*E-Pd2*E-Pd3*E; % New Modulous of Elasticity
elseif nn>=2
    Er=E-Pd1*E-Pd2*E; % New Modulous of Elasticity 
elseif nn>=1
    Er=E-Pd1*E; % New Modulous of Elasticity
else
    Er=E; % Means no damage has occured yet
end
