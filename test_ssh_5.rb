require 'net/ssh'
require 'net/sftp'
HOST = '10.48.192.15'
USER = 'lxl'
PASS = 'handpay'

Net::SSH.start(HOST,USER, :password => PASS) do |ssh|
  ssh.sftp.connect do |sftp|
    Dir.foreach('.') do |file|
      next if File.stat(file).directory?
      begin
        local_file_changed = File.stat(file).mtime > Time.at(sftp.stat(file).mtime) 
      rescue Net::SFTP::StatusException 
        not_uploaded = true 
      end 
      if not_uploaded or local_file_changed 
        puts "#{file} has changed and will be uploaded" 
        sftp.put_file(file, file) 
      end 
    end 
  end 
end