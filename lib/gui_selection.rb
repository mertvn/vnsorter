module GUISelection
  extend self
  # require 'gtk3'

  def gui_selection(map)
    builder_file = './gui/gui_selection.glade'
    builder = Gtk::Builder.new(file: builder_file)
    window = builder.get_object('window')
    window.set_title('vnsorter')
    window.set_default_size(720, 540)
    window.signal_connect('destroy') do |_widget|
      Gtk.main_quit
      abort('Window was closed')
    end

    button_proceed = builder.get_object('button_proceed')
    button_proceed.signal_connect('clicked') do |_widget|
      write_planned_moves

      window.hide
      Gtk.main_quit
    end

    @listbox = builder.get_object('listbox')
    map.each do |item|
      row = Gtk::ListBoxRow.new
      box = Gtk::Box.new(:horizontal, 10)

      checkbutton = Gtk::CheckButton.new
      checkbutton.active = true
      checkbutton.show
      box.add(checkbutton)

      label = Gtk::Label.new(item.to_s)
      label.show
      box.add(label)

      box.show
      row.add(box)
      row.show
      @listbox.add(row)
    end

    window.show
    Gtk.main
  end

  def write_planned_moves
    @final = []
    @listbox.each do |row|
      row.each do |box|
        # i hope GTK guarantees that the order of the children won't change
        next unless box.children[0].active?

        @final << box.children[1].text.gsub('=>', ':')
      end
    end
    $FINAL = (@final.map { |combination| JSON.parse(combination) })
  end
end
