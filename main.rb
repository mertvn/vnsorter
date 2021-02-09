require_relative 'vndb'
require_relative 'input'
require_relative 'search'
require_relative 'titlesearch'
require_relative 'allsearch'
require_relative 'extractor'
require_relative 'mover'

FOLDER_TO_SORT = './tosort'.freeze
LIBRARY_FOLDER = './sorted'.freeze

def main
  p extracted = Extractor.extract(FOLDER_TO_SORT)

  VNDB.connect
  VNDB.login
  map = {}
  extracted.each do |folder|
    # p folder[:title]
    match = []

    unless folder[:producer].empty? || folder[:date].empty?
      puts 'new all search'
      match = Search.match_by_all(folder[:producer], folder[:date])

      unless match == 'empty'
        # p "MATCH: #{match}"
        map[folder[:location]] = match
        next
      end
      puts 'No results from AllSearch, proceeding to TitleSearch instead'
    end

    # this part needs a refactor
    puts 'new title search'
    folder[:title].each do |subtitle|
      puts 'new subtitle search'
      match = Search.match_by_title(subtitle)
      # p "MATCH: #{match}"
      if match == 'empty'
        puts 'No results, skipping'
        next
      end
      next if match == 'skipped'

      map[folder[:location]] = match
      puts 'found match, breaking'
      break
    end
  end
  VNDB.disconnect

  puts "Map: #{map}"
  move_history, failed_history = Mover.move(map, LIBRARY_FOLDER)
  puts "Move history: #{move_history}"
  puts "Failed history: #{failed_history}"
  puts 'Sorted everything!'
end

main
