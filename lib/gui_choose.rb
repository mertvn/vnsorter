# frozen_string_literal: true
module GUIChoose
  module_function
  # require 'gtk3'

  REQ_VN_DETAILS = 'get vn basic,details '

  def gui_choose(releases, current_folder)
    $GUI_CHOOSE_RETURN = nil

    builder_file = './gui/gui_choose.glade'
    builder = Gtk::Builder.new(file: builder_file)
    window = builder.get_object('window')
    window.set_title('vnsorter')
    window.set_default_size(1280, 720)
    window.signal_connect('destroy') do |_widget|
      $GUI_CHOOSE_RETURN = 'skip'

      window.hide
      Gtk.main_quit
    end

    get_objects(builder)
    @label_folderinfo.set_text(current_folder)

    @releases = {}
    @vns = {}
    flowbox = builder.get_object('flowbox')
    releases.each_with_index do |release, i|
      # TODO: handle multiple vns per release
      vn_id = release[:vn][0]['id']
      # vn_id = release[:vn][0][:id]
      # p release[:vn]
      # p vn_id
      parsed_vn = nil
      if @vns[vn_id]
        parsed_vn = @vns[vn_id]
      elsif $CONFIG['get_image']
        vn_filter = "(id=\"#{vn_id}\")"
        vn_final = (REQ_VN_DETAILS + vn_filter).encode('UTF-8')

        VNDB.send(vn_final)
        parsed_vn = VNDB.parse(VNDB.read)['items'][0]
        @vns[vn_id] = parsed_vn
      end

      @releases[i] = release
      make_vn_box(release, parsed_vn, flowbox)
    end

    @button_manual.signal_connect('clicked') do |_widget|
      # rid = ask_release_id
      # Gtk.main_quit
      # return rid
    end
    @button_next.signal_connect('clicked') do |_widget|
      $GUI_CHOOSE_RETURN = 'next'

      window.hide
      Gtk.main_quit
    end
    @button_select.signal_connect('clicked') do |_widget|
      selected = flowbox.selected_children[0]
      $GUI_CHOOSE_RETURN = @releases[selected.index]

      window.hide
      Gtk.main_quit
    end
    @button_skip.signal_connect('clicked') do |_widget|
      $GUI_CHOOSE_RETURN = 'skip'

      window.hide
      Gtk.main_quit
    end
    @button_stop.signal_connect('clicked') do |_widget|
      $GUI_CHOOSE_RETURN = 'stop'

      window.hide
      Gtk.main_quit
    end

    window.show
    Gtk.main
  end

  def make_vn_box(release, vn, parent)
    builder_file = './gui/gui_vnbox.glade'
    builder = Gtk::Builder.new(file: builder_file)

    # help
    window = builder.get_object('window')
    box = builder.get_object('box')
    window.remove(box)
    parent.add(box)

    linkbutton_releasepage = builder.get_object('linkbutton_releasepage')
    linkbutton_releasepage.uri = "https://vndb.org/r#{release[:id]}"
    linkbutton_releasepage.set_label("https://vndb.org/r#{release[:id]}")

    if vn
      image_vn = builder.get_object('image_vn')

      require 'net/http'
      image = Net::HTTP.get_response(URI(vn['image'])).body

      require 'tmpdir'
      temp_image_path = File.join(Dir.tmpdir, 'vnsortertempimage')

      File.open(temp_image_path, 'wb') do |file|
        file.write(image)
      end
      # vndb max image size: 256x400px
      pixbuf = GdkPixbuf::Pixbuf.new(file: temp_image_path, width: 256, height: 400)
      image_vn.set_from_pixbuf(pixbuf)
    end

    text = make_release_text(release)
    buffer_vninfo = builder.get_object('buffer_vninfo')
    buffer_vninfo.set_text(text)
  end

  def make_release_text(release)
    str = ''

    # str += "https://vndb.org/r#{release[:id]}\n"
    str += "ID: #{release[:id]}\n"
    str += "Date: #{release[:date]}\n"
    str += "Producer: #{release[:producer]}\n"
    str += "Title: #{release[:title]}\n"
    str += "Original:  #{release[:original]}\n"
    str += "Languages:  #{release[:languages]}\n"
    str += "VN:  #{release[:vn]}\n"

    str
  end

  def get_objects(builder)
    @label_folderinfo = builder.get_object('label_folderinfo')
    @button_manual = builder.get_object('button_manual')
    @button_next = builder.get_object('button_next')
    @button_select = builder.get_object('button_select')
    @button_stop = builder.get_object('button_stop')
    @button_skip = builder.get_object('button_skip')
  end
end
