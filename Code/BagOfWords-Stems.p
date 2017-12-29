import numpy, os, re
from numpy import linalg
from collections import Counter
pathUSB = '/export/mathcs/home/student/e/ebrenna8/Kaggle/StemFiles/'
pathGood = pathUSB+'gAll'
pathBad = pathUSB + 'bAll'
trainDir = pathUSB + 'training/subset/'
#trainDir = '/export/mathcs/home/student/e/ebrenna8/Kaggle/devSet/reg/combined/'
devDir = pathUSB + 'dev/'
numFiles =10
N = 3
#Generate list of words used in training data (bag)
fG = open(pathGood,'r')
fB = open(pathBad, 'r')

bag1=Counter(fG.read().split())
bag2 = Counter(fB.read().split())
bag = bag1 + (bag2)
#for i in fB.read().split():
#        try:
#		bag[i] +=1
#	except:
#		bag[i] = 1

fG.close()
fB.close()

fG = open(pathGood, 'r')
fB = open(pathBad, 'r')

#Using word list, iterate through training examples and create numpy arrays
#the last element is whether the training data comes from + or - sentiment

trainVec = numpy.zeros((numFiles,len(bag)))

trClass = numpy.zeros(numFiles)
fileCount = 0

for f in os.listdir(trainDir):
        #fileCount +=1
	print f
        f1 = open(trainDir + f, 'r')
	
        fBag = Counter(f1.read().split())
	
        wordCount = 0
        #print bag
	
        for w in list(bag):
		
		trainVec[fileCount, wordCount] = fBag[w]
                wordCount +=1
          
        
        
        if 'g' in f:
                trClass[fileCount] = 1
        else:
                trClass[fileCount] = 0
        fileCount +=1
        if((fileCount % 1000)==0):
                print 'Training Vector number...' + str(fileCount)
        #print numpy.nonzero(trainVec[fileCount-1,:])

	#print numpy.nonzero(trainVec[fileCount, :])	
#Now, move into section for processing dev set
_nsre = re.compile('[0-9]+')
def natural_sort_key(s):
        return [int(text) if text.isdigit() else text.lower()
                for text in re.split(_nsre,s)]
cnt = 0
for f in sorted(os.listdir(devDir), key=natural_sort_key):
        cnt +=1
        devVect = numpy.zeros((1, len(bag)))
       	print f 
        comparisonVect = numpy.zeros((2, numFiles))
        neighborsList = []
        f1 = open(devDir + f, 'r')
        dBag = Counter(f1.read().split())
        wordCount = 0
        #print list(dBag)
        for w in list(bag):
                
                devVect[0,wordCount] = dBag[w]
                wordCount +=1
	#print numpy.nonzero(devVect[0,:])
        
	lCount = 0
#	print numpy.nonzero(trainVec[0,:])
	#a = numpy.empty([numFiles, len(list(bag))])
        for n in range(0,numFiles):
	
                #print n
                a = trainVec[n:]
		#print numpy.nonzero(a)
                comparisonVect[0,lCount] = numpy.linalg.norm(a - devVect)
                #print comparisonVect[0,lCount]
                comparisonVect[1,lCount]=lCount
		lCount +=1
        #nl = sorted(comparisonVect,key=lambda y: y[0])
        #print nl
        
        c = numpy.array(comparisonVect[0,:])
        i = numpy.argsort(c)
        newOrder= comparisonVect[:,i]
        
        

	#comparisonVectSafe = comparisonVect
        #comparisonVect.sort(axis=1) 
        #print comparisonVect 
	#for t in range(0,N):
         #       neighborsList.append(numpy.where(comparisonVectSafe == (comparisonVect[0,t])))  
	#print neighborsList	
        
        #Finally, map the neighbors rows in the training stack to 'p' or 'n'
        s = 0
	#print list(neighborsList)
	#print comparisonVectSafe.flatten().index(comparisonVectSafe == comparisonVect[0,t])
	#nl = neighborsList.flatten()
        #print nl
        for t in range(0, N-1):
                print t
                print trClass
                s +=trClass[newOrder[0,t]]
	print 'score: ' +  str(s/float(N)) + 'filename: '+ f
        if (s/float(N) >= 0.5) and 'g' in f:
                #print str(fileCount) + ',P'
                print str(cnt) + 'correct'
        elif (s/float(N) < 0.5) and 'b' in f:
                print str(cnt) + 'correct'
        else:
                print str(cnt) + 'incorrect'
                #print str(fileCount) + ',N'
                
                
                                                
                
                        
                
