clear all;
close all; 
global ctr;
ctr = 0;
N = 200;
total_inputdata = 10000;
[xold,yold,dgrold,radiusold]  = findrandomxy(total_inputdata);
xpath = [200 18200]; %defining the x-path
ypath = [200 390];    %defining the y-path
k =1;
for tt = 1 : k
    
   
   for i = ctr +1 : ctr + N
       x(i) = xold(i);
       y(i) = yold(i);
       dgr(i) = dgrold(i);
       radius(i) = radiusold(i);
   end
   ctr = ctr + N;
       
    
    %calling the functions
    
     [P_UtilityGain]=demo(N,x,y,dgr,radius,xpath,ypath);
    % [UtilityGain2]=demo2();
    % [UtilityGain3]=demo3();
    % [UtilityGain4]=demo4();
   [F_utilityGain] = futuredata(N,x,y,dgr,radius,xpath,ypath);
    
    plot(P_UtilityGain,'r');
    hold on;
    % plot(UtilityGain2);
    % hold on;
    % plot(UtilityGain3,'g');
    % hold on;
    % plot(UtilityGain4,'b');
    %
    plot(F_utilityGain);
    
    tt = tt + 1;
end
