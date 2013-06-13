require 'net/ssh'
require 'net/sftp'


Net::SSH.start('10.48.192.15','lxl',:password => 'handpay') do |ssh|
  ssh.sftp.connect do |sftp|
    Dir.foreach('.') do |file|
      puts file
    end
  end
end
