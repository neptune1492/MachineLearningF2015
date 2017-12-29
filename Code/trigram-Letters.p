import re
import os, decimal
import math
from collections import Counter
from collections import defaultdict
n=3
f= open('eu-good.txt', 'r')
dictG = defaultdict(int)
for l in f:
        words = l.lower().split()
        for w in words:
                list = [w[i:i+n] for i in range(len(w)-1)]
                for m in list:
                        dictG[m] +=1
f.close()
sumDictG = 0
for l in dictG:
        sumDictG += dictG[l]


f = open('eu-bad.txt', 'r')
dictB = defaultdict(int)
for l in f:
        words = l.lower().split()
        for w in words: 
                list = [w[i:i+n] for i in range(len(w) - 1)]
                for m in list:
                        dictB[m] +=1

f.close()
sumDictB = 0
for l in dictB:
        sumDictB +=dictB[l]

f = open('eu-good.txt', 'r')
#Create single word frequency list from Positive tweets:
sPos = Counter(f.read().split())
sumPsing = 0
for e in sPos:
        sumPsing += sPos[e]

f.close()
#Create bigram freq list from Positive tweets:
f = open('eu-good.txt', 'r')
bG = [b for l in f for b in zip(l.split(" ")[:-1],l.split(" ")[1:])]
f.close()
biPos = Counter(bG)

sumP = 0
sumN = 0
for e in biPos:
        sumP += biPos[e]


f = open('eu-bad.txt', 'r')
#Create single-word freq list:
sNeg = Counter(f.read().split())
sumNsing = 0
for e in sNeg:
        sumNsing += sNeg[e]
f.close()
f = open('eu-bad.txt', 'r')
bB = [b for l in f for b in zip(l.split(" ")[:-1],l.split(" ")[1:])]
f.close()
biNeg = Counter(bB)

for e in biNeg:
        sumN += biNeg[e]

path = "testTweets"
cnt = 1
print 'TweetID,Sentiment'
for f in os.listdir(path):
        
        pos = 0
        neg = 0
        pPb = 0 #score for bigrams
        pNb = 0
        pPs = 0 #score for single words
        pNs = 0 #score for single words
        nam = "./testTweets/"
        charG = 0
        charB = 0

        fileText = open(nam + f, 'r')
        
        for l in fileText:
                words = l.lower().split()
                for w in words:
                        list = [w[i:i+n] for i in range(len(w)-1)]
                        for m in list:
                                if m in dictG:
                                        charG += math.log(dictG[m]/float(sumDictG))
                                if m in dictB:
                                        charB += math.log(dictB[m]/float(sumDictB))


        fileText.close()
        fileText = open(nam+f, 'r')
        fBi = Counter([b for l in fileText for b in zip(l.split(" ")[:-1],l.split(" ")[1:])])
        
        for itm in fBi:
               
                if itm in biPos:
                        #print 'found in biPos. pP = '
                        #print pP
                        pos +=1
                        #print biPos[itm]
                        #print sumP
                        pPb += math.log(biPos[itm]/float(sumP))
                #elif itm in sPos:
                        #print 'found in sPos. pP = '
                        #print pP       
                #        pos+=1
                #        pP += math.log(sPos[itm]/sumPsing)
                        
                else:
                        #print 'not found'
                        #print pP
                        pPb += -0.001
                if itm in biNeg:
                        #print 'found in biNeg pN = '
                        #print pN
                        neg +=1
                        pNb += math.log(biNeg[itm]/float(sumN))
                     
                #elif itm in sNeg:
                        #print 'found in sNeg. pn = '
                        #print pN
                #        neg +=1
                #        pN += math.log(sNeg[itm]/sumNsing)
                else:
                        #print 'not found'
                        #print pN
                        pNb += -0.001

        fileText.close()
        fileText = open(nam + f, 'r')
        for ln in fileText:
                words = ln.split()
                for w in words:
                        if w in sPos:
                                pPs +=math.log(sPos[w]/float(sumPsing))
                        else:
                                pPs += -0.0001
                        if w in sNeg:
                                pNs += math.log(sNeg[w]/float(sumNsing))
                        else:
                                pNs += -0.0001
        #choose max of pPs and pPb:

        valP = max(pPs, pPb)
        valN = max(pNs, pNb)
        if charG > charB:
                print str(cnt) + ',P'
        else:
                print str(cnt) + ',N'                            
     
        
       # print (nam+f)
        
       # if (valP > valN):
       #         print str(cnt) + ',P'
       # 
       # elif (valP == valN):
       #        print str(cnt) + ',N'
       # else:
       #         print str(cnt) + ',N'
        cnt = cnt + 1
        
#print str(cnt) + ',P'
