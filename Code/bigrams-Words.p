import re
import os, decimal
import math
from collections import Counter

chars = ['@','\\','/','#','?','!','.','\\x']
alpha = 0.1

f = open('./reg/good/gAll', 'r')
#Create single word frequency list from Positive tweets:

sPos = Counter(f.read().translate(None,''.join(chars)).lower().split())
sumPsing = 0
for e in sPos:
        sumPsing += sPos[e]

f.close()
#Create bigram freq list from Positive tweets:
f = open('./reg/good/gAll', 'r')
bG = [b for l in f for b in zip(l.translate(None,''.join(chars)).lower().split(" ")[:-1],l.translate(None,''.join(chars)).lower().split(" ")[1:])]
f.close()
biPos = Counter(bG)

sumP = 0
sumN = 0
for e in biPos:
        sumP += biPos[e]


f = open('./reg/bad/bAll', 'r')
#Create single-word freq list:
sNeg = Counter(f.read().lower().translate(None,''.join(chars)).split())
sumNsing = 0
for e in sNeg:
        sumNsing += sNeg[e]
f.close()
f = open('./reg/bad/bAll', 'r')
bB = [b for l in f for b in zip(l.lower().translate(None,''.join(chars)).split(" ")[:-1],l.lower().translate(None,''.join(chars)).split(" ")[1:])]
f.close()
biNeg = Counter(bB)

for e in biNeg:
        sumN += biNeg[e]

path = "./dev/"
cnt = 1
print 'TweetID,Sentiment'
for f in os.listdir(path):
        
        pos = 0
        neg = 0
        pPb = 0 #score for bigrams
        pNb = 0
        pPs = 0 #score for single words
        pNs = 0 #score for single words
        nam = "./dev/"
        fileText = open(nam + f, 'r')
        fBi = Counter([b for l in fileText for b in zip(l.lower().translate(None,''.join(chars)).split(" ")[:-1],l.lower().translate(None,''.join(chars)).split(" ")[1:])])
        
        for itm in fBi:
               
                if itm in biPos:
                        pos +=1
                        pPb += math.log(biPos[itm]/float(sumP))
                
                        
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
                words = ln.lower().translate(None,''.join(chars)).split()
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
                                        
     
       # if (pPs > pNs) and 'g' in fileText.name:
       #         print str(cnt) + 'correct'
       # 
       # elif (pPs > pNs) and 'b' in fileText.name:
       #         print str(cnt) + 'incorrect'
       # elif (pNs >= pPs) and 'g' in fileText.name:
       #         print str(cnt) + 'incorrect'
       # else:   
       #         print str(cnt) + 'correct' 
        if (valP > valN) and 'g' in fileText.name:
                print str(cnt) + 'correct'
        elif (valP > valN) and 'b' in fileText.name:
                print str(cnt) + 'incorrect'
        elif (valP <= valN) and 'b' in fileText.name:
                print str(cnt) + 'correct'
        elif (valP <= valN) and 'g' in fileText.name:
                print str(cnt) + 'incorrect'
        else:
                print 'error'
       # if (valP > valN):
       #         print 'P'
       # else:
       #         print 'N'
        cnt = cnt + 1
        
        
