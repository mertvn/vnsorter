require 'json'
require 'socket'

# j = JSON.parse()
# puts j
# hostname = 'localhost'
# port = 3000
hostname = 'api.vndb.org'
port = 19_534
# login_req = "login #{j}0x04"
# puts login_req
release_req = "get vn basic (id = 17)\04"

def read
  @message = ''
  @message << @s.getc until @message[-1] == "\x04"
  @message[-1] = ''
  @message
end

@s = TCPSocket.open(hostname, port)
@s.write 'login '
@s.write '{ "protocol": 1, "client": "test", "clientver": 0.1 }'
@s.write "\04"
puts read
# @s.write release_req
# puts read
@s.close
