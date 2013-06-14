require 'win32ole'

$deploy_excel = 'E:/lib/deploy.xlsx'
$excel = WIN32OLE::new('excel.Application')
$workbook = $excel.Workbooks.Open($deploy_excel)
$worksheet = $workbook.Worksheets(1)
$worksheet.Select

$common_array = []
$mall_array=[]
$payment_array=[]
$instance01 = {:common => nil, :mall => nil, :payment => nil, :ip => '10.48.192.15' , :username => 'lxl' , :pass => 'handpay', :column => 2}
$instance02 = {:common => nil, :mall => nil, :payment => nil, :ip => '10.48.192.14' , :username => 'lxl' , :pass => 'handpay', :column => 15}
$instance=[$instance01,$instance02]

$instance.each do |instance|

    line = instance[:column]
      while $worksheet.Range("A#{line}").value != nil
        if  $worksheet.Range("A#{line}").value =~ /ar\z/
          $common_array << $worksheet.Range("A#{line}").value
        end
        line += 1
      end
      instance[:common] = $common_array
  


  
    line = instance[:column]
      while $worksheet.Range("B#{line}").value != nil
        if  $worksheet.Range("B#{line}").value =~ /ar\z/
          $mall_array << $worksheet.Range("B#{line}").value
        end
        line += 1
      end
      instance[:mall] = $mall_array
  

  
    line = instance[:column]
      while $worksheet.Range("C#{line}").value != nil
        if  $worksheet.Range("C#{line}").value =~ /ar\z/
          $payment_array << $worksheet.Range("C#{line}").value
        end
        line += 1
      end
      instance[:payment] = $payment_array

end

$workbook.close
$excel.Quit
puts "instance01"
puts "common"
puts $instance01[:common]
puts "mall"
puts $instance01[:mall]
puts "payment"
puts $instance01[:payment]

puts "instance02"
puts "common"
puts $instance02[:common]
puts "mall"
puts $instance02[:mall]
puts "payment"
puts $instance02[:payment]