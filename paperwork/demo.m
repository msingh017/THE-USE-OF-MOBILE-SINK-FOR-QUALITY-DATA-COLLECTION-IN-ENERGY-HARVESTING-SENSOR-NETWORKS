function [UtilityGain] = demo()
N=100;      %no of sensors1 
L=1000;      %path length
rs=5;       %speed of mobile sink
T=L/rs;      %tour time of mobile sink
t=1;         %duration of each time slot
n=T/t;       %number of time slots
Rmax=200;    %maximum transmission range
MaxEnergyCapacity_Sensors = zeros(1,N); % maximum energy capacity of sensors
EnergyBudget_Sensors = ceil(randperm(100,N));      % Energy budget of sensors in unit Joule
 [mdata]=generateDataMatrixOld(N);  % Initial data of sensors in unit KB6*
 mobdata=0;                       %data collected by sink
P=zeros(1,N);                 %transmission power of each sensor
x_loc=ceil(randperm(100,N));                % x co-ordinate of sensors
                  % y co-ordinate of sensors
dist=zeros(1,N);                        
trate=zeros(n,N);                   %matrix to store tranmission rate of sensors
for i = 1 : N
   
    MaxEnergyCapacity_Sensors(i) = ceil(rand()*5) + EnergyBudget_Sensors(i); 
    P(i)=  ceil(rand()*20);
end 
%computing the distance array

for i= 1 : N
    d=abs(x_loc(i)-L);
    if(d<Rmax)
        dist(i)=2*(sqrt(Rmax) - sqrt(d));
    end 
    clear d;
end
% computing the transmission matrix
for i= 1 : N
    for j= 1 : n
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
Energy_consumption=zeros(N,n);
 
%updating energy
for i= 1 : N
    for j= 1 : n
        Energy_consumption(i,j) = P(i)*t;
    end
end
 
% centralized algorithm
x=zeros(N,n);
for i= 1 : N
    for j= 1 : n
        if (dist(i)<=Rmax)
            x(i,j)=1;
        else
            x(i,j)=0;
        end
    end
end
utility_gain=zeros(1,N);
collectedDataOriginal=zeros(1,N);
for j= 1 : n
     
    for i= 1 : N
        if((x(i,j)==1))
            utility_gain(i)= sqrt(mdata(i)+collectedDataOriginal(i))-sqrt(collectedDataOriginal(i));
            
            
        end
        
    end
    maxGainNode = 1;
    maxGain = 0;
    for i= 1 : N
            if(utility_gain(i) > maxGain)
                maxGain = utility_gain(i);
                maxGainNode = i ;
            end
    end 
    
    
    collectedDataOriginal(maxGainNode) = collectedDataOriginal(maxGainNode) + mdata(maxGainNode);
    
    EnergyBudget_Sensors(maxGainNode)=abs(EnergyBudget_Sensors(maxGainNode)-Energy_consumption(maxGainNode,j));
    display(" "+maxGainNode+" "+collectedDataOriginal(maxGainNode));
    
end
UtilityGain=sort(utility_gain);
      
    
          
 
 
       
 
 
 
 
 
 


end

