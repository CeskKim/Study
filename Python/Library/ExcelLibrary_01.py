import os
import xlsxwriter
from datetime import datetime

#파일 위치
excelfilename = 'Test.xlsx'
filepath = r'C:\Users\pkuuu\Desktop\코딩\python\Study\OSLibrary'
excelpath = os.path.join(filepath,excelfilename)

#엑셀 생성
workbook = xlsxwriter.Workbook(excelpath)
worksheet = workbook.add_worksheet()
worksheet.set_column('A:A', 20)
nowtime = datetime.now()

#엑셀 시간 변환
format1 = workbook.add_format({'num_format': 'h:mm:ss AM/PM'})
worksheet.write('A1', nowtime, format1)
workbook.close()
