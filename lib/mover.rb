module Mover
  extend self
  # require 'fileutils'

  def move(map, library_folder)
    @move_history = []
    @failed_history = []
    map.each do |combination|
      origin = combination[0].encode('UTF-8')
      # p origin
      vn = combination[1]
      next if vn == 'skipped'

      begin
        destination = "#{library_folder}/" + mark_destination(vn).encode('UTF-8')
        create_folder(destination)
        move_files(origin, destination)
        puts "Move succeeded for #{vn[:title]}"
        puts ''
        @move_history << { origin.to_s => destination }
      rescue StandardError => e
        puts e
        puts "Move failed for #{vn[:title]}"
        puts ''
        @failed_history << { origin.to_s => destination }
        next
      end
    end
    [@move_history, @failed_history]
  end

  private

  def mark_destination(vn)
    # p vn

    # make user select a single producer (unfinished)
    # p "Multiple producers found. Select one"
    # p vn[:producer]
    # producer_selection = Input.get_input
    # producer = vn[:producer][producer_selection]
    # producer = mark_producer(producer)

    # use all producers
    str_producer = ''
    vn[:producer].each do |producer|
      str_producer += mark_producer(producer)
      str_producer += ' & '
    end
    producer = str_producer.chomp(' & ')
    producer = replace_special_characters(producer) if $CONFIG['special_characters'] != 3
    producer = producer.empty? ? 'UNKNOWN_PRODUCER' : producer
    # puts "producer was marked as: #{producer}"

    date = mark_date(vn)
    # puts "date was marked as: #{date}"

    title = mark_title(vn)
    title = replace_special_characters(title)
    # puts "title was marked as: #{title}"

    # use only the first language
    # language = vn[:languages][0]

    # use all languages
    str_language = ''
    vn[:languages].each do |language|
      str_language += language
      str_language += ' & '
    end
    language = str_language.chomp(' & ')
    # puts "language was marked as: #{language}"

    case $CONFIG['choice_naming']
    when 0
      "#{producer}/[#{date}] #{title}"
    when 1
      "#{producer}/[#{date}]/#{title}"
    when 2
      "#{producer}/#{title}"
    when 3
      title.to_s
    when 4
      "[#{date}] #{title}"
    when 5
      "[#{date}]/#{title}"
    when 6
      "[#{language}]/#{title}"
      # when "custom"
    end
  end

  # mkdir_p and cp_r don't like "?"
  # backslash needs to be escaped AND at the end of the string
  # exclamation mark doesn't really need to be here
  def replace_special_characters(string)
    case $CONFIG['special_characters']
    when 0
      # replace with Japanese variants
      string.tr(':/<>|*"!?\\', '：／＜＞｜＊”！？￥')
    when 1
      # replace with whitespace
      string.gsub(':/<>|*"!?\\', ' ')
    when 2
      # remove
      string.gsub(':/<>|*"!?\\', '')
    when 3
      # keep
      string
    end
  end

  def mark_producer(producer)
    case $CONFIG['choice_producer']
    when 0
      # romaji
      producer[0]
    when 1
      # original
      # fallback to romaji name if original name doesn't exist
      producer[1] || producer[0]
    end
  end

  def mark_date(vn)
    case $CONFIG['choice_date']
    when 0
      # YYMMDD
      date = vn[:date].split('-').join[2..-1]
      date.length == 6 ? date : 'UNKNOWN_DATE'
    when 1
      # YYYY-MM-DD
      vn[:date]
    when 2
      # YYYY
      vn[:date].split('-').join[0..3]
      date.length == 4 ? date : 'UNKNOWN_DATE'
    end
  end

  def mark_title(vn)
    case $CONFIG['choice_title']
    when 0
      # romaji
      vn[:title]
    when 1
      # original
      # fallback to romaji title if original title doesn't exist
      vn[:original] || vn[:title]
    end
  end

  def create_folder(destination)
    # #mkdir_p checks for existence so we don't need to
    puts "Creating folder: #{destination}"
    FileUtils.mkdir_p(destination, verbose: false, noop: false)
  end

  def move_files(origin, destination)
    puts "Moving #{origin}"
    FileUtils.cp_r("#{origin}/.", destination, verbose: false, noop: false)
    FileUtils.remove_dir(origin)
  end
end
