function [collectedData_multi]= ourAlgo_multi(N, numTimeSlots, dataMatrix_multi)

collectedData_multi = [];
    for i = 1: N
		collectedData_multi=[collectedData_multi 0];%collected data of each sensor..is used as past data in the calculation of utility gain
    end
    %disp(dataMatrix);
   	for j =1:numTimeSlots
		utilityGains = [];
       for i=1:N
			futureData = 0;
            for t = j+1: numTimeSlots
				futureData = futureData + dataMatrix_multi(i,t);%calculating future data
            end
            %disp(futureData);
            
            sum=dataMatrix_multi(i,j) + futureData + collectedData_multi(i);
            z=sqrt(sum) - sqrt(futureData) - sqrt(collectedData_multi(i));%computing utility gain 
			utilityGains=[utilityGains z];
       end
        
		maxGainNode = 1;
		maxGain = utilityGains(1);%choosing the index of the sensor with the highest utility gain
        for i =1: N
            if(utilityGains(i) > maxGain)
				maxGain = utilityGains(i);
				maxGainNode = i;
            end
         end 
        
		collectedData_multi(maxGainNode) = collectedData_multi(maxGainNode) + dataMatrix_multi(maxGainNode,j);%in the end updating the collected data of the chosen sensor
       
        
    end
    disp(collectedData_multi);
end

