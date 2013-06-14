require 'win32ole'

$deploy_excel = 'E:/lib/deploy.xlsx'
$excel = WIN32OLE::new('excel.Application')
$workbook = $excel.Workbooks.Open($deploy_excel)
$worksheet = $workbook.Worksheets(1)
$worksheet.Select

col = Array.new
i = 0
line = 1
while i < 6 
  if $worksheet.Range("A#{line}").value == 'commom'
    col[i] = line
    i += 1
  end
  line += 1
end

$instance_cp_01 = {:common => nil, :mall => nil, :payment => nil, :ip => '10.48.192.16', :port => 10051,:username => 'app01' , :password => 'handpay', :column => col[0], :destination => '/opt/app01/server/default/deploy/'}
$instance_cp_02 = {:common => nil, :mall => nil, :payment => nil, :ip => '10.48.192.16', :port => 10051,:username => 'app02' , :password => 'handpay', :column => col[1], :destination => '/opt/app02/server/default/deploy/'}
$instance_cp_03 = {:common => nil, :mall => nil, :payment => nil, :ip => '10.48.192.16', :port => 10051,:username => 'app03' , :password => 'handpay', :column => col[2], :destination => '/opt/app03/server/default/deploy/'}
$instance_cc_01 = {:common => nil, :mall => nil, :payment => nil, :ip => '10.48.192.13', :port => 22,:username => 'app01' , :password => 'handpay', :column => col[3], :destination => '/opt/app01/server/default/deploy/'}
$instance_cc_02 = {:common => nil, :mall => nil, :payment => nil, :ip => '10.48.192.13', :port => 22,:username => 'app02' , :password => 'handpay', :column => col[4], :destination => '/opt/app02/server/default/deploy/'}
$instance_cc_03 = {:common => nil, :mall => nil, :payment => nil, :ip => '10.48.192.13', :port => 22, :username => 'app03' , :password => 'handpay', :column => col[5], :destination => '/opt/app03/server/default/deploy/'}
$instance=[$instance_cp_01,$instance_cp_02,$instance_cp_03,$instance_cc_01,$instance_cc_02,$instance_cc_03]

def file_to_instance
  $instance.each do |instance|
    common_array = Array.new
    mall_array=Array.new
    payment_array=Array.new
#common
    line = instance[:column]
      while $worksheet.Range("A#{line}").value != nil
        if  $worksheet.Range("A#{line}").value =~ /ar\z/
          common_array << $worksheet.Range("A#{line}").value
        end
        line += 1
      end
      instance[:common] = common_array
#mall
    line = instance[:column]
      while $worksheet.Range("B#{line}").value != nil
        if  $worksheet.Range("B#{line}").value =~ /ar\z/
          mall_array << $worksheet.Range("B#{line}").value
        end
        line += 1
      end
      instance[:mall] = mall_array
#payment
    line = instance[:column]
      while $worksheet.Range("C#{line}").value != nil
        if  $worksheet.Range("C#{line}").value =~ /ar\z/
          payment_array << $worksheet.Range("C#{line}").value
        end
        line += 1
      end
      instance[:payment] = payment_array
  end
end

file_to_instance

$workbook.close
$excel.Quit
