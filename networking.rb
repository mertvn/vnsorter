require 'json'
require 'socket'

HOSTNAME = 'api.vndb.org'.freeze
PORT = 19_534
END_CHAR = "\04".freeze
@socket = TCPSocket.open(HOSTNAME, PORT)

REQ_LOGIN = 'login { "protocol": 1, "client": "test", "clientver": 0.1 }'.freeze
REQ_RELEASE = 'get release basic,producers '.freeze # no space between flags

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

def login
  send REQ_LOGIN
  msg_login = read
  puts msg_login
  abort unless msg_login == 'ok'
end

def get_input
  gets.chomp.downcase
end

def valid_input?(input)
  /\w/.match(input)
end

def title_search(title)
  @releases = []
  @selected = []
  title_filter = "(title~\"#{title}\" or original~\"#{title}\")"
  title_options = '{ "results": 25 }'
  title_final = REQ_RELEASE + title_filter + title_options

  send title_final
  puts JSON.pretty_generate(@last = (parse read))

  @last['items'].each_with_index do |release, index|
    @releases << { id: (release['id']), date: (release['released']), title: release['title'],
                   original: release['original'], languages: release['languages'] }
    companyromaji = []
    companyoriginal = []
    release['producers'].each_with_index do |producer, _index|
      companyromaji << producer['name']
      companyoriginal << producer['original']
    end
    @releases[index][:companyromaji] = companyromaji
    @releases[index][:companyoriginal] = companyoriginal
    # puts "ID: #{release['id']}"
    # puts "Date: #{release['released']}"
    # puts "Company: "
    # puts "Title: #{release['title']}"
    # puts "Original:  #{release['original']}"
    # puts "Languages:  #{release['languages']}"
    # puts ''
    # puts
  end
  # p @releases
  ask_user
end

def ask_user
  puts 'Enter the ID of the correct release or "skip"'
  input = get_input until valid_input?(input)
  return if input == 'skip'

  @releases.each do |release|
    @selected << release if input == release[:id].to_s
  end
  # if releases.find(|release.id| release.id == input)
end

login
title_search('ハロー・レディ！')
p @selected

@socket.close
