# incomplete/abandoned
module TitleSearchDb
  extend self

  # no space between flags
  REQ_RELEASE_TITLE = 'get release basic,producers,vn '.freeze

  def title_query(title)
    @releases = []
    vid = nil
    rids = []

    File.readlines('K:/vndb-db-2022-05-29/db/vn_titles').each do |line|
      vn_title = line.split("\t")
      if vn_title[2] == title
        vid = vn_title[0]
        puts vid
      end
    end

    if vid
      File.readlines('K:/vndb-db-2022-05-29/db/releases_vn').each do |line1|
        release_vn = line1.split("\t")
        if release_vn[1] == vid
          rids << release_vn[0]
          puts rids
        end
      end

      unless rids.empty?
        File.readlines('K:/vndb-db-2022-05-29/db/releases').each do |line2|
          release = line2.split("\t")
          rids.each_with_index do |rid, i|
            if release[0] == rid
              # TODO: date format is wrong
              @releases << { id: release[0], date: release[4], title: release[29],
                             original: release[30], languages: ["jp"], vn: [{"id":69 + i, "title":"mytitle", "original":'myoriginal'}]
                             #languages: release['languages'], vn: release['vn'] 
                            }
              # p @releases
              # abort
            end
          end
        end
      end
    end

    # title_filter = case $CONFIG['smart_querying']
    #                when true
    #                  has_japanese = /[\u3040-\u30ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff\uff66-\uff9f]/.match(title)
    #                  has_japanese ? "((original~\"#{title}\")" : "((title~\"#{title}\")"
    #                when false
    #                  "((title~\"#{title}\" or original~\"#{title}\")"
    #                end
    # title_filter[-1] = $CONFIG['languages'].empty? ? '))' : ") and (languages=#{$CONFIG['languages']}))"
    # title_options = '{ "results": 25 }'
    # title_final = (REQ_RELEASE_TITLE + title_filter + title_options).encode('UTF-8')

    # VNDB.send(title_final)
    # parsed = VNDB.parse(VNDB.read)
    # # puts JSON.pretty_generate(parsed)
    # parsed['items'].each do |release|
    #   @releases << { id: release['id'], date: release['released'], title: release['title'],
    #                  original: release['original'], languages: release['languages'], vn: release['vn'] }

    #   @releases[-1][:producer] = Search.insert_producers(release)
    # end

    @releases
    # abort 
  end
end
