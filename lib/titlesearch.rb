module TitleSearch
  extend self

  # no space between flags
  REQ_RELEASE_TITLE = 'get release basic,producers,vn '.freeze

  def title_query(title)
    @releases = []

    title_filter = case $CONFIG['smart_querying']
                   when true
                     has_japanese = /[\u3040-\u30ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff\uff66-\uff9f]/.match(title)
                     has_japanese ? "((original~\"#{title}\")" : "((title~\"#{title}\")"
                   when false
                     "((title~\"#{title}\" or original~\"#{title}\")"
                   end
    title_filter[-1] = $CONFIG['languages'].empty? ? '))' : ") and (languages=#{$CONFIG['languages']}))"
    title_options = '{ "results": 25 }'
    title_final = (REQ_RELEASE_TITLE + title_filter + title_options).encode('UTF-8')

    VNDB.send(title_final)
    # puts JSON.pretty_generate(parsed = VNDB.parse(VNDB.read))
    parsed = VNDB.parse(VNDB.read)
    parsed['items'].each do |release|
      @releases << { id: release['id'], date: release['released'], title: release['title'],
                     original: release['original'], languages: release['languages'], vn: release['vn'] }

      @releases[-1][:producer] = Search.insert_producers(release)
    end

    @releases
  end
end
