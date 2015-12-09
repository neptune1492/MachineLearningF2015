import os
cnt = 1
basepath = './'
for f in os.listdir(basepath):
        path = os.path.join(basepath,f)
        if os.path.isdir(path):
                print 'skipping directory...'
        else:
                oldFile = open(f,'r')
                if cnt <=1000:
                
                        newFile = open('./section1/' + oldFile.name, 'w')
                elif cnt >1000 and cnt <= 2000:
                        newFile = open('./section2/' + oldFile.name, 'w')
                else:
                        newFile = open('./section3/'+ oldFile.name,'w')
                newFile.write(oldFile.read())
                newFile.close()
                oldFile.close()
                cnt+=1
