class VNDB
  require 'json'
  require 'socket'

  HOSTNAME = 'api.vndb.org'.freeze
  PORT = 19_534
  END_CHAR = "\04".freeze
  REQ_LOGIN = 'login { "protocol": 1, "client": "test", "clientver": 0.1 }'.freeze

  def connect
    @socket = TCPSocket.open(HOSTNAME, PORT)
  end

  def disconnect
    @socket.close
  end

  def login
    send REQ_LOGIN
    msg_login = read
    puts msg_login
    abort unless msg_login == 'ok'
  end

  def read
    message = ''
    message << @socket.getc until message[-1] == "\x04"
    message[-1] = ''
    message
  end

  def send(message)
    puts "-> #{message}"
    @socket.write message
    @socket.write END_CHAR
  end

  def parse(message)
    message.sub!(/\w+ /, '')
    JSON.parse(message)
  end
end
