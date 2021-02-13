require 'json'
require 'socket'
require 'fileutils'

require_relative 'vndb'
require_relative 'input'
require_relative 'search'
require_relative 'titlesearch'
require_relative 'allsearch'
require_relative 'extractor'
require_relative 'mover'

$CONFIG = JSON.parse(File.read('config.json'))
FOLDER_TO_SORT = $CONFIG['source'].freeze
LIBRARY_FOLDER = $CONFIG['destination'].freeze

def main
  ### EXTRACT ###
  p extracted = Extractor.extract(FOLDER_TO_SORT)

  ### SEARCH ###
  VNDB.connect
  VNDB.login
  map = {}
  extracted.each do |folder|
    # p folder[:title]
    match = []

    unless folder[:producer].empty? || folder[:date].empty?
      puts 'new all search'
      match = Search.match_by_all(folder[:producer], folder[:date], folder[:location])

      unless match == 'empty'
        # p "MATCH: #{match}"
        map[folder[:location]] = match
        next
      end
      puts 'No results from AllSearch, proceeding to TitleSearch'
    end

    # this part needs a refactor
    puts 'new title search'
    # p folder[:title]
    folder[:title].each do |subtitle|
      puts 'new subtitle search'
      match = Search.match_by_title(subtitle, folder[:location])
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

  ### MOVE ###
  # puts map
  planned_moves = []
  move_history = []
  failed_history = []

  map.each do |combination|
    begin
      result = Mover.plan_move(combination, LIBRARY_FOLDER)
      planned_moves << result unless result == 'skipped'
    rescue StandardError => e
      puts e
      puts "Move failed for #{combination[0]}"
      puts ''
      failed_history << combination[0]
      next
    end
  end

  puts ''
  puts 'Planned moves:'
  planned_moves.each do |planned_move|
    puts planned_move
    puts ''
  end

  puts 'Press Enter to proceed or close the window to abort'
  Input.get_input

  planned_moves.each do |planned_move|
    begin
      move_history << Mover.move(planned_move)
      puts "Move succeeded for #{planned_move}"
      puts ''
    rescue StandardError => e
      puts e
      puts "Move failed for #{planned_move}"
      puts ''
      failed_history << planned_move
      next
    end
  end

  puts 'Move history: '
  move_history.each do |move|
    puts move
    puts ''
  end
  puts 'Failed history: '
  failed_history.each do |move|
    puts move
    puts ''
  end

  puts ''
  puts 'Sorted everything!'
end

main
