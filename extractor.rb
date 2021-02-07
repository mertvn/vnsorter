module Extractor
  extend self

  MIN_FOLDER_LENGTH = 3
  MIN_TITLE_LENGTH = 3
  BLACKLIST = %w[bonus
                 manual
                 マニュアル
                 ドラマ
                 soundtrack
                 サウンドトラック
                 flac
                 wav
                 bin
                 cue
                 etc
                 single
                 maxi
                 original
                 tokuten
                 予約特典
                 sofmap
                 sofmap特典
                 ボーカル
                 ソング
                 ボーカルソング
                 crack
                 認証回避
                 ※自炊
                 patch
                 パッチ
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
      producer = []
      title = []

      fields = folder.split(' ')
      fields.each do |field|
        field = field.encode('UTF-8')
        next if BLACKLIST.include?(field.downcase) || /\(.+?\)/.match(field)

        puts "field is #{field}"
        if /\[[0-9]{6}\]/.match(field)
          date << field.gsub(/\[|\]/, '')
          next
        end
        if /\[.+\]/.match(field)
          producer << field.gsub(/\[|\]/, '')
          next
        end

        next if field.length < MIN_TITLE_LENGTH

        title << field if /.+/.match(field)
      end
      found_vns << { location: "#{directory}/#{folder}".encode('UTF-8'),
                     date: date,
                     producer: producer,
                     title: title }
    end
    found_vns
  end
end
