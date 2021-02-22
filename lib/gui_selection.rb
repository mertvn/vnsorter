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
      write_planned_moves
      Gtk.main_quit
    end

    @listbox = builder.get_object('listbox')
    map.each do |item|
      row = Gtk::ListBoxRow.new
      box = Gtk::Box.new(:horizontal, 30)

      label = Gtk::Label.new(item.to_s)
      label.show
      box.add(label)

      checkbutton = Gtk::CheckButton.new
      checkbutton.active = true
      checkbutton.show
      box.add(checkbutton)

      box.show
      row.add(box)
      row.show
      @listbox.add(row)
    end

    window.show
    Gtk.main
  end

  # so much bullshit to do something that should be pretty simple
  def write_planned_moves
    @new_planned_moves = []
    @listbox.each do |row|
      row.each do |box|
        box.each do |item|
          next if item.instance_of?(Gtk::Label)

          # puts item.active? ? 'active' : 'inactive'
          @new_planned_moves << (item.active? ? box : 'skip')
        end
      end
    end
    @final = []
    @new_planned_moves.each do |box|
      next if box == 'skip'

      box.each do |item|
        next if item.instance_of?(Gtk::CheckButton)

        @final << item.text.gsub('=>', ':')
      end
    end
    $FINAL = (@final.map { |combination| JSON.parse(combination) })
  end
end
