function [datamatrix] = generateDataMatrix(num_sensor,num_slot)
datamatrix=zeros(num_sensor,num_slot);
for i=1:num_sensor
    start=(num_slot-(num_slot/4))*rand;
    start=ceil(start);
    size=(num_slot*4)/rand;
    size=ceil(size);
    ending=start+size;
    for j=1:start
        datamatrix(i,j)=0;
    end
    for j=start+1:ending
         x=100*rand;
         if(x<10)
             x=x+10;
         end
         datamatrix(i,j)=ceil(x);
    end
    for j=ending+1 : num_slot
        datamatrix(i,j)=0;
    end


end

