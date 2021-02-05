module VNDB
  extend self
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
    unless msg_login == 'ok'
      disconnect
      abort('Failed to login')
    end
  end

  def read
    message = ''
    message << @socket.getc until message[-1] == END_CHAR
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
