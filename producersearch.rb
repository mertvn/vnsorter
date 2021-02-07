module ProducerSearch
  extend self

  REQ_PRODUCER = 'get producer basic '.freeze
  REQ_RELEASE_FULL = 'get release basic,producers '.freeze

  # remember that there might be multiple producers
  # remember it's "producer" filter on "get release", not "get producer" for getting vns
  def producer_query(producer_array, date)
    @producer_ids = []
    @releases = []

    # YYMMDD date to YYYY-MM-DD date
    yy = date[0][0..1] >= '80' ? '19' : '20'
    date = date[0].split('').unshift(yy).insert(3, '-').insert(6, '-').join

    producer_filter = "(name~\"#{producer_array[0]}\" or original~\"#{producer_array[0]}\")"
    producer_options = '{ "results": 25 }'
    producer_final = (REQ_PRODUCER + producer_filter + producer_options).encode('UTF-8')

    VNDB.send(producer_final)
    puts JSON.pretty_generate(parsed_producers = (VNDB.parse VNDB.read))
    parsed_producers['items'].each do |producer|
      @producer_ids << producer['id']
    end

    # need to deal with multiple producers here
    # @producer_ids.each do |id|
    release_full_filter = "(producer=\"#{@producer_ids[0]}\" and released=\"#{date}\")"
    release_full_options = '{ "results": 25 }'
    release_full_final = (REQ_RELEASE_FULL + release_full_filter + release_full_options).encode('UTF-8')
    # end

    VNDB.send(release_full_final)

    puts JSON.pretty_generate(parsed_releases = (VNDB.parse VNDB.read))
    parsed_releases['items'].each do |release|
      @releases << { id: release['id'], date: release['released'], title: release['title'],
                     original: release['original'], languages: release['languages'],
                     # fix this shit
                     producer: [[release['producers'][0]['name']]] }
    end
    @releases
  end
end
