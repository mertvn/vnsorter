module Extractor
  extend self

  @found_vns = []
  @blacklist = IO.readlines('./blacklist.txt', chomp: true).freeze

  def extract(directory)
    find(directory)
    @found_vns
  end

  # search for vn folders or files (archives)
  def find(directory)
    min_folder_length = $CONFIG['min_folder_length']
    min_field_length = $CONFIG['min_field_length']

    Dir.entries(directory, encoding: 'UTF-8').each do |folder|
      next if folder.length < min_folder_length
      next if folder == '!vnsorter.json'
      next if File.file?(folder) && !['.zip', '.rar', '.7z'].include?(File.extname(folder))

      date = []
      producer = []
      title = []
      vnsorter_file = nil

      if File.exist?("#{directory}/#{folder}/!vnsorter.json")
        vnsorter_file = JSON.parse(File.read("#{directory}/#{folder}/!vnsorter.json"))
        # https://stackoverflow.com/a/10786575
        vnsorter_file.default_proc = proc { |h, k| h.key?(k.to_s) ? h[k.to_s] : nil }
      end

      # TODO: support other SI kinds
      if folder.start_with?('SI(VndbRid=')
        found_vn = { location: "#{directory}/#{folder}".encode('UTF-8'),
                     vnsorter_file: vnsorter_file,
                     SI: folder.gsub('SI(VndbRid=', '').gsub(')', '') }
        # p found_vn
        @found_vns << found_vn
        next
      end

      # add whitespace after brackets,
      # replace periods with whitespace,
      # split by whitespace, but keep the whitespace if it's inside brackets or parentheses
      fields = folder.gsub(']', '] ').gsub('.', ' ').split(/\s+(?!([^\[]*\])|[^(]*\))/)
      fields.each do |field|
        field = field.encode('UTF-8')
        next if ($CONFIG['blacklist'] && @blacklist.include?(field.downcase)) || field.length < min_field_length

        # remove fullwidth parentheses as well for producer names like [HULOTTE（ユロット）]
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

      found_vn = { location: "#{directory}/#{folder}".encode('UTF-8'),
                   date: date,
                   producer: producer,
                   title: title,
                   vnsorter_file: vnsorter_file }
      # p found_vn
      @found_vns << found_vn

      next unless $CONFIG['recursive_extraction'] &&
                  File.directory?(found_vn[:location]) &&
                  found_vn[:vnsorter_file].nil? # this might be unwanted behavior for some people idk

      find(found_vn[:location])
    end
  end
end
