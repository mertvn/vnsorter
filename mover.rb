require 'fileutils'

module Mover
  extend self

  def move(map, library_folder)
    map.each do |combination|
      origin = combination[0]
      p origin
      vn = combination[1]
      next if vn == 'skipped'

      title = vn[:original]

      # fix this later
      company = vn[:company][0][0]
      # p vn[:company].each do |companies|
      #   company = companies[0]
      # end

      # convert date to YYMMDD
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
        FileUtils.copy("#{origin}/#{file}", destination, verbose: true, noop: false)
        FileUtils.remove_dir(origin)
        # add move history
      end
      puts "Move succeeded for #{title}"
    end
  end
end
