module TitleSearch
  extend self

  # no space between flags
  REQ_RELEASE = 'get release basic,producers '.freeze

  # try using the "search" filter on "get vn" to get vns instead
  def title_query(title)
    @releases = []

    title_filter = "(title~\"#{title}\" or original~\"#{title}\")"
    title_options = '{ "results": 25 }'
    title_final = (REQ_RELEASE + title_filter + title_options).encode('UTF-8')

    VNDB.send(title_final)
    # puts JSON.pretty_generate(parsed = (@vndb.parse @vndb.read))
    parsed = VNDB.parse(VNDB.read)
    parsed['items'].each do |release|
      @releases << { id: release['id'], date: release['released'], title: release['title'],
                     original: release['original'], languages: release['languages'] }

      @releases[-1][:producer] = Search.insert_producers(release)
    end

    @releases
  end
end
