require_relative 'vndb'
require_relative 'input'
require_relative 'search'
require_relative 'extractor'
require_relative 'mover'

VNDB.connect
VNDB.login

FOLDER_TO_SORT = './tosort'.freeze

def match_by_title(title)
  selected = []
  return 'empty' unless Search.title_query(title)

  Search.display_title_query_results
  Search.ask_user(selected) while selected.empty?
  selected
end

extracted = Extractor.extract(FOLDER_TO_SORT)
p extracted

map = {}
extracted.each do |folder|
  # match_by_all

  # p folder[:title]
  puts 'new title search'
  folder[:title].each do |subtitle|
    puts 'new subtitle search'
    match = match_by_title(subtitle)
    # p "MATCH: #{match}"
    if match == 'empty'
      puts 'No results, skipping'
      next
    end

    # unnecessary for now
    # if match[0] == 'skipped'
    #   puts 'skipping'
    #   next
    # end

    map[folder[:location]] = match[0]
  end
end
p map
Mover.move(map, './sorted')

VNDB.disconnect
