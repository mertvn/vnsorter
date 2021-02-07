require_relative 'vndb'
require_relative 'input'
require_relative 'search'
require_relative 'extractor'
require_relative 'mover'

FOLDER_TO_SORT = './tosort'.freeze

def match_by_title(title)
  selected = []
  return 'empty' unless Search.title_query(title)

  Search.display_title_query_results
  Search.ask_user(selected) while selected.empty?
  selected
end

def match_by_all(company, date)
  selected = []
  return 'empty' unless Search.company_query(company, date)

  if @releases.length > 1
    Search.display_all_query_results
    Search.ask_user(selected) while selected.empty?
  end
  selected
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

    # unless folder[:company].empty? || folder[:date].empty?
    #   puts 'new all search'
    #   match = match_by_all(folder[:company], folder[:date])

    #   unless match == 'empty'
    #     map[folder[:location]] = match[0]
    #     next
    #   end
    # end

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
  p map
  Mover.move(map, './sorted')
  puts 'Sorted everything!'

  VNDB.disconnect
end

main
