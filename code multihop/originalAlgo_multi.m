function [collectedData_multi] = originalAlgo_multi(N, numTimeSlots, dataMatrix_multi)

collectedData_multi=zeros(1,N);
   
	for j =1:numTimeSlots
		utilityGains_multi = [];
		for i=1:N
            
            z = sqrt(dataMatrix_multi(i,j) + collectedData_multi(i)) - sqrt(collectedData_multi(i));%computing utility gain
			utilityGains_multi=[utilityGains_multi z];
        end
		maxGainNode_multi = 1;
		maxGain_multi = utilityGains_multi(1);%choosing the index of the sensor with the highest utility gain
		for i =1: N
			if(utilityGains_multi(i) > maxGain_multi)
				maxGain_multi = utilityGains_multi(i);
				maxGainNode_multi = i;
            end
        end    
		collectedData_multi(maxGainNode_multi) = collectedData_multi(maxGainNode_multi) + dataMatrix_multi(maxGainNode_multi,j);%in the end updating the collected data of the chosen sensor
        
    end   
    disp(collectedData_multi);
end
