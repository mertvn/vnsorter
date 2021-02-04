require_relative 'vndb'
require_relative 'input'
require_relative 'search'
require_relative 'extractor'

@vndb = VNDB.new
@search = Search.new(@vndb) # dunno if this is fine
def search_by_title
  # extract

  @vndb.connect
  @vndb.login
  @search.title_query('ハロー・レディ！')
  @search.display_title_query_results
  @search.ask_user
  @vndb.disconnect

  # move
end

search_by_title
