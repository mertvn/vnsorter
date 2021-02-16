module GUI
  extend self
  require 'gtk3'

  def gui_config
    builder_file = './gui.glade'
    builder = Gtk::Builder.new(file: builder_file)

    window = builder.get_object('window')
    window.set_title('vnsorter')
    window.set_default_size(720, 540)
    window.signal_connect('destroy') { Gtk.main_quit }

    button_sort = builder.get_object('button_sort')
    button_sort.signal_connect('clicked') do |_widget|
      puts 'Generating config hash'
      config_hash = generate_config_hash(builder)
      puts 'Writing config'
      write_config(config_hash)
      puts 'Closing window'
      window.destroy
    end

    buffer_exampleVN = builder.get_object('buffer_exampleVN')
    buffer_exampleVN.set_text('testing text buffer')

    window.show
    Gtk.main
  end

  def generate_config_hash(builder)
    button_source = builder.get_object('button_source')
    button_destination = builder.get_object('button_destination')

    radiobutton0 = builder.get_object('radiobutton0')
    radiobutton0_active_index = radiobutton0.group.each_with_index do |button, index|
      next unless button.active?

      # starts counting from the last item for some reason
      break (radiobutton0.group.length - 1) - index
    end

    combo_producer = builder.get_object('combo_producer')
    combo_date = builder.get_object('combo_date')
    combo_title = builder.get_object('combo_title')

    toggle_discard_publishers = builder.get_object('toggle_discard_publishers')
    toggle_autoskip = builder.get_object('toggle_autoskip')
    toggle_full_title_only = builder.get_object('toggle_full_title_only')

    entry_languages = builder.get_object('entry_languages')
    languages = entry_languages.text == '' ? [] : entry_languages.text.split(',')

    toggle_ignore_parentheses = builder.get_object('toggle_ignore_parentheses')
    toggle_blacklist = builder.get_object('toggle_blacklist')
    toggle_smart_querying = builder.get_object('toggle_smart_querying')

    combo_special_characters = builder.get_object('combo_special_characters')
    entry_min_folder_length = builder.get_object('entry_min_folder_length')
    entry_min_field_length = builder.get_object('entry_min_field_length')

    {
      'source' => button_source.filename,
      'destination' => button_destination.filename,
      'languages' => languages,

      'choice_naming' => radiobutton0_active_index,
      'choice_producer' => combo_producer.active,
      'choice_date' => combo_date.active,
      'choice_title' => combo_title.active,

      'discard_publishers' => toggle_discard_publishers.active?,
      'autoskip' => toggle_autoskip.active?,
      'full_title_only' => toggle_full_title_only.active?,

      'ignore_parentheses' => toggle_ignore_parentheses.active?,
      'blacklist' => toggle_blacklist.active?,
      'smart_querying' => toggle_smart_querying.active?,

      'special_characters' => combo_special_characters.active,
      'min_folder_length' => entry_min_folder_length.text.to_i,
      'min_field_length' => entry_min_field_length.text.to_i
    }
  end

  def write_config(config_hash)
    File.open('config.json', 'w') do |f|
      f.write JSON.pretty_generate(config_hash)
    end
  end
end
