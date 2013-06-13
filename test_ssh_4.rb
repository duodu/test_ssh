require 'net/ssh'
require 'net/sftp'
require 'dir'

local_path = 'E:\lib'
remote_path = '/home/lxl/testssh'
file_perm = 0644
dir_perm = 0755
HOST = '10.48.192.15'
USER = 'lxl'
PASS = 'handpay'

 puts 'Connecting to remote server'
 Net::SSH.start(HOST, USER, :password => PASS) do |ssh|
   ssh.sftp.connect do |sftp|
     puts 'Checking for files which need updating'
     Find.find(local_path) do |file|
       next if File.stat(file).directory?
       local_file = "#{dir}/#{file}"
       remote_file = remote_path + local_file.sub(local_path, '')

       begin
         remote_dir = File.dirname(remote_file)
         sftp.stat(remote_dir)
       rescue Net::SFTP::Operations::StatusException => e 
         raise unless e.code == 2
         sftp.mkdir(remote_dir, :permissions => dir_perm)
       end

       begin
         rstat = sftp.stat(remote_file)
       rescue Net::SFTP::Operations::StatusException => e
         raise unless e.code == 2
         sftp.put_file(local_file, remote_file)
         sftp.setstat(remote_file, :permissions => file_perm)
         next
       end

       if File.stat(local_file).mtime > Time.at(rstat.mtime)
         puts "Copying #{local_file} to #{remote_file}"
         sftp.put_file(local_file, remote_file)
       end
     end
   end

   puts 'Disconnecting from remote server'
  end
 #end

 puts 'File transfer complete'