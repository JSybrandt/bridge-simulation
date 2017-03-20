clc; close all; clear all;

%Bridge Parameters
L=25; % Length m
E=3.5*10^10; % Modulus of Elasticity of concrete N/m^2
I=1.39; % Moment of Inertia m^4
mu=18358; % mass per unit length kg/m
mb=mu*L/2; % mass of bridge kg
kb=48*E*I/L.^3; % stiffness of beam N/m
J=1; % Mode

%Temperature and Humidity Variables
Tl=load('lowdata.dat');
Th=load('highdata.dat');
To=35; %temp that correlates to virtually no asphault stiffness
Tavg=16.67; %Average temperature in SC in degrees celsius
ho=50; % relative humidity at static modulus
Td=0:.0168:24; %Time of day record was taken
n=length(Td);%number of cases looking at a single car crossing bridge

% Vehicle Input
c=8.94+(44.704-8.94).*rand(1,n); % Speed mps
dmv=round(2722+(14515-2722).*rand(1,n)); %vehicle mass
O=29*pi; %Circumference of tire (Needs to be varied with vehicle mass)

wn=zeros(1,n);
for ii=1:2
At(ii)=(Th(ii)-Tl(ii))/2; %Amplitude for temperature curve
Dt(ii)=(Th(ii)+Tl(ii))/2; %Midline for temperature curve
for j=1:n
Tact(ii,:)=(At(ii)*cos((Td+1)*.2618)+(Dt(ii)+((Dt(ii)+1)-Dt(ii)).*rand(1,length(Td)))); %Actual temperature
dt(ii,:)=Tact(ii,:)-To;%total change in temp relative to max
dEa(ii,:)=(-2.13*10^8)*dt(ii,:); %change in road surface elastic modulus 
dkc(ii,:)=-.0045*(Tact(ii,:)-Tavg); %change in frequency due to concrete temp change

%humidity effects
rh(ii,:)=ho-(At(ii)*cos((Td+1)*.2618)+(Dt(ii)+((Dt(ii)+1)-Dt(ii)).*rand(1,length(Td))));
dmh(ii,:)=-.0006*(rh(ii,:)-ho);% change in concrete modulus due to humidity

%Changes to Mass
m(ii,j)=mb+mb*dmh(ii,j);% total mass of bridge
mun(ii,j)=m(ii,j)/(L/2); % New mass per unit length
P(j)=dmv(j)*9.81; %Point Load of Vehicle
G(ii,j)=mun(ii,j)*L*9.81; %Total weight of bridge
muu(ii,j)=mun(ii,j)*(1+2*P(j)/G(ii,j)); %Modified kg/m

%Altered Natural Frequency
k(ii,j)=48*(E+dEa(ii,j))*I/L.^3+kb*dkc(ii,j); %Total stiffness
wn(ii,j)=sqrt(J^4*(k(ii,j)/m(j))*(mun(ii,j)/muu(ii,j))); % modified circular frequency to include vehicle mass
wn1(ii,j)=sqrt((k(ii,j)/m(j))*(mun(ii,j)/muu(ii,j))); % modified 1st circular frequency to include vehicle mass
f1(ii,j)=(sqrt((k(ii,j)/m(j)))/(2*pi))*(1+2*P(j)/G(ii,j))^(-.5); % modified 1st natural frequency (in HZ)
cr(ii,j)=f1(ii,j)*O; % Critical Speed
T=0:.01:L/c(j); %Time Step for vehicle across bridge
q(j)=length(T);
w(j)=pi*c(j)/L; %Circular frequency
alpha(ii,j)=w(j)/wn1(ii,j);
beta=.03+.04*.03; %total damping including effects from vehicles
logd=2*pi*beta; %log decrement of bridge
wb(ii,j)=f1(ii,j)*logd; % modified circular frequency of damping

x=L/2;

% Harmonic Variables
if c(j)==cr(ii,j)
rev(ii,j)=f1(ii,j); %Revolutions per second
else
rev(ii,j)=c(j)/O;
end
omg(ii,j)=2*pi*rev(ii,j); % Circular frequency of force
Q(ii,j)=3*rev(ii,j)^2*1000; %Amplitude of force (Need to research range)
for e=1:length(x)
    b(e)=(L-x(e));
    vo(e,j)=-P(j)*b(e)*x(e)/(6*L*E*I)*(L^2-x(e).^2-b(e).^2); % Initial Static Displacement at pt x
for i=1:q(j) % Time for vehicle to enter and exit bridge
    % Chapter 1 equations
    disp1(i,j,ii)=-vo(e,j)*sin(w(j)*T(i))*sin(pi*x(e)/L); %equation 1.41
    disp2(i,j,ii)=-vo(e,j)*sum(sin(J*pi*x(e)/L)*1/(J^2*(J^2-alpha(ii,j)^2))*(sin(J*w(j)*T(i))-(alpha(ii,j)/J)*exp(-wb(ii,j)*T(i))*sin(wn(ii,j)*T(i)))); % equation 1.34
    % Chapter 2 equations
    disp3(i,j,ii)=-vo(e,j)*(Q(ii,j)/P(j))*(wn1(ii,j)^2/omg(ii,j)^2)*(1/((wn1(ii,j)^2/omg(ii,j)^2-1)^2+4*(w(j)^2/omg(ii,j)^2+wb(ii,j)^2/omg(ii,j)^2)))*(((wn1(ii,j)^2/omg(ii,j)^2-1)^2+4*(wb(ii,j)^2/omg(ii,j)^2))^(.5)*sin(omg(ii,j)*T(i))*sin(w(j)*T(i))+2*(w(j)/omg(ii,j))*(cos(omg(ii,j)*T(i))*cos(w(j)*T(i))-exp(-wb(ii,j)*T(i))*cos(wn1(ii,j)*T(i))))*sin(pi*x(e)/L); %equation 2.7 (tested for correctness)
    %  Deflection Totals
dispT1(i,j,ii)=disp1(i,j,ii)+disp3(i,j,ii);
dispT2(i,j,ii)=disp2(i,j,ii)+disp3(i,j,ii);
end
end
umaxT1=max(dispT1);
umaxT2=max(dispT2);
end
end



