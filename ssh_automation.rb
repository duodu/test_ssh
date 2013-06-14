require 'net/ssh'
require 'net/scp'
require 'net/sftp'
require 'win32ole'

HOST = '10.48.192.15'
USER = 'lxl'
PASS = 'handpay'
DESTINATION = '/home/lxl/testssh'
LOCAL = 'E:/lib/*'
DEPLOY_EXCEL = 'E:/lib/mall/deploy.xlsx'


excel = WIN32OLE::new('excel.Application')
workbook = excel.Workbooks.Open(DEPLOY_EXCEL)
worksheet = workbook.Worksheets(1)
worksheet.Select
puts worksheet.Range('A1').value
workbook.close
excel.Quit

Net::SCP.start(HOST, USER, :password => PASS) do |scp|
    # upload a file to a remote server
  Dir[LOCAL].each { |file|
    scp.upload! file, DESTINATION
    puts "upload successfull"
}
end