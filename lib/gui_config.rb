module GUIConfig
  extend self
  # require 'gtk3'

  def gui_config
    builder_file = './gui/gui_config.glade'
    builder = Gtk::Builder.new(file: builder_file)
    window = builder.get_object('window')
    window.set_title('vnsorter')
    window.set_default_size(720, 540)
    window.signal_connect('destroy') { Gtk.main_quit }

    button_sort = builder.get_object('button_sort')
    button_sort.signal_connect('clicked') do |_widget|
      # puts 'Generating config hash'
      config_hash = generate_config_hash
      # puts 'Writing config'
      write_config(config_hash)
      # puts 'Closing window'
      window.destroy
    end

    get_objects(builder)

    @radiobutton0.group.each do |button|
      connect_signal(button, 'toggled')
    end
    connect_signal(@combo_producer, 'changed')
    connect_signal(@combo_date, 'changed')
    connect_signal(@combo_title, 'changed')

    prev_config = read_prev_config if File.exist?('config.json')
    apply_prev_config(prev_config)

    set_exampleVN_text(prev_config)
    window.show
    Gtk.main
  end

  def connect_signal(object, signal)
    object.signal_connect(signal) do |_widget|
      config = generate_config_hash
      write_config(config)
      set_exampleVN_text(config)
    end
  end

  def set_exampleVN_text(config)
    vn = {
      id: 282,
      date: '2004-11-11',
      title: 'Ever17 -The Out of Infinity- Premium Edition (DreKore)',
      original: 'Ever17 -the out of infinity- PREMIUM EDITION ドリコレ',
      languages: ['ja'],
      vn: [{ 'title' => 'Ever17 -The Out of Infinity-', 'id' => 17, 'original' => nil }], producer: [%w[KID キッド]]
    }
    $CONFIG = config

    @buffer_exampleVN.set_text(Mover.mark_destination(vn))
  end

  def get_objects(builder)
    @button_source = builder.get_object('button_source')
    @button_destination = builder.get_object('button_destination')

    @radiobutton0 = builder.get_object('radiobutton0')

    @combo_producer = builder.get_object('combo_producer')
    @combo_date = builder.get_object('combo_date')
    @combo_title = builder.get_object('combo_title')

    @toggle_discard_publishers = builder.get_object('toggle_discard_publishers')
    @toggle_autoskip = builder.get_object('toggle_autoskip')
    @toggle_full_title_only = builder.get_object('toggle_full_title_only')

    @entry_languages = builder.get_object('entry_languages')
    @entry_extra_file = builder.get_object('entry_extra_file')

    @toggle_ignore_parentheses = builder.get_object('toggle_ignore_parentheses')
    @toggle_blacklist = builder.get_object('toggle_blacklist')
    @toggle_smart_querying = builder.get_object('toggle_smart_querying')

    @combo_special_characters = builder.get_object('combo_special_characters')
    @entry_min_folder_length = builder.get_object('entry_min_folder_length')
    @entry_min_field_length = builder.get_object('entry_min_field_length')

    @buffer_exampleVN = builder.get_object('buffer_exampleVN')
  end

  def read_prev_config
    JSON.parse(File.read('config.json'))
  end

  def apply_prev_config(prev_config)
    @button_source.filename = prev_config['source'] unless prev_config['source'].nil?
    @button_destination.filename = prev_config['destination'] unless prev_config['destination'].nil?

    @radiobutton0.group.each_with_index do |button, index|
      # starts counting from the last item for some reason
      next unless ((@radiobutton0.group.length - 1) - index) == prev_config['choice_naming']

      button.set_active(true)
    end
    @combo_producer.active = prev_config['choice_producer']
    @combo_date.active = prev_config['choice_date']
    @combo_title.active = prev_config['choice_title']

    @toggle_discard_publishers.active = prev_config['discard_publishers']
    @toggle_autoskip.active = prev_config['autoskip']
    @toggle_full_title_only.active = prev_config['full_title_only']

    @entry_languages.text = prev_config['languages'].join
    @entry_extra_file.text = prev_config['extra_file']
    @toggle_ignore_parentheses.active = prev_config['ignore_parentheses']
    @toggle_blacklist.active = prev_config['blacklist']
    @toggle_smart_querying.active = prev_config['smart_querying']

    @combo_special_characters.active = prev_config['special_characters']
    @entry_min_folder_length.text = prev_config['min_folder_length'].to_s
    @entry_min_field_length.text = prev_config['min_field_length'].to_s
  end

  def generate_config_hash
    @radiobutton0_active_index = @radiobutton0.group.each_with_index do |button, index|
      next unless button.active?

      # starts counting from the last item for some reason
      break (@radiobutton0.group.length - 1) - index
    end

    @languages = @entry_languages.text == '' ? [] : @entry_languages.text.split(',')

    {
      'source' => @button_source.filename,
      'destination' => @button_destination.filename,

      'choice_naming' => @radiobutton0_active_index,
      'choice_producer' => @combo_producer.active,
      'choice_date' => @combo_date.active,
      'choice_title' => @combo_title.active,

      'discard_publishers' => @toggle_discard_publishers.active?,
      'autoskip' => @toggle_autoskip.active?,
      'full_title_only' => @toggle_full_title_only.active?,

      'languages' => @languages,
      'extra_file' => @entry_extra_file.text,

      'ignore_parentheses' => @toggle_ignore_parentheses.active?,
      'blacklist' => @toggle_blacklist.active?,
      'smart_querying' => @toggle_smart_querying.active?,

      'special_characters' => @combo_special_characters.active,
      'min_folder_length' => @entry_min_folder_length.text.to_i,
      'min_field_length' => @entry_min_field_length.text.to_i
    }
  end

  def write_config(config_hash)
    File.open('config.json', 'w') do |f|
      f.write JSON.pretty_generate(config_hash)
    end
  end
end
