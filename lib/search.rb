module Search
  extend self

  def match_by_all(producer, date, current_folder)
    selected = []
    releases = AllSearch.all_query(producer, date)
    return 'empty' if releases.empty?

    if releases.length > 1
      # need to title search here before asking the user
      puts 'Multiple releases found by the same producer on the same date'
      puts ''
      JSON.pretty_generate(releases)
      display_query_results(releases)
      puts "Folder: #{current_folder}"
      ask_user(selected, releases) while selected.empty?
    else
      puts ''
      puts 'Found perfect match automatically with AllSearch'
      puts ''
      selected = releases
    end

    selected[0]
  end

  def match_by_title(title, current_folder)
    selected = []
    releases = TitleSearch.title_query(title)
    return 'empty' if releases.empty?

    display_query_results(releases)
    puts "Folder: #{current_folder}"
    ask_user(selected, releases) while selected.empty?

    selected[0]
  end

  def insert_producers(release)
    producers = []

    release['producers'].each do |producer|
      next if $CONFIG['discard_publishers'] && producer['developer'] == false

      producers << [producer['name'], producer['original']]
    end
    producers
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
