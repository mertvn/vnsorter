require_relative 'vndb'
require_relative 'input'
require_relative 'search'
require_relative 'extractor'

@vndb = VNDB.new
@search = Search.new(@vndb) # dunno if this is fine

def match_by_title(title)
  # extract

  @vndb.connect
  @vndb.login

  @search.title_query(title)
  @search.display_title_query_results
  @search.ask_user while @search.selected.empty?
  p @search.selected

  @vndb.disconnect

  # move
end

match_by_title('ハロー・レディ！')
