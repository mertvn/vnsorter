module VNDB
  extend self
  # require 'json'
  # require 'socket'

  HOSTNAME = 'api.vndb.org'.freeze
  PORT = 19_534
  END_CHAR = "\04".freeze
  REQ_LOGIN = 'login { "protocol": 1, "client": "vnsorter", "clientver": 0.1 }'.freeze

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

    if message[0..4] == 'error'
      parsed = parse(message)
      minwait = parsed['minwait']

      # got an error other than throttle
      unless minwait
        puts parsed
        return 'results {"num": 0,"more": false,"items": []}'
      end

      puts "throttled...waiting #{minwait} seconds"
      sleep(minwait)
      send(@last)
      read
    else
      message
    end
  end

  def send(message)
    @last = message
    puts "-> #{message}"
    @socket.write message
    @socket.write END_CHAR
  end

  def parse(message)
    message.sub!(/\w+ /, '')
    JSON.parse(message)
  end
end
