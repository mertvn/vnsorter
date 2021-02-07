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
    parsed['items'].each_with_index do |release, index|
      @releases << { id: release['id'], date: release['released'], title: release['title'],
                     original: release['original'], languages: release['languages'] }

      # should be able to do this without requiring extra arrays
      producer_romaji = []
      producer_original = []
      release['producers'].each do |producer|
        # make this toggleable
        next if producer['developer'] == false

        producer_romaji << producer['name']
        producer_original << producer['original']
      end
      @releases[index][:producer] = producer_romaji.zip(producer_original)
    end

    @releases
  end

  def display_title_query_results
    @releases.each do |release|
      puts "https://vndb.org/r#{release[:id]}"
      puts "ID: #{release[:id]}"
      puts "Date: #{release[:date]}"
      puts "Producer: #{release[:producer]}"
      puts "Title: #{release[:title]}"
      puts "Original:  #{release[:original]}"
      puts "Languages:  #{release[:languages]}"
      puts ''
      # puts
    end
  end

  def ask_user(selected)
    # @selected = []
    puts 'Enter the ID of the correct release or "skip"'
    input = Input.get_input until Input.valid_input?(input)
    if input == 'skip'
      selected << 'skipped'
      return
    end
    select_release(input, selected)
  end
end

private

def select_release(input, selected)
  @releases.each do |release|
    selected << release if input == release[:id].to_s
  end
  return unless selected.empty?

  puts "Didn't match. Did you enter the correct number?"
end
