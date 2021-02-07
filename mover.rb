require 'fileutils'

module Mover
  extend self

  def move(map, library_folder)
    @move_history = []
    map.each do |combination|
      origin = combination[0]
      p origin
      vn = combination[1]
      next if vn == 'skipped'

      # naming_option = get from gui somehow
      naming_option = '1'
      destination = mark_destination(vn, library_folder, naming_option)

      create_folder(destination)
      move_files(origin, destination)
      puts "Move succeeded for #{vn[:title]}"
    end
    @move_history
  end

  private

  def mark_destination(vn, library_folder, naming_option)
    # apparently some vns don't have an original title
    title = vn[:original] || vn[:title]
    # p title

    # fix this later
    company = vn[:company][0][0]
    # vn[:company].each do |companies|
    #   p company = companies[0]
    # end

    # convert date to YYMMDD for now
    # allow more options later
    date = (vn[:date].split('-').join)[2..-1]
    date = date.length == 6 ? date : 'unknown'

    # keep the repetition
    case naming_option
    when '1'
      "#{library_folder}/#{company}/[#{date}] #{title}"
    when '2'
      "#{library_folder}/#{company}/#{title}"
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

  # there must be a better way of doing this
  def move_files(origin, destination)
    Dir.foreach(origin) do |file|
      next if ['.', '..'].include?(file)

      puts "Moving #{origin}/#{file}"
      # does this really create a string=>string hash? confirm it
      @move_history << { "#{origin}/#{file}" => destination }
      # don't use #move because it leaves the empty directory behind
      FileUtils.copy("#{origin}/#{file}".encode('UTF-8'), destination.encode('UTF-8'), verbose: false, noop: false)
      # dir isn't removed if no files were moved
      FileUtils.remove_dir(origin.encode('UTF-8'))
    end
  end
end
