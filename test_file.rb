require 'win32ole'

$deploy_excel = 'E:/lib/deploy.xlsx'
$excel = WIN32OLE::new('excel.Application')
$workbook = $excel.Workbooks.Open($deploy_excel)
$worksheet = $workbook.Worksheets(1)
$worksheet.Select

i = 0
line = 1
while i<6

if $worksheet.Range("A#{line}").value == 'commom'
  puts line
  i+=1
end 
line +=1

end 