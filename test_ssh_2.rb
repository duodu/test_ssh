require 'net/ssh'
require 'net/sftp'


Net::SSH.start('10.48.192.13','app01', :password => 'handpay', :port => 23  ) do |ssh|
  output = ssh.exec! "ls -l"
  puts output
end
