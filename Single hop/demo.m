function [UtilityGain,collectedDataOriginal] = demo(N,x,y,dgr,radius,xpath,ypath)
N=200;      %no of sensors1 
L=18000;      %path length
rs=10;       %speed of mobile sink
T=L/rs;      %tour time of mobile sink
t=1;         %duration of each time slot
n=T/t;       %number of time slots
Rmax=200;    %maximum transmission range
MaxEnergyCapacity_Sensors = zeros(1,N); % maximum energy capacity of sensors
EnergyBudget_Sensors = ceil(randperm(200,N));      % Energy budget of sensors in unit Joule
 %[mdata]=generateDataMatrixOld(N);  % Initial data of sensors in unit KB6*
 %[mdata]=generateDataMatrixOld(N);  
 
 %sum=zeros(N);
P=zeros(1,N);                 %transmission power of each sensor
%dist=zeros(1,N);                        
trate=zeros(n,N);                   %matrix to store tranmission rate of sensors
for i = 1 : N
   
    MaxEnergyCapacity_Sensors(i) = ceil(rand()*5) + EnergyBudget_Sensors(i); 
    P(i)=  ceil(rand()*20);
end 
%computing the distance array
a = ypath(2) - ypath(1);   % Change in y cordinate (y2 - y1)
b = xpath(2) - xpath(1);   % Change in x cordinate (x2 - x1)
p = xpath(1);  
q = ypath(1);
r = sqrt((  a^2 +  b  ^2 ));
% % nss is used to count the total number of sub-sink
nss = 0;
ss = []; %matrix stores perpedicular length, delivery time, id,  and intersected length of every sub-sink
for i= 1 : N
    %d=abs(x_loc(i)-L);
     d=abs((( a * x(i)   -  b  * y(i)  - p * a + q * b) / r )) ;
    if(d<Rmax)
        %dist(i)=2*(sqrt(Rmax) - sqrt(d));
       nss = nss + 1;
        ss(1, nss) = d;  %%perpendicular length
        
        dist(i)=2*(sqrt(Rmax) - sqrt(d));
    end 
    %clear d;
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
xl=zeros(N,n);
for i= 1 : N
    for j= 1 : n
        if (dist(i)<=Rmax)
            xl(i,j)=1;
        else
            xl(i,j)=0;
        end
    end
end
utility_gain=zeros(1,N);           %array to store the utility gain of sensors
collectedDataOriginal=zeros(1,N);  %array to store the data collected by sensors
for j= 1 : n
     
    for i= 1 : N
        if((xl(i,j)==1))
            utility_gain(i)= sqrt(dgr(i)+collectedDataOriginal(i))-sqrt(collectedDataOriginal(i));
            %computing the utility function
            
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
 
    
    collectedDataOriginal(maxGainNode) = collectedDataOriginal(maxGainNode) + dgr(maxGainNode);
    
    EnergyBudget_Sensors(maxGainNode)=abs(EnergyBudget_Sensors(maxGainNode)-Energy_consumption(maxGainNode,j));
    %updating the energy budget
    display(" "+maxGainNode+" "+collectedDataOriginal(maxGainNode));
    
end
UtilityGain=sort(utility_gain); 
 
    
  

end

