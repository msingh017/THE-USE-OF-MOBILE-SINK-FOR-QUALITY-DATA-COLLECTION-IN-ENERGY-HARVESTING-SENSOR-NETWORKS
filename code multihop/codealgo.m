%THIS CODEALGO IS ACTUALLY THE MAINSCRIPT FOR MULTIHOP

	% numTimeSlots = int(input("Enter no of Time Slots: "))
	% numNodes = int(input("Enter no of Sensor Nodes: "))
	ourFindings = [];
	theirFindings = [];

	nodes = 200; % min no of nodes for which this code runs
	max_nodes = 600; % max no of nodes for which this code runs
	timeSlots = 200; % min no of timeslots for which this code runs
	max_timeSlots = 600; % max no of timeslots for which this code runs
	steps = 100; % this means code runs for nodes, nodes+100, nodes+200 and so on upto max_nodes and the same for the no of timeslots
	

	for n = nodes:steps:max_nodes
		ourTemp = [];
		theirTemp = [];
		
		for t = timeSlots:steps:max_timeSlots
			numTimeSlots = t;%no of time slots
			numNodes = n;%no of nodes

			numOfIterations = 10; 

			ourDiffSum = 0;%sum of max-min difference is stored in it to calculate average further according to our approach
			theirDiffSum = 0;% same for their approach
			ourVarSum = 0;%sum of variance is stored in it to calculate avg variance further
			theirVarSum = 0;
            hold off; %used for plotting purpose

			for i=1:numOfIterations
                
                N = n ;   % number of circles/nodes
                r = t/10 ; % radius of circle
                C = randi([r t-r],N,2) ;%randomly assigning centers for the sensors
                hold off;
                th = linspace(0,2*pi) ;
                x = r*cos(th) ;
                y = r*sin(th) ;
                % Loop for each circle
                for i = 1:N
                    xc = C(i,1)+x ;
                    yc = C(i,2)+y ;
                    %hold on
                    plot(xc,yc) ;
                    hold on
                end
                plot([0,t],[t/2,t/2],'r','Linewidth',2);%plotting line on which the sink moves
                axis equal;
                axis([0 t 0 t]);%plotting axis

                %disp(C);
                onpath=[];%array to store on path sensors
                for i = 1:N
                    d = abs(C(i,2)-t/2);
                    if(d<r)
                        onpath = [onpath i];
                    end
                end
                %disp(onpath);
                s = size(onpath,2);
                adj_matrix = zeros(N,N);%making adjacency matrix for the deployed sensors based on the distance between each other
                for i=1:N
                    for j = 1:N
                        if(i~=j)
                            d = (C(i,1)-C(j,1))*(C(i,1)-C(j,1))+(C(i,2)-C(j,2))*(C(i,2)-C(j,2));
                            k = sqrt(d);
                            if(k<r)%if the distance is less than comm. range, corresponding cell in adj matrix is set to 1
                                adj_matrix(i,j)= 1;
                            end
                        end
                    end
                end
                %disp(adj_matrix);
                gplot(adj_matrix,C);%plotting graph using adj matrix...not really necessary
                hold on;
                G = graph(adj_matrix);%forming graph using adj matrix
                figure(2);
                plot(G);
                hold on;
                nodes_matrix= zeros(s,N);%this matrix stores every node that can communicate with the straight line through any no of relays possible
                for i=1:s
                    temp=[];
                    temp = bfsearch(G,onpath(i)); %bfs is applied using every onpath node as starting index and the nodes obtained are stored in nodes matrix in which the the first column contains onpath sensors  
                    k=1;
                    ss = size(temp,1);
                    for j=1:ss
                        nodes_matrix(i,k)=temp(j);
                        k=k+1;
                    end
                end 
                %disp(nodes_matrix);
                dataMatrix_multi=generateDataMatrix_multi(onpath,C,r,s,N,nodes_matrix,t);
                collectedData_original_multi=originalAlgo_multi(N, t, dataMatrix_multi);
                collectedData_our_multi=ourAlgo_multi(N,t,dataMatrix_multi);

				% plotData(numNodes,collectedDataOriginal,collectedData)

				ourDiff = max(collectedData_our_multi) - min(collectedData_our_multi);
				ourVar = var(collectedData_our_multi,1);

				theirDiff = max(collectedData_original_multi) - min(collectedData_original_multi);
				theirVar = var(collectedData_original_multi,1);

				ourDiffSum = ourDiffSum + ourDiff;
				theirDiffSum = theirDiffSum + theirDiff;
				ourVarSum = ourVarSum + ourVar;
				theirVarSum = theirVarSum + theirVar;

				% print("OUR   >> diff: " + str(ourDiff) + "\tvar: " + str(ourVar)) 
				% print("THEIR >> diff: " + str(theirDiff) + "\tvar: " + str(theirVar)) 
            end
			ourAvgVar = ourVarSum./numOfIterations;
            %disp(ourAvgVar);
			theirAvgVar = theirVarSum./numOfIterations;
            %disp(theirAvgVar);
            %X= sprintf('*** N= %s  ****** T= %s  ***',n,t);
            %disp(X);
            X=['*** N=',num2str(n),' ****** T=',num2str(t),' ***'];
            disp(X);
            X= ['AVG OUR DIFF: ',num2str(ourDiffSum./numOfIterations),' AVG OUR VAR: ',num2str(ourVarSum./numOfIterations)];
            disp(X);
			%disp('AVG OUR DIFF:   ",(ourDiffSum/numOfIterations),"\tAVG OUR VAR  : ,(ourVarSum/numOfIterations)');
			X=['AVG THEIR DIFF: ',num2str(theirDiffSum./numOfIterations),' AVG THEIR VAR: ',num2str(theirVarSum./numOfIterations)];
            disp(X);
			ourTemp = [ourTemp ourAvgVar];
			theirTemp = [theirTemp theirAvgVar];
			disp (ourTemp);
			disp (theirTemp);
			disp ("-----------");
        end
		ourFindings = [ourFindings ourTemp];
		theirFindings = [theirFindings theirTemp];                         
    end    
	disp (ourFindings);
	fprintf("\n");
	disp (theirFindings);

	%plotFindings(ourFindings, theirFindings, nodesStart, nodesEnd, timeSlotsStart, timeSlotsEnd, steps, maxDuration)















