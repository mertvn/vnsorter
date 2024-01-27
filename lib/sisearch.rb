module SISearch
  extend self

  REQ_RELEASE_ALL = 'get release basic,producers,vn '.freeze

  def si_query(si)
    @releases = []

    # TODO: support other SI kinds
    get_releases_with_release_id(si)

    @releases
  end

  private

  def get_releases_with_release_id(rid)
    parsed_releases = []

    release_all_filter = "(id = #{rid.gsub('r', '')})"
    release_all_options = '{ "results": 25 }'
    release_all_final = (REQ_RELEASE_ALL + release_all_filter + release_all_options).encode('UTF-8')

    # puts release_all_final
    # a = gets.chomp

    VNDB.send(release_all_final)
    parsed_releases << VNDB.parse(VNDB.read)
    # puts JSON.pretty_generate(parsed_releases)

    # the naming could be better here
    # keep the repetition with get_producer_ids
    release_ids = []
    parsed_releases.each do |releases|
      releases['items'].each do |release|
        # prevent duplicates
        next if release_ids.include?(release['id'])

        release_ids << release['id']

        @releases << { id: release['id'], date: release['released'], title: release['title'],
                       original: release['original'], languages: release['languages'], vn: release['vn'] }

        @releases[-1][:producer] = Search.insert_producers(release)
      end
    end
  end
end
