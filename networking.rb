require 'json'
require 'socket'

# j = JSON.parse('{"more":false,"items":[{"title":"Ever17 -The Out of Infinity-","platforms":["win","ios","and","nds","psp","ps2","drc"],"orig_lang":["ja"],"id":17,"released":"2002-08-29","original":null,"languages":["en","es","ja","ru","zh"]}],"num":1}')
# p j

hostname = 'api.vndb.org'
port = 19_534
END_CHAR = "\04".freeze
@socket = TCPSocket.open(hostname, port)
# @last = ''

login_req = 'login { "protocol": 1, "client": "test", "clientver": 0.1 }'
release_req = 'get release basic (original~"ハロー・レディ！")'
puts release_req

def read
  message = ''
  message << @socket.getc until message[-1] == "\x04"
  message[-1] = ''
  # @last = message
  message
end

def send(message)
  @socket.write message
  @socket.write END_CHAR
end

def parse(message)
  message.sub!(/\w+ /, '')
  JSON.pretty_generate(JSON.parse(message))
end
send login_req
puts read
send release_req
puts parse read
# puts read

@socket.close
