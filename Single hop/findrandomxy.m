function [ x , y, dgr, radius ] = findrandomxy(total )
dgr = zeros(1,total);
x = randi([200 18200],1,total); %generating random x-coordinate values
y = randi([200 580],1,total);   %generating random y-coordinate values
% ddgr = randi([100 total], 1, total);
radius = zeros(1,total);
temp =  randi([200 200],1,total);
for i = 1 : total
    radius(i) = temp(i);
end
temp = randi([250 1000],1,total);  %generating random input values
for i = 1 : total
    dgr(i) = temp(i);
end
end
