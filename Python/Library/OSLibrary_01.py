import os
import re
import shutil
import glob

# 파일 위치
# SyntaxError : unicode -> 파일위치명 앞에 r구문 삽입
filepath = r'C:\Users\pkuuu\Desktop\코딩\python\Study\OSLibrary'
filelist = os.listdir(filepath)

# 파일명 변경
def fileproc(filelist):
    i = 1
    for name in filelist:
        src = os.path.join(filepath, name)
        chgfilename = 'Go' + str(i) + '.txt'
        chgsrc = os.path.join(filepath, chgfilename)

        os.rename(src, chgsrc)
        i += 1


def filemove(filelist):
    for name in filelist:
        datefile = re.search(r'\d{4}-\d{2}-\d{2}', name)
        if datefile is not None:
            datefolder = datefile.group()
            datepath = os.path.join(filepath, datefolder)

            #해당 경로에 존재 하지 않은 경우에만 폴더 생성
            if not os.path.isdir(datepath):
                try:
                    print('success')
                    os.makedirs(datepath) #makedirs(경로 지정)
                except:
                    print('Error')

            if name.endswith('.txt') is True:

                movefile = os.path.join(filepath,name)
                shutil.move(movefile, datepath)

fileproc(filelist)
filemove(filelist)
