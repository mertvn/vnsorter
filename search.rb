module Search
  extend self

  # no space between flags
  REQ_RELEASE = 'get release basic,producers '.freeze

  # # remember that there might be multiple companies
  # # remember it's "producer" filter on "get release", not "get producer" for getting vns
  # def company_query(company, date); end

  def title_query(title)
    @releases = []

    title_filter = "(title~\"#{title}\" or original~\"#{title}\")"
    title_options = '{ "results": 25 }'
    title_final = (REQ_RELEASE + title_filter + title_options).encode('UTF-8')

    VNDB.send(title_final)
    # puts JSON.pretty_generate(parsed = (@vndb.parse @vndb.read))
    parsed = VNDB.parse(VNDB.read)
    parsed['items'].each_with_index do |release, index|
      @releases << { id: (release['id']), date: (release['released']), title: release['title'],
                     original: release['original'], languages: release['languages'] }

      # should be able to do this without requiring extra arrays
      companyromaji = []
      companyoriginal = []
      release['producers'].each_with_index do |producer, _index|
        companyromaji << producer['name']
        companyoriginal << producer['original']
      end
      @releases[index][:company] = companyromaji.zip(companyoriginal)
    end

    !@releases.empty?
  end

  def display_title_query_results
    @releases.each do |release|
      puts "https://vndb.org/r#{release[:id]}"
      puts "ID: #{release[:id]}"
      puts "Date: #{release[:date]}"
      puts "Company: #{release[:company]}"
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
