clc; close all; clear all;

%Bridge Parameters
bridgeLength=25; % Length m
modElasticity=3.5*10^10; % Modulus of Elasticity of concrete N/m^2
intertia=1.39; % Moment of Inertia m^4
density=18358; % mass per unit length kg/m
massBridge=density*bridgeLength/2; % mass of bridge kg
mode=1; % Mode

%Temperature and Humidity Variables
lowTemp=load('../data/lowdata.dat');
highTemp=load('../data/highdata.dat');
initTemp=35; %temp that correlates to virtually no asphault stiffness
avgTemp=16.67; %Average temperature in SC in degrees celsius
initHumidity=50; % relative humidity at static modulus
timeOfDay=0:.0168:24; %Time of day record was taken
numTrialsPerDay=length(timeOfDay);%number of cases looking at a single car crossing bridge
numDays = 20;

tireCircumference=29*pi; %Circumference of tire (Needs to be varied with vehicle mass)

% Damage Information
D1=5000; % Number of runs required for first damage to occure
% Pd1=.05+(.15-.05).*rand(1); % Percent damage that occured at first damage
damageCoef = 0.15;

beta=.03+.04*.03; %total damping including effects from vehicles
lgDecrement=2*pi*beta; %log decrement of bridge

numFeatures = 4;

%results = zeros(numDays, numTrialsPerDay, numFeatures);
results = zeros(numTrialsPerDay, numFeatures, numDays);

for day=1:numDays

    % bridge effects
    tempAmp=(highTemp(day)-lowTemp(day))/2; %Amplitude for temperature curve
    tempML=(highTemp(day)+lowTemp(day))/2; %Midline for temperature curve

    label = floor(rand()*4);
    damage = (1 - damageCoef * label) * modElasticity;
    stiffness=48*damage*intertia/bridgeLength.^3;

    % for each trail
    for trial=1:numTrialsPerDay
        % Vehicle Input
        speedVehicle=8.94+(44.704-8.94).*rand(); % Speed mps
        massVehicle=round(2722+(14515-2722).*rand()); %vehicle mass

        trialStartTime = timeOfDay(trial);
        tempAct=tempAmp*cos(trialStartTime*.2618) + tempML+rand();               %Actual temperature
        tempChange=tempAct-initTemp;                                                           %total change in temp relative to max
        surfaceElasticChange=(-2.13*10^8)*tempChange;                                                  %change in road surface elastic modulus
        freqChange=-.0045*(tempAct-avgTemp);                                               %change in frequency due to concrete temp change

        %humidity effects
        relativeHumidity=initHumidity-tempAct;
        concreteElasticChange=-.0006*(relativeHumidity-initHumidity);% change in concrete modulus due to humidity

        %Changes to Mass
        cMass=massBridge+massBridge*concreteElasticChange;% total mass of bridge
        cDensity=2*cMass/bridgeLength; % New mass per unit length
        pointLoad=massVehicle*9.81; %Point Load of Vehicle
        weightBridge=cDensity*bridgeLength*9.81; %Total weight of bridge
        modifiedDensity=cDensity*(1+2*pointLoad/weightBridge); %Modified kg/m

        cStiffness=48*(damage+surfaceElasticChange)*intertia/bridgeLength^3+stiffness*freqChange; %Total stiffness

        circFreq=sqrt((cStiffness/cMass)*(cDensity/modifiedDensity)); % modified 1st circular frequency to include vehicle mass
        natFreq=(sqrt((cStiffness/cMass))/(2*pi))*(1+2*pointLoad/weightBridge)^(-.5); % modified 1st natural frequency (in HZ)
        critSpeed=natFreq*tireCircumference; % Critical Speed

        vehicleCircFreq=pi*speedVehicle/bridgeLength; %Circular frequency
        alpha=vehicleCircFreq/circFreq;

        modCircFreq=natFreq*lgDecrement; % modified circular frequency of damping

        % Harmonic Variables
        revPerSec = 0;
        if speedVehicle==critSpeed
            revPerSec=natFreq; %Revolutions per second
        else
            revPerSec=speedVehicle/tireCircumference;
        end
        circFreqForce=2*pi*revPerSec; % Circular frequency of force

        ampForce=3*revPerSec^2*1000; %Amplitude of force (Need to research range)

        initStatDisp=-pointLoad*bridgeLength^4/(48*bridgeLength*damage*intertia); % Initial Static Displacement at pt x
        maxDisp = -Inf;
        for cTime=0:.01:bridgeLength/speedVehicle % Time for vehicle to enter and exit bridge

            % Chapter 1 equations
            disp1=-initStatDisp*sin(vehicleCircFreq*cTime)*sin(pi*.5); %equation 1.41
            % Chapter 2 equations
            disp2=-initStatDisp*...
                (ampForce/pointLoad)*...
                (circFreq^2/((circFreq^2+4*(vehicleCircFreq^2+modCircFreq^2))))*(...
                    sqrt((circFreq^2/circFreqForce^2-1)^2+4*(modCircFreq/circFreqForce)^2)*...
                    sin(circFreqForce*cTime)*sin(vehicleCircFreq*cTime)+...
                    2*(vehicleCircFreq/circFreqForce)*...
                    (cos(circFreqForce*cTime)*cos(vehicleCircFreq*cTime)-exp(-modCircFreq*cTime)*cos(circFreq*cTime))...
                )*sin(pi*.5); %equation 2.7 (tested for correctness)
            %  Deflection Totals
            totalDisp=abs(disp1+disp2);
            if(totalDisp > maxDisp)
                maxDisp = totalDisp;
            end
        end

        % results(trial,:,day) = [label, damange, maxDisp, natFreq, cStiffness, modifiedDensity, cMass, speedVehicle, pointLoad, tempAct, relativeHumidity, day];
        results(trial,:,day) = [label, modifiedDensity, maxDisp, tempAct];
    end
end

% Convert the 3d matrix into a 2d training set
bridgeData = permute(results,[1 3 2]);
bridgeData = reshape(bridgeData,[],size(results,2),1);

save('../data/singleBridgeData.mat','bridgeData')


