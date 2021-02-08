module Search
  extend self

  def match_by_all(producer, date)
    selected = []
    p releases = AllSearch.all_query(producer, date)

    # need to title search here
    return 'empty' if releases.empty?

    if releases.length > 1
      JSON.pretty_generate(releases)
      display_query_results(releases)
      ask_user(selected, releases) while selected.empty?
    else
      p 'Found accurate match automatically with AllSearch'
      selected = releases
    end

    selected[0]
  end

  def match_by_title(title)
    selected = []
    p releases = TitleSearch.title_query(title)
    return 'empty' if releases.empty?

    display_query_results(releases)
    ask_user(selected, releases) while selected.empty?

    selected[0]
  end

  # should be able to do this without requiring extra arrays
  def insert_producers(release)
    producer_romaji = []
    producer_original = []
    release['producers'].each do |producer|
      # make this toggleable
      next if producer['developer'] == false

      producer_romaji << producer['name']
      producer_original << producer['original']
    end
    producer_romaji.zip(producer_original)
  end

  def display_query_results(releases = @releases)
    releases.each do |release|
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

  def ask_user(selected, releases)
    puts 'Enter the ID of the correct release or "skip"'
    input = Input.get_input until Input.valid_input?(input)
    if input == 'skip'
      selected << 'skipped'
      return
    end
    select_release(input, selected, releases)
  end

  private

  def select_release(input, selected, releases)
    releases.each do |release|
      selected << release if input == release[:id].to_s
    end
    return unless selected.empty?

    puts "Didn't match. Did you enter the correct number?"
  end
end
