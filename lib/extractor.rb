module Extractor
  extend self

  def extract(directory)
    min_folder_length = $CONFIG['min_folder_length']
    min_field_length = $CONFIG['min_field_length']
    blacklist = IO.readlines('./blacklist.txt', chomp: true).freeze
    found_vns = []
    fields = []

    Dir.entries(directory).each do |folder|
      next if folder.length < min_folder_length

      date = []
      producer = []
      title = []

      # p folder.encode('UTF-8')
      # add whitespace after brackets,
      # replace periods with whitespace,
      # split by whitespace, but keep the whitespace if it's inside brackets or parentheses
      fields = folder.gsub(']', '] ').gsub('.', ' ').split(/\s+(?!([^\[]*\])|[^(]*\))/)
      fields.each do |field|
        field = field.encode('UTF-8')
        next if ($CONFIG['blacklist'] && blacklist.include?(field.downcase)) || field.length < min_field_length

        # do we really want to remove fullwidth parentheses though?
        # it's necessary for producer names like [HULOTTE（ユロット）] but
        # I haven't really thought about the side effects
        field = field.gsub(/(\(|（).+?(）|\))/, '') if $CONFIG['ignore_parentheses']
        # puts "field is #{field}"
        if /\[[0-9]{6}\]/.match(field)
          date << field.gsub(/\[|\]/, '')
          next
        end
        if /\[.+\]/.match(field)
          producer << field.gsub(/\[|\]/, '')
          next
        end

        title << field if /.+/.match(field)
      end
      # we want to search the full title first
      title.unshift(title.join(' ')).uniq!

      found_vns << { location: "#{directory}/#{folder}".encode('UTF-8'),
                     date: date,
                     producer: producer,
                     title: title }
    end
    found_vns
  end
end
