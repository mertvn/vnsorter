# ProducerAndDateSearch was a bit too long for my tastes
module AllSearch
  extend self

  REQ_PRODUCER = 'get producer basic '.freeze
  REQ_RELEASE_ALL = 'get release basic,producers,vn '.freeze

  def all_query(producer_array, date)
    @releases = []

    date = convert_date(date)
    producer_ids = get_producer_ids(producer_array)
    # give up on allsearch if we can't find any producers
    get_releases_with_producer_and_date(producer_ids, date) unless producer_ids.empty?

    @releases
  end

  private

  def convert_date(date)
    # Converts YYMMDD date to YYYY-MM-DD date; will break in 2080
    yy = date[0][0..1] >= '80' ? '19' : '20'
    date[0].split('').unshift(yy).insert(3, '-').insert(6, '-').join
  end

  def get_producer_ids(producer_array)
    producer_ids = []
    parsed_producers = []

    str_producer = ''
    producer_array.each do |producer|
      str_producer += "search~\"#{producer}\" or "
    end
    str_producer = str_producer.chomp(' or ')

    producer_filter = "(#{str_producer})"
    producer_options = '{ "results": 25 }'
    producer_final = (REQ_PRODUCER + producer_filter + producer_options).encode('UTF-8')

    VNDB.send(producer_final)
    parsed_producers << VNDB.parse(VNDB.read)
    # puts JSON.pretty_generate(parsed_producers)

    # the naming could be better here
    # keep the repetition with get_releases_with_producer_and_date
    parsed_producers.each do |producers|
      producers['items'].each do |producer|
        producer_ids << producer['id']
      end
    end

    producer_ids
  end

  def get_releases_with_producer_and_date(producer_ids, date)
    parsed_releases = []

    str_id = ''
    producer_ids.each do |id|
      str_id += "producer=\"#{id}\" or "
    end
    str_id = str_id.chomp(' or ')

    release_all_filter = "(((#{str_id}) and released=\"#{date}\")"
    release_all_filter[-1] = $CONFIG['languages'].empty? ? '))' : ") and (languages=#{$CONFIG['languages']}))"
    release_all_options = '{ "results": 25 }'
    release_all_final = (REQ_RELEASE_ALL + release_all_filter + release_all_options).encode('UTF-8')

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
