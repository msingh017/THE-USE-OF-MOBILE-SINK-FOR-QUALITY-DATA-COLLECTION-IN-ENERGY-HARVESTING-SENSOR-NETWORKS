function [ nss , ss , subsink_point_on_line , subsink_startpoint_on_line , subsink_endpoint_on_line, a , b   ] = CalculateRandomRangeSubsink( sl , el, radius, N, v, x, y, dgr, dtr  )
a = el(2) - el(1);   % Change in y cordinate (y2 - y1)
b = sl(2) - sl(1);   % Change in x cordinate (x2 - x1)
p = sl(1);  
q = el(1);
r = sqrt((  a^2 +  b  ^2 ));
% % nss is used to count the total number of sub-sink
nss = 0;
ss = []; %matrix stores perpedicular length, delivery time, id,  and intersected length of every sub-sink
for i = 1: N
    %   length = absolute value of ((y2-y1)x - ( x2-x1)y + x2y1 - x1y2) / r  Find the perpendicular distance of each sensors from the Mobile Collector Projectile  Straight Path
    s = (( a * x(i)   -  b  * y(i)  - p * a + q * b) / r ) ;
    if s < 0
        s = -s;
    end
    
    if s <= radius(i)
        nss = nss + 1;
        ss(1, nss) = s;  %%perpendicular length
        ss(2, nss) = i;   %% IDs of sub-sinks
        ss(3, nss) = radius(i); %% Communication range of sub-sinks
    end
end
%% Find the delivery time of each sub-sink
for i = 1 : nss
    ss(4,i) = ceil((2 * sqrt( ss(6,i) ^ 2 - ss(1,i)^2  ) ) / v);       % Delivery time of each subsink
    ss(5,i) = (2 * sqrt( ss(6,i) ^ 2 - ss(1,i)^2  ) );           % Intersected length of each subsink along the projected line
    
end

%% To find the cordinate of the point on the line from where a line of perpendicular is drawn  to the subsink point, startpoint and endpoint
% formula to find point on the line x = (b( bxo - ayo) - ac)/ ( a^2 + b^2)
%                                   y =( a(-bx0 + ayo) - bc ) /( a^2 + b^2)
subsink_point_on_line = zeros( 3,  nss);
subsink_startpoint_on_line = zeros(4, nss);
subsink_endpoint_on_line = zeros(4, nss);
% Formula to find a point at  d distance from a point(xo,yo) along a
% straight line x1 = x1 + d / sqrt ( 1 + m^2) and y1 = yo + (y2 - y1 )
for i=1: nss
    subsink_point_on_line(1,i) = ( b^2 * x(ss(3,i)) + a * b * y(ss(3,i)) - a * b * q + a^2 * p )/ r^2 ;
    subsink_startpoint_on_line(1,i) = subsink_point_on_line(1,i) - (sqrt( ss(6,i) ^ 2 - ss(1,i)^2)) / sqrt( 1 + (-1 * a)^2 / (-1 * b)^2) ;
    subsink_endpoint_on_line(1,i) = subsink_point_on_line(1,i) + (sqrt(ss(6,i) ^ 2 - ss(1,i)^2)) / sqrt(1 + (-1 * a)^2 / (-1 * b)^2);
    subsink_point_on_line(2,i) = ( a * b * x(ss(3,i)) + a * a * y(ss(3,i)) + b * b * q - a * b * p )/ r^2;
    subsink_startpoint_on_line(2,i) = subsink_point_on_line(2,i) - sqrt( ss(6,i) ^ 2 - ss(1,i)^2);
    subsink_endpoint_on_line(2,i) = subsink_point_on_line(2,i) + sqrt( ss(6,i) ^ 2 - ss(1,i)^2);
    subsink_startpoint_on_line(3,i) = ss(3,i);
    subsink_endpoint_on_line(3,i) = ss(3,i);
end
for i = 1: nss
    if  subsink_startpoint_on_line(1,i) <= sl(1) &&  subsink_startpoint_on_line(2,i) < el(1)
        subsink_startpoint_on_line(1,i) = sl(1);
        subsink_startpoint_on_line(2,i) = el(1);
    end
    if  subsink_startpoint_on_line(1,i) <= sl(2) &&  subsink_startpoint_on_line(2,i) < el(2) &&  subsink_endpoint_on_line(1,i) >= sl(2) && subsink_endpoint_on_line(2,i) > el(2)
        subsink_endpoint_on_line(1,i) = sl(2);
        subsink_endpoint_on_line(2,i) = el(2);
    end
    distance = sqrt( (subsink_startpoint_on_line(1,i) - subsink_endpoint_on_line(1,i))^2 + (subsink_startpoint_on_line(2,i) - subsink_endpoint_on_line(2,i))^2);
    ss(5,i) = distance;
    subsink_point_on_line(1,i) = (subsink_startpoint_on_line(1,i) + subsink_endpoint_on_line(1,i))/2;
    subsink_point_on_line(2,i) = (subsink_startpoint_on_line(2,i) + subsink_endpoint_on_line(2,i))/2;
    ss(4,i) = ceil(distance / v);
    
end

end


