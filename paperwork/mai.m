[UtilityGains]=demo();
[utilityGain] = futuredata(); 
% %nodesStart = 100;
% %nodesEnd = 201;
% %timeSlotsStart = 100;
% %timeSlotsEnd = 201;
% steps = 100;
% maxDuration = 15;
% for n = nodesStart : nodesEnd
%     
%         
% 		numNodes = n;
% 
% 		numOfIterations = 5;
% 
% 		ourDiffSum = 0;
% 		theirDiffSum = 0;
% 		ourVarSum = 0;
% 		theirVarSum = 0;
%         for i = 1 : numOfIterations
%             [collectedDataOriginal] = demo();
%             [collectedData] = futuredata();
%             
%             ourDiff = max(collectedData) - min(collectedData);
%             ourVar = var(collectedData);
%             
%             theirDiff = max(collectedDataOriginal) - min(collectedDataOriginal);
% 			theirVar = var(collectedDataOriginal);
%             
%             ourDiffSum = ourDiffSum + ourDiff;
% 			theirDiffSum = theirDiffSum + theirDiff;
% 			ourVarSum = ourVarSum + ourVar;
% 			theirVarSum = theirVarSum + theirVar;
%         end
%         ourAvgVar = ourVarSum/numOfIterations;
% 		theirAvgVar = theirVarSum/numOfIterations;
%         plot(n,ourAvgVar,'r:',n,theirAvgVar,'k:');
% end 
%         

