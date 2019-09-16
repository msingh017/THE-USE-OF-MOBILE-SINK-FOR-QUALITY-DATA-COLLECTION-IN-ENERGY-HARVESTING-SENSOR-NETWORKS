 function [utilityGain,collectedData] = futuredata(N,x,y,dgr,radius,xpath,ypath)
num_sensor=200; %no of sensors1 
L=18000;         %path length
rs=10;           %speed of mobile sink
T=L/rs;         %tour time of mobile sink
t=1;            %duration of each time slot
num_slot=T/t;   %number of time slots
Rmax=200;       %maximum transmission range

MaxEnergyCapacity_Sensors = zeros(1,num_sensor);            % maximum energy capacity of sensors
EnergyBudget_Sensors = ceil(randperm(200,num_sensor));      % Energy budget of sensors in unit Joule


[datamatrix]=generateDataMatrix(num_sensor,num_slot);  %calling the function



%disp datamatrix

P=zeros(1,num_sensor);                  %transmission power of each sensor

dist=zeros(1,num_sensor);                %initalizing a distance matrix    
trate=zeros(num_slot,num_sensor);        %initializing a matrix to store tranmission rate of sensors
for i = 1 : num_sensor
   
    MaxEnergyCapacity_Sensors(i) = ceil(rand()*5) + EnergyBudget_Sensors(i); 
    P(i)=  ceil(rand()*20);               %inputing the power of sensors
end 
%computing the distance array
d=0;
for i= 1 : num_sensor
   
    d=abs(x(i)-L);
    if(d<Rmax)
        dist(i)=2*(sqrt(Rmax) - sqrt(d));
    end 
    clear d;
end
% computing the transmission matrix
for i= 1 : num_sensor
    for j= 1 : num_slot
        if (dist(i)>=0 && dist(i)<=20)
            trate(i,j)=250;
        elseif (dist(i)>20 && dist(i)<=50)
                trate(i,j)=19.2;
        elseif (dist(i)>50 && dist(i)<=120)
            trate(i,j)=9.6;
        else
            trate(i,j)=4.8;
        end
    end
end
Energy_consumption=zeros(num_sensor,num_slot);
 
%updating energy
for i= 1 : num_sensor
    for j= 1 : num_slot 
        Energy_consumption(i,j) = P(i)*t;
    end
end
 
x=zeros(num_sensor,num_slot);   %computing the matrix to find whether a sensor can communicate with the mobile sink
for i= 1 : num_sensor
    for j= 1 : num_slot
        if (dist(i)<=Rmax)
            x(i,j)=1;
        else
            x(i,j)=0;
        end
    end
end

collectedData = zeros(1,num_sensor);  %array to store data collected by individual sensors
utilityGains = zeros(1,num_sensor);    %array to store the utility gain of sensors

for j=1:num_slot
    for i=1:num_sensor
        futureData=0;
        for t= j+1 : num_slot
            
                
            futureData= futureData + datamatrix(i,t); 
            
            
        end
               utilityGains(i)=sqrt(datamatrix(i,j) - futureData + collectedData(i)) - sqrt(collectedData(i)); %computing the updated utility function
  %calculating utilitygain
    end
    maxGainNode=1;
    maxGain = utilityGains(1);
    for i = 1:num_sensor
        if(utilityGains(i) > maxGain) %update maxgain
            maxGain=utilityGains(i);
            maxGainNode=i;
        end
    end
    utilityGain=sort(utilityGains);
    collectedData(maxGainNode) = collectedData(maxGainNode) + datamatrix(maxGainNode,j);
    display(" "+maxGainNode+" "+collectedData(maxGainNode)); %displaying the alloted slot alongwith data collected from that slot
end


end

