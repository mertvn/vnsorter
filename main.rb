require_relative 'vndb'
require_relative 'input'
require_relative 'search'
require_relative 'extractor'

@vndb = VNDB.new

@vndb.connect
@vndb.login

def match_by_title(title)
  @search = Search.new(@vndb) # dunno if this is fine

  return 'empty' unless @search.title_query(title)

  @search.display_title_query_results
  @search.ask_user while @search.selected.empty?
  @search.selected
end

extracted = Extractor.extract
p extracted

@map = {}
extracted.each_with_index do |folder, index|
  # match_by_all

  next unless index > 9

  # p folder[:title]
  puts 'new title search'
  folder[:title].each do |subtitle|
    puts 'new subtitle search'
    match = match_by_title(subtitle)
    # p match
    if match == 'empty'
      puts 'No results, skipping'
      next
    end

    # unnecessary for now
    # if match[0] == 'skipped'
    #   puts 'skipping'
    #   next
    # end

    @map[folder[:location]] = match
  end
end
p @map
@vndb.disconnect
