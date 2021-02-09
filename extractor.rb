module Extractor
  extend self
  MIN_FOLDER_LENGTH = 3
  MIN_FIELD_LENGTH = 3
  BLACKLIST = IO.readlines('./blacklist.txt', chomp: true).freeze

  def extract(directory)
    found_vns = []
    fields = []

    Dir.entries(directory).each do |folder|
      next if folder.length < MIN_FOLDER_LENGTH

      date = []
      producer = []
      title = []

      # p folder.encode('UTF-8')
      # remove periods, then split by whitespace, but keep the whitespace if it's inside brackets
      fields = folder.gsub('.', ' ').split(/\s+(?![^\[]*\])/)
      fields.each do |field|
        field = field.encode('UTF-8')
        # needs to be an option
        next if BLACKLIST.include?(field.downcase) || field.length < MIN_FIELD_LENGTH

        # do we really want to remove fullwidth parentheses though?
        # it's necessary for producer names like [HULOTTE（ユロット）] but 
        # I haven't really thought about the side effects
        field = field.gsub(/(\(|（).+?(）|\))/, '')
        puts "field is #{field}"
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
      found_vns << { location: "#{directory}/#{folder}".encode('UTF-8'),
                     date: date,
                     producer: producer,
                     title: title }
    end
    found_vns
  end
end
