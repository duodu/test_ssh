require 'net/ssh'
require 'net/scp'
require 'net/sftp'

HOST = '10.48.192.15'
USER = 'lxl'
PASS = 'handpay'

Net::SSH.start( HOST, USER, :password => PASS ) do |ssh|
   #ssh.upload! ("E:/lib/1.txt","/home/lxl/testssh")
   result = ssh.exec!('ls')
   puts result
end

Net::SCP.start(HOST, USER, :password => PASS) do |scp|
    # upload a file to a remote server
  scp.upload! "E:/lib/1.txt", "/home/lxl/testssh/"
end
