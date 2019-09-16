
# coding: utf-8

import numpy as np
import matplotlib.pyplot as plt
import math
from random import randint


def plotFindings(ourFindings, theirFindings, nodesStart, nodesEnd, timeSlotsStart, timeSlotsEnd, steps, maxDuration):
	numNodes = 1 + (int)((nodesEnd-1 - nodesStart)/steps)
	numTimeSlots = 1 + (int)((timeSlotsEnd - timeSlotsStart)/steps)

	nodes = []
	for i in range(nodesStart, nodesEnd, steps):
		nodes.append(i)

	timeSlots = []
	for i in range(timeSlotsStart, timeSlotsEnd, steps):
		timeSlots.append(i)

	ourNodesVar = []
	theirNodesVar = []
	for n in range(0, numNodes):
		ourTotal = 0
		theirTotal = 0
		for t in range(0, numTimeSlots):
			ourTotal = ourTotal + ourFindings[n][t]
			theirTotal = theirTotal + theirFindings[n][t]

		ourNodesVar.append(ourTotal/numTimeSlots)
		theirNodesVar.append(theirTotal/numTimeSlots)

	ourTimeSlotVar = []
	theirTimeSlotVar = []

	for t in range(0, numTimeSlots):
		ourTotal = 0
		theirTotal = 0
		for n in range(0, numNodes):
			ourTotal = ourTotal + ourFindings[n][t]
			theirTotal = theirTotal + theirFindings[n][t]

		ourTimeSlotVar.append(ourTotal/numNodes)
		theirTimeSlotVar.append(theirTotal/numNodes)

	# plt.figure(2)

	plt.subplot(211)
	plt.plot(nodes, ourNodesVar, label = 'our')
	plt.plot(nodes, theirNodesVar, label = 'their')
	plt.xlabel('number of nodes')
	plt.ylabel('average variance over \n varying number of timeslots')
	plt.title("Max number of time slots one sensor can send data = " + str(maxDuration))
	plt.legend(loc = 'best')

	plt.subplot(212)
	plt.plot(timeSlots, ourTimeSlotVar, label = 'our')
	plt.plot(timeSlots, theirTimeSlotVar, label = 'their')
	plt.xlabel('number of timeslots')
	plt.ylabel('average variance over \n varying number of nodes')
	plt.legend(loc = 'best')
	plt.show()








def plotData(noOfSensorNodes,original,ourApproach):

    ind = np.arange(noOfSensorNodes)  # the x locations for the sensor nodes
    width = 0.27       # the width of the bars


    fig = plt.figure()
    ax = fig.add_subplot(111)
    rects1 = ax.bar(ind, original, width, color='r') 
    rects2 = ax.bar(ind+width, ourApproach, width, color='b')

    ax.set_ylabel('Data sent')
    ax.set_xticks(ind+width)

    xlabel = []
    for i in range(1,noOfSensorNodes+1):
        xaxis = "sensor" + str(i)
        xlabel.append(xaxis)

    ax.set_xticklabels( xlabel )
    ax.legend( (rects1[0], rects2[0]), ('2013 paper', 'Our approach') )

    def autolabel(rects):
        for rect in rects:
            h = rect.get_height()
            ax.text(rect.get_x()+rect.get_width()/2., 1.05*h, '%d'%int(h),
                    ha='center', va='bottom')

    autolabel(rects1)
    autolabel(rects2)
    picName = "result-" +str(noOfSensorNodes)
    # fig.savefig(picName)
    plt.show()



def generateDataMatrix(numNodes, numTimeSlots, maxDuration):
	dataMatrix = []
	for i in range(0, numNodes):
		temp = []
		start = randint(0, numTimeSlots)
		size = randint(0, maxDuration)
		end = start + size
		# print("START: " + str(start) + " END: " + str(end))
		for j in range(0, start):
			temp.append(0)

		for j in range(start, end):
			temp.append(randint(10, 100))

		for j in range(end, numTimeSlots):
			temp.append(0)

		# print temp
		dataMatrix.append(temp)

	return dataMatrix



def generateDataMatrixOld(numNodes, numTimeSlots):
	dataMatrix = []
	for x in range(0,numNodes):
		temp = []
		for y in range(0,numTimeSlots):
			value = randint(0, 50)
			temp.append(value)
			
		dataMatrix.append(temp)
		# print(dataMatrix[x])
	
	return dataMatrix





def ourAlgo(numNodes, numTimeSlots, dataMatrix):
	collectedData = []
	for i in range(0, numNodes):
		collectedData.append(0)

	for j in range(0, numTimeSlots):
		utilityGains = []
		for i in range(0, numNodes):
			futureData = 0
			for t in range(j+1, numTimeSlots):
				futureData = futureData + dataMatrix[i][t]

			utilityGains.append(math.sqrt(dataMatrix[i][j] + futureData + collectedData[i]) - math.sqrt(futureData) - math.sqrt(collectedData[i]))

		maxGainNode = 0
		maxGain = utilityGains[0]
		for i in range(1, numNodes):
			if(utilityGains[i] > maxGain):
				maxGain = utilityGains[i]
				maxGainNode = i

		collectedData[maxGainNode] = collectedData[maxGainNode] + dataMatrix[maxGainNode][j]

	return collectedData




#ORIGINAL ALGO
def originalAlgo(numNodes, numTimeSlots, dataMatrix):
	collectedDataOriginal = []
	for i in range(0, numNodes):
		collectedDataOriginal.append(0)

	for j in range(0, numTimeSlots):
		utilityGains = []
		for i in range(0, numNodes):
			utilityGains.append(math.sqrt(dataMatrix[i][j] + collectedDataOriginal[i]) - math.sqrt(collectedDataOriginal[i]))

		maxGainNode = 0
		maxGain = utilityGains[0]
		for i in range(1, numNodes):
			if(utilityGains[i] > maxGain):
				maxGain = utilityGains[i]
				maxGainNode = i

		collectedDataOriginal[maxGainNode] = collectedDataOriginal[maxGainNode] + dataMatrix[maxGainNode][j]

	return collectedDataOriginal




def main():
	# numTimeSlots = int(input("Enter no of Time Slots: "))
	# numNodes = int(input("Enter no of Sensor Nodes: "))



	ourFindings = []
	theirFindings = []

	nodesStart = 100
	nodesEnd = 201
	timeSlotsStart = 100
	timeSlotsEnd = 201
	steps = 100
	maxDuration = 15

	for n in range(nodesStart, nodesEnd, steps):
		ourTemp = []
		theirTemp = []
		
		for t in range(timeSlotsStart, timeSlotsEnd, steps):
			numTimeSlots = t
			numNodes = n

			numOfIterations = 15

			ourDiffSum = 0
			theirDiffSum = 0
			ourVarSum = 0
			theirVarSum = 0

			for i in range(1, numOfIterations):

				dataMatrix = generateDataMatrix(numNodes, numTimeSlots, maxDuration)
				collectedDataOriginal = originalAlgo(numNodes, numTimeSlots, dataMatrix)
				collectedData = ourAlgo(numNodes, numTimeSlots, dataMatrix)

				# plotData(numNodes,collectedDataOriginal,collectedData)

				ourDiff = max(collectedData) - min(collectedData)
				ourVar = np.var(collectedData)

				theirDiff = max(collectedDataOriginal) - min(collectedDataOriginal)
				theirVar = np.var(collectedDataOriginal)

				ourDiffSum = ourDiffSum + ourDiff
				theirDiffSum = theirDiffSum + theirDiff
				ourVarSum = ourVarSum + ourVar
				theirVarSum = theirVarSum + theirVar

				# print("OUR   >> diff: " + str(ourDiff) + "\tvar: " + str(ourVar)) 
				# print("THEIR >> diff: " + str(theirDiff) + "\tvar: " + str(theirVar)) 

			ourAvgVar = ourVarSum/numOfIterations
			theirAvgVar = theirVarSum/numOfIterations

			print("*** N=" + str(n) + " ****** T=" + str(t) + " ***")
			print("AVG OUR DIFF:   " + str(ourDiffSum/numOfIterations) + "\tAVG OUR VAR  : " + str(ourVarSum/numOfIterations))
			print("AVG THEIR DIFF: " + str(theirDiffSum/numOfIterations) + "\tAVG THEIR VAR: " + str(theirVarSum/numOfIterations))
			ourTemp.append(ourAvgVar)
			theirTemp.append(theirAvgVar)
			print (ourTemp)
			print (theirTemp)
			print ("-----------")

		ourFindings.append(ourTemp)
		theirFindings.append(theirTemp)

	print (ourFindings)
	print 
	print (theirFindings)

	plotFindings(ourFindings, theirFindings, nodesStart, nodesEnd, timeSlotsStart, timeSlotsEnd, steps, maxDuration)

main()


