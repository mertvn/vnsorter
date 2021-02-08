require 'fileutils'

module Mover
  extend self

  def move(map, library_folder)
    @move_history = []
    @failed_history = []
    map.each do |combination|
      origin = combination[0].encode('UTF-8')
      p origin
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
    # apparently some vns don't have an original title
    title = vn[:original] || vn[:title]
    # backslash needs to be escaped AND at the end of the string
    # this needs to be a setting
    title = title.tr(':/<>|*"!?\\', '：／＜＞｜＊”！？￥')
    # p title

    # fix this
    p vn
    producer = vn[:producer][0][0]
    producer = producer.tr(':/<>|*"!?\\', '：／＜＞｜＊”！？￥')
    # vn[:producer].each do |producers|
    #   p producer = producers[0]
    # end

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
