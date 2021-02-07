module Extractor
  extend self

  MIN_FOLDER_LENGTH = 3
  MIN_TITLE_LENGTH = 3
  BLACKLIST = %w[bonus
                 manual
                 マニュアル
                 soundtrack
                 ドラマ
                 flac
                 wav
                 bin
                 cue
                 etc
                 sofmap
                 single
                 maxi
                 original
                 tokuten
                 crack
                 ※自炊
                 nodvd
                 nocd
                 update
                 iso
                 mds
                 mdf
                 rar
                 rr3
                 txt].freeze

  def extract(directory)
    found_vns = []
    fields = []

    Dir.entries(directory).each do |folder|
      next if folder.length < MIN_FOLDER_LENGTH

      date = []
      company = []
      title = []

      fields = folder.split(' ')
      fields.each do |field|
        field = field.encode('UTF-8')
        puts "field is #{field}"
        if /\[[0-9]{6}\]/.match(field)
          date << field.gsub(/\[|\]/, '')
          next
        end
        if /\[.+\]/.match(field)
          company << field.gsub(/\[|\]/, '')
          next
        end

        next if field.length < MIN_TITLE_LENGTH ||
                BLACKLIST.include?(field.downcase) ||
                /\(.+?\)/.match(field)

        title << field if /.+/.match(field)
      end
      # puts "date is #{date}"
      # puts "company is #{company}"
      # puts "title is #{title}"
      found_vns << { location: "#{directory}/#{folder}".encode('UTF-8'),
                     date: date,
                     company: company,
                     title: title }
    end
    found_vns
  end
end
