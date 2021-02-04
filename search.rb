class Search
  def initialize(vndb)
    @vndb = vndb
  end
  REQ_RELEASE = 'get release basic,producers '.freeze # no space between flags

  def title_query(title)
    @releases = []
    @selected = []
    title_filter = "(title~\"#{title}\" or original~\"#{title}\")"
    title_options = '{ "results": 25 }'
    title_final = REQ_RELEASE + title_filter + title_options

    @vndb.send title_final
    puts JSON.pretty_generate(parsed = (@vndb.parse @vndb.read))

    parsed['items'].each_with_index do |release, index|
      @releases << { id: (release['id']), date: (release['released']), title: release['title'],
                     original: release['original'], languages: release['languages'] }
      companyromaji = []
      companyoriginal = []
      release['producers'].each_with_index do |producer, _index|
        companyromaji << producer['name']
        companyoriginal << producer['original']
      end
      @releases[index][:company] = companyromaji.zip(companyoriginal)
    end

    # p @releases
  end

  def display_title_query_results
    @releases.each do |release|
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

  def ask_user
    puts 'Enter the ID of the correct release or "skip"'
    input = Input.get_input until Input.valid_input?(input)
    return if input == 'skip'

    @releases.each do |release|
      @selected << release if input == release[:id].to_s
    end
    # if releases.find(|release.id| release.id == input)
    p @selected
  end
end
# vndb = Networking.new
