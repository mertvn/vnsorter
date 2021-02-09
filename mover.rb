require 'fileutils'

module Mover
  extend self

  def move(map, library_folder)
    @move_history = []
    @failed_history = []
    map.each do |combination|
      origin = combination[0].encode('UTF-8')
      # p origin
      vn = combination[1]
      next if vn == 'skipped'

      # naming_option = get from gui somehow
      naming_option = '1'
      destination = mark_destination(vn, library_folder, naming_option).encode('UTF-8')

      # mkdir_p and cp_r don't like "?"
      # p destination = destination.gsub(/[<>:"\\|?!*]/, '')

      begin
        create_folder(destination)
        move_files(origin, destination)
        puts "Move succeeded for #{vn[:title]}"
      rescue StandardError => e
        puts e
        puts "Move failed for #{vn[:title]}"
        @failed_history << { origin.to_s => destination }
        next
      end
    end
    [@move_history, @failed_history]
  end

  private

  def mark_destination(vn, library_folder, naming_option)
    #  p vn

    # apparently some vns don't have an original title
    title = vn[:original] || vn[:title]
    title = replace_special_characters(title)
    # p title

    # get these from gui
    producer_selection = 0
    producer_name_selection = 0
    producer = vn[:producer][producer_selection]
    # fallback to romaji name if original name doesn't exist
    producer = producer[producer_name_selection] || producer[0]
    # p producer
    producer = replace_special_characters(producer)

    # convert date to YYMMDD for now
    # allow more options later
    date = (vn[:date].split('-').join)[2..-1]
    date = date.length == 6 ? date : 'unknown'

    # keep the repetition
    case naming_option
    when '1'
      "#{library_folder}/#{producer}/[#{date}] #{title}"
    when '2'
      "#{library_folder}/#{producer}/#{title}"
    when '3'
      "#{library_folder}/#{title}"
      # when "custom"
    end
  end

  # backslash needs to be escaped AND at the end of the string
  # this needs to be a setting
  def replace_special_characters(string)
    string.tr(':/<>|*"!?\\', '：／＜＞｜＊”！？￥')
  end

  def create_folder(destination)
    # #mkdir_p checks for existence so we don't need to
    puts "Creating folder: #{destination}"
    FileUtils.mkdir_p(destination, verbose: false, noop: false)
  end

  def move_files(origin, destination)
    puts "Moving #{origin}"
    @move_history << { origin.to_s => destination }
    FileUtils.cp_r("#{origin}/.", destination, verbose: false, noop: false)
    FileUtils.remove_dir(origin)
  end
end
