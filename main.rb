require_relative 'vndb'
require_relative 'input'
require_relative 'search'
require_relative 'extractor'

VNDB.connect
VNDB.login

def match_by_title(title)
  selected = []
  return 'empty' unless Search.title_query(title)

  Search.display_title_query_results
  Search.ask_user(selected) while selected.empty?
  selected
end

extracted = Extractor.extract
p extracted

map = {}
extracted.each_with_index do |folder, index|
  # match_by_all

  next unless index > 9

  # p folder[:title]
  puts 'new title search'
  folder[:title].each do |subtitle|
    puts 'new subtitle search'
    match = match_by_title(subtitle)
    # p match
    if match == 'empty'
      puts 'No results, skipping'
      next
    end

    # unnecessary for now
    # if match[0] == 'skipped'
    #   puts 'skipping'
    #   next
    # end

    map[folder[:location]] = match
  end
end
p map
VNDB.disconnect
