module Search
  extend self

  # refactor this
  def match_by_all(producer, date, current_folder, title)
    selected = []
    releases = AllSearch.all_query(producer, date)
    return 'empty' if releases.empty?

    # if VN mode is enabled
    # check if all the releases found belong to the same VN
    # if so, automatically select the first release because we don't care about releases
    if same_vn?(releases) && ($CONFIG['choice_title'] == 2 || $CONFIG['choice_title'] == 3)
      puts ''
      puts 'Found perfect match automatically because VN mode was enabled'
      puts ''
      return releases[0]
    end
    if releases.length > 1
      # match automatically if title matches or ask user
      releases.each do |release|
        # try to make this fuzzy somehow
        next unless release[:title] == title || release[:original] == title

        puts ''
        puts 'Found perfect match automatically with AllSearch'
        puts ''
        return release
      end

      # Couldn't match automatically, asking user unless autoskip is enabled
      return 'autoskip' if $CONFIG['autoskip']

      puts 'Multiple releases found by the same producer on the same date'
      puts ''
      if $GUI

        GUIChoose.gui_choose(releases, current_folder)
        case $GUI_CHOOSE_RETURN
        when 'stop'
          'stop'
        when 'skip'
          'skip'
        when 'next'
          'next'
        else
          return $GUI_CHOOSE_RETURN
        end
      else
        display_query_results(releases)
        puts "Folder: #{current_folder}"
        ask_user_release(selected, releases) while selected.empty?
      end
    else
      return 'autoskip' if releases[0][:vn].length > 1 &&
                           $CONFIG['autoskip'] &&
                           ($CONFIG['choice_title'] == 2 || $CONFIG['choice_title'] == 3)

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
    # releases = TitleSearchDb.title_query(title)
    return 'empty' if releases.empty?

    # if VN mode is enabled
    # check if all the releases found belong to the same VN
    # if so, automatically select the first release because we don't care about releases
    if same_vn?(releases) && ($CONFIG['choice_title'] == 2 || $CONFIG['choice_title'] == 3)
      puts ''
      puts 'Found perfect match automatically because VN mode was enabled'
      puts ''
      return releases[0]
    end

    # Couldn't match automatically, asking user unless autoskip is enabled
    return 'autoskip' if $CONFIG['autoskip']

    if $GUI
      GUIChoose.gui_choose(releases, current_folder)
      case $GUI_CHOOSE_RETURN
      when 'stop'
        'stop'
      when 'skip'
        'skip'
      when 'next'
        'next'
      else
        $GUI_CHOOSE_RETURN
      end
    else
      display_query_results(releases)
      puts "Folder: #{current_folder}"
      ask_user_release(selected, releases) while selected.empty?
      selected[0]
    end
  end

  def match_by_si(si, current_folder)
    selected = []
    releases = SISearch.si_query(si)
    # releases = TitleSearchDb.title_query(title)
    return 'empty' if releases.empty?

    # if VN mode is enabled
    # check if all the releases found belong to the same VN
    # if so, automatically select the first release because we don't care about releases
    if same_vn?(releases) && ($CONFIG['choice_title'] == 2 || $CONFIG['choice_title'] == 3)
      puts ''
      puts 'Found perfect match automatically because VN mode was enabled'
      puts ''
      return releases[0]
    end

    if releases.length == 1
      puts ''
      puts 'Found perfect match automatically because releases.length == 1'
      puts ''
      return releases[0]
    end

    # Couldn't match automatically, asking user unless autoskip is enabled
    return 'autoskip' if $CONFIG['autoskip']

    if $GUI
      GUIChoose.gui_choose(releases, current_folder)
      case $GUI_CHOOSE_RETURN
      when 'stop'
        'stop'
      when 'skip'
        'skip'
      when 'next'
        'next'
      else
        $GUI_CHOOSE_RETURN
      end
    else
      display_query_results(releases)
      puts "Folder: #{current_folder}"
      ask_user_release(selected, releases) while selected.empty?
      selected[0]
    end
  end

  def same_vn?(releases)
    # return false
    vn_ids = []
    releases.each do |release|
      release[:vn].each do |vn|
        vn_ids << vn['id']
      end
    end
    vn_ids.uniq.length == 1
  end

  def insert_producers(release)
    producers = []

    release['producers'].each do |producer|
      next if $CONFIG['discard_publishers'] && producer['developer'] == false

      producers << [producer['name'], producer['original']]
    end
    producers
  end

  def display_query_results(releases)
    releases.each do |release|
      puts "https://vndb.org/r#{release[:id]}"
      puts "ID: #{release[:id]}"
      puts "Date: #{release[:date]}"
      puts "Producer: #{release[:producer]}"
      puts "Title: #{release[:title]}"
      puts "Original:  #{release[:original]}"
      puts "Languages:  #{release[:languages]}"
      puts "VN:  #{release[:vn]}"
      puts ''
    end
  end

  # refactor this to return values instead of shoveling to an array
  def ask_user_release(selected, releases)
    puts 'Enter the ID of the correct release or "next" or "skip" or "stop"'
    input = Input.get_input until Input.valid_input?(input)
    case input
    when 'next'
      selected << 'next'
    when 'skip'
      selected << 'skip'
    when 'stop'
      selected << 'stop'
    else
      select_release(input, selected, releases)
    end
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
