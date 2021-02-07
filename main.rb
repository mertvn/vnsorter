require_relative 'vndb'
require_relative 'input'
require_relative 'titlesearch'
require_relative 'producersearch'
require_relative 'extractor'
require_relative 'mover'

FOLDER_TO_SORT = './tosort'.freeze
LIBRARY_FOLDER = './sorted'.freeze

def match_by_title(title)
  selected = []
  return 'empty' if TitleSearch.title_query(title).empty?

  TitleSearch.display_title_query_results
  TitleSearch.ask_user(selected) while selected.empty?
  selected
end

def match_by_all(producer, date)
  # selected = []
  releases = ProducerSearch.producer_query(producer, date)
  return 'empty' if releases.empty?

  # if releases.length > 1
  #   ProducerSearch.display_all_query_results
  #   ProducerSearch.ask_user(selected) while selected.empty?
  # end

  releases
  # selected
end

def main
  VNDB.connect
  VNDB.login

  extracted = Extractor.extract(FOLDER_TO_SORT)
  p extracted

  map = {}
  extracted.each do |folder|
    # p folder[:title]
    match = []

    unless folder[:producer].empty? || folder[:date].empty?
      puts 'new all search'
      match = match_by_all(folder[:producer], folder[:date])

      unless match == 'empty'
        map[folder[:location]] = match[0]
        next
      end
    end

    p 'title search is disabled'

    # this part needs a refactor
    puts 'new title search'
    folder[:title].each do |subtitle|
      puts 'new subtitle search'
      match = match_by_title(subtitle)
      # p "MATCH: #{match}"
      if match == 'empty'
        puts 'No results, skipping'
        next
      end
      next if match[0] == 'skipped'

      map[folder[:location]] = match[0]
      p 'found match, breaking'
      break
    end
  end
  VNDB.disconnect

  puts "Map: #{map}"
  @move_history = Mover.move(map, LIBRARY_FOLDER)
  puts "Move history: #{@move_history}"
  puts 'Sorted everything!'
end

main
