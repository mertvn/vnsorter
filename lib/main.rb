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

def main
  ### CONFIGURE ###
  $CONFIG = JSON.parse(File.read('config.json'))
  @time = Time.now.strftime('%Y-%m-%d_%H-%M-%S')
  @folder_to_sort = $CONFIG['source'].freeze
  library_folder = $CONFIG['destination'].freeze
  abort('Invalid location') if @folder_to_sort.nil? || library_folder.nil?

  ### EXTRACT ###
  begin
    # p extracted = Extractor.extract(folder_to_sort)
    extracted = Extractor.extract(@folder_to_sort)
  rescue StandardError => e
    puts e
    abort('Could not extract -- did you select a valid location?')
  end
  return 'Nothing to sort!' if extracted.empty?

  ### SEARCH ###
  VNDB.connect
  VNDB.login
  map = start_search(extracted)
  VNDB.disconnect

  Dir.mkdir('./logs') unless Dir.exist?('./logs')
  File.open("./logs/map #{@time}.json", 'w') { |f| f.write JSON.pretty_generate(map) }

  ### MOVE ###
  # puts map
  @move_history = []
  @failed_history = []

  planned_moves = plan_moves(map, library_folder)
  return 'Nothing to sort!' if planned_moves.empty?

  puts 'Displaying planned moves'
  display_planned_moves(planned_moves)
  planned_moves = $FINAL unless ARGV[0] == '-nogui'

  execute_moves(planned_moves)
  write_move_logs

  puts ''
  'Sorted everything!'
end

def start_search(extracted)
  map = {}

  extracted.each do |folder|
    # p folder

    if folder[:vnsorter_file] && $CONFIG['vnsorter_file']
      match = folder[:vnsorter_file]
      map[folder[:location]] = match
      puts "Matched #{folder[:location]} locally using !vnsorter.json file"
      next
    end

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
        create_vnsorter_file(folder[:location], match) if $CONFIG['vnsorter_file']
        # && File.directory?(folder[:location])
        next
      end
    end

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
        create_vnsorter_file(folder[:location], match) if $CONFIG['vnsorter_file']
        # && File.directory?(folder[:location])
        # puts 'found match, breaking'
        break
      end
    end
    break if stop
  end
  map
end

def create_vnsorter_file(location, match)
  location = File.directory?(location) ? location : File.expand_path('..', location)
  return if File.realdirpath(location) == File.realdirpath(@folder_to_sort)

  File.open("#{location}/!vnsorter.json", 'w') { |f| f.write JSON.pretty_generate(match) }
end

def plan_moves(map, library_folder)
  planned_moves = []
  map.each do |combination|
    begin
      result = Mover.plan_move(combination, library_folder)
      planned_moves << result unless result == 'skip'
    rescue StandardError => e
      puts e
      puts "Move failed for #{combination[0]}"
      puts ''
      @failed_history << combination[0]
      next
    end
  end
  planned_moves
end

def display_planned_moves(planned_moves)
  if ARGV[0] == '-nogui'
    puts ''
    puts 'Planned moves:'
    planned_moves.each do |planned_move|
      puts planned_move
      puts ''
    end

    puts 'Press Enter to execute displayed moves or close the window to abort'
    input = Input.get_input until input == ''
  else
    GUISelection.gui_selection(planned_moves)
    planned_moves
  end
end

def execute_moves(planned_moves)
  planned_moves.each do |planned_move|
    begin
      @move_history << Mover.move(planned_move)
      puts "Move succeeded for #{planned_move}"
      puts ''
    rescue StandardError => e
      puts e
      puts "Move failed for #{planned_move}"
      puts ''
      @failed_history << planned_move
      next
    end
  end
end

def write_move_logs
  file = File.new "./logs/move_history #{@time}.txt", 'w'
  file.puts 'MOVED: '
  @move_history.each do |move|
    file.puts move
  end
  file.puts ''
  file.puts 'FAILED: '
  @failed_history.each do |move|
    file.puts move
  end
  puts ''
  puts "See logs/move_history #{@time}.txt for a list of all the moves"
end

if ARGV[0] == '-nogui'
  puts main
else
  require 'gtk3'
  require_relative 'gui_config'
  require_relative 'gui_selection'
  GUIConfig.gui_config
  puts main

  # GUI.gui_history
end
