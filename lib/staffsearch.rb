# unrelated to vn sorting, just needed a way to use the old API
require_relative 'vndb'
require 'json'
require 'socket'
require 'fileutils'

REQ_RELEASE_TITLE = 'get staff basic,aliases '.freeze

def title_query(title)
  @releases = []

  title_filter = "(search~\"#{title}\")"
  title_options = '{ "results": 25 }'
  title_final = (REQ_RELEASE_TITLE + title_filter + title_options).encode('UTF-8')

  VNDB.send(title_final)
  parsed = VNDB.parse(VNDB.read)
  puts JSON.pretty_generate(parsed)

  parsed['items'].each do |release|
    @releases << release
  end

  @releases
end

artists = JSON.parse(File.read('noAids_noins.json'))

VNDB.connect
VNDB.login

res = {}
tried = []
artists.each do |artist|
  artist = artist['EgsData']
  # puts JSON.pretty_generate(artist)
  creater_id = artist['CreaterId']
  next if tried.include?(creater_id)

  artist['CreaterNames'].push(artist['CreaterFurigana']).each do |creater_name|
    res[creater_id] = [] unless res[creater_id]

    query = title_query(creater_name)
    res[creater_id] << { creater_name => query }
  end
  tried << (creater_id)

  File.open('staffsearch_out.json', 'w') { |f| f.write JSON.pretty_generate(res) }
end

VNDB.disconnect
