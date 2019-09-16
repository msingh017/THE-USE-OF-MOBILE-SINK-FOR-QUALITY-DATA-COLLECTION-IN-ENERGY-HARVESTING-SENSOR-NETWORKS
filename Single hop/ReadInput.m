function [ x , y, dgr, radius ] = ReadInput(tt, N ) 
M = dlmread('C:\Users\ASUS\Desktop\WSN PROJECT\futurework\inputdata.txt','\t');
k = 1;
for j = ((tt - 1) * N + 1 ) : (tt *N)
    x(k) = M(j,1);
    y(k) = M(j,2);
    radius(k) = M(j,4);
    dgr(k) = M(j,3);
    k = k + 1;
end

end
