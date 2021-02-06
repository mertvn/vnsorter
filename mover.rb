require 'fileutils'

module Mover
  extend self

  def move(map, library_folder)
    map.each do |combination|
      origin = combination[0]
      vn = combination[1]

      title = vn[:original]

      # fix this later
      company = vn[:company][0][0]
      # p vn[:company].each do |companies|
      #   company = companies[0]
      # end

      # convert date to YYMMDD
      date = (vn[:date].split('-').join)[2..-1]

      destination = "#{library_folder}/#{company}/[#{date}] #{title}"

      # #mkdir_p checks for existence so we don't need to
      p "Creating folder: #{destination}"
      FileUtils.mkdir_p(destination, verbose: true, noop: false)
    end
  end
end
