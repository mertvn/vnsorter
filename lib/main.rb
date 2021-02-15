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
      match = Search.match_by_all(folder[:producer], folder[:date], folder[:location], folder[:title][0])
      # p "MATCH: #{match}"
      case match
      when 'empty'
        puts 'No results from AllSearch, proceeding to TitleSearch'
      when 'autoskip'
        puts 'Found multiple results, autoskipping'
        next
      when 'next'
        next
      when 'skip'
        next
      when 'stop'
        break
      else
        map[folder[:location]] = match
        next
      end
    end

    # this part needs a refactor
    # HACK: to break two loops ¯\_(ツ)_/¯
    stop = false
    puts 'new title search'
    # p folder[:title]
    folder[:title].each_with_index do |subtitle, index|
      break if index > 0 && $CONFIG['full_title_only']

      puts 'new subtitle search'
      match = Search.match_by_title(subtitle, folder[:location])
      # p "MATCH: #{match}"
      case match
      when 'empty'
        puts 'No results, moving on'
        next
      when 'autoskip'
        puts 'Found multiple results, autoskipping'
        break
      when 'next'
        next
      when 'skip'
        break
      when 'stop'
        stop = true
        break
      else
        map[folder[:location]] = match
        puts 'found match, breaking'
        break
      end
    end
    break if stop
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
      planned_moves << result unless result == 'skip'
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
  input = Input.get_input until input == ''

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
  write_move_logs(move_history, failed_history)

  puts ''
  puts 'Sorted everything!'
end

def write_move_logs(move_history, failed_history)
  file = File.new 'move_history.txt', 'w'
  file.puts 'MOVED: '
  move_history.each do |move|
    file.puts move
  end
  file.puts ''
  file.puts 'FAILED: '
  failed_history.each do |move|
    file.puts move
  end
  puts ''
  puts 'See move_history.txt for a list of all the moves'
end

main
