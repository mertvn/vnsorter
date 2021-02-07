require 'fileutils'

module Mover
  extend self

  def move(map, library_folder)
    map.each do |combination|
      origin = combination[0]
      p origin
      vn = combination[1]
      next if vn == 'skipped'

      # apparently some vns don't have an original title
      title = vn[:original] || vn[:title]
      # p title
      # fix this later
      company = vn[:company][0][0]
      # p vn[:company].each do |companies|
      #   company = companies[0]
      # end

      # convert date to YYMMDD for now
      # allow more options later
      date = (vn[:date].split('-').join)[2..-1]
      date = date.length == 6 ? date : 'unknown'

      destination = "#{library_folder}/#{company}/[#{date}] #{title}"

      # #mkdir_p checks for existence so we don't need to
      puts "Creating folder: #{destination}"
      FileUtils.mkdir_p(destination, verbose: true, noop: false)

      # there must be a better way of doing this
      Dir.foreach(origin) do |file|
        next if ['.', '..'].include?(file)

        puts "Moving #{origin}/#{file}"
        # don't use #move because it leaves the empty directory behind
        FileUtils.copy("#{origin}/#{file}".encode('UTF-8'), destination.encode('UTF-8'), verbose: true, noop: false)
        # dir isn't removed if there are no files in it
        FileUtils.remove_dir(origin.encode('UTF-8'))
        # add move history
      end
      puts "Move succeeded for #{title}"
    end
  end
end
