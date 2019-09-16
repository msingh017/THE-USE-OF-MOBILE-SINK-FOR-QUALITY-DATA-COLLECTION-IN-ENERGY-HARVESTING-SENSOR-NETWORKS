function[dataMatrix_multi] = generateDataMatrix_multi(onpath,C,r,s,N,nodes_matrix,numtimeslots)
   start_end = zeros(N,2); %assigning start and end to all the sensors that can communicate
   disp(s);
   for i=1:s
       perpendicular = abs(C(onpath(i),2)-250);
       disp(perpendicular);
       size = sqrt(r*r-perpendicular*perpendicular);%using pythagoras theorem
       start_end(onpath(i),1) = C(onpath(i),1)-size;
       start_end(onpath(i),2) = C(onpath(i),1)+size;
   end
  disp(start_end);
  dataMatrix_multi=zeros(N,numtimeslots);%data matrix for input defining data of each sensor in each timeslot  
for i=1:s
    for j=1:N
        start=ceil(start_end(nodes_matrix(i,1),1));
        ending=ceil(start_end(nodes_matrix(i,1),2));
        for k=start:ending
             x = 100*rand;
             if(x<10)
                x=x+10;
             end   
             if(nodes_matrix(i,j)~=0)
                dataMatrix_multi(nodes_matrix(i,j),k)=x;
             end
        end
    end
end
disp(dataMatrix_multi);
end
        
    
    