require 'net/ssh'
require 'net/sftp'

LOCAL_PATH = 'E:\lib'  
REMOTE_PATH = '/home/lxl/testssh'  
  
SERVER="10.48.192.15"  
USER_NAME = "lxl"  
PASSWORD = "handpay"  
  
module FindUtils  
  def find_all_file(file,&block)  
    if File.stat(file).directory?  
      Dir.foreach(file) do |f|  
        find_all_file(file + "/" + f,&block) if( !(f =~ /^\./))  
      end  
    else  
      block.call(file)  
    end  
  end  
    
  def find_all_dir(dir,&block)  
    if File.stat(dir).directory?  
      block.call(dir)  
      Dir.foreach(dir) do |f|  
        find_all_dir(dir + "/" + f,&block) if(File.stat(dir + "/" + f).directory? && !(f =~ /^\./))  
      end  
    end  
  end  
end  
  
task :default => [:upload]  
  
#文件上传  
task :upload do  
  puts "task[upload] start"  
  include FindUtils  
  begin  
    Net::SSH.start(SERVER,USER_NAME,:password => PASSWORD) do |ssh|  
      ssh.sftp.connect do |sftp|  
        #        检查并创建文件夹  
        find_all_dir(LOCAL_PATH) do |d|  
          if !d.eql?(LOCAL_PATH)  
            begin  
              local_dir = d.sub(Regexp.new(LOCAL_PATH+"/"),'')  
              remote_dir = REMOTE_PATH + "/" + local_dir  
              puts "local_dir:#{local_dir} remote_dir:#{remote_dir}"  
              sftp.stat!(remote_dir)  
            rescue Net::SFTP::StatusException => se  
              raise unless se.code == 2  
              puts "mkdir on remote : #{remote_dir}"  
              sftp.mkdir!(remote_dir, :permissions => 0755)  
              puts "mkdir completion"  
            end  
          end  
        end  
          
        #        上传文件  
        find_all_file(LOCAL_PATH) do |f|  
          local_file = f.sub(Regexp.new(LOCAL_PATH+"/"),'')  
          remote_file = REMOTE_PATH + "/" + local_file  
          sftp.upload!(f,remote_file) do|event,uploader,*args|  
            case event  
              # args[0] : file metadata  
            when :open  
              puts "start uploading.#{args[0].local} -> #{args[0].remote}#{args[0].size} bytes}"  
            when :put then  
              # args[0] : file metadata  
              # args[1] : byte offset in remote file  
              # args[2] : data being written (as string)  
              puts "writing #{args[2].length} bytes to #{args[0].remote} starting at #{args[1]}"  
            when :close then  
              # args[0] : file metadata  
              puts "finished with #{args[0].remote}"  
            when :mkdir then  
              # args[0] : remote path name  
              puts "creating directory #{args[0]}"  
            when :finish then  
              puts "all done!"  
            end  
          end  
          puts "upload success"  
        end  
      end  
    end  
  rescue => detail  
    puts "error:#{detail.backtrace.join("\n")} \n message:#{detail.message}"  
  end  
end  

