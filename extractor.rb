module Extractor
  extend self
  def extract(directory = Dir)
    found_vns = []
    fields = []

    directory.entries('.').each do |folder|
      date = []
      company = []
      title = []

      fields = folder.split(' ')
      fields.each do |field|
        puts "field is #{field}"
        if /\[[0-9]{6}\]/.match(field)
          date << field.gsub(/\[|\]/, '')
          next
        end
        if /\[.+\]/.match(field)
          company << field.gsub(/\[|\]/, '')
          next
        end
        title << field if /.+/.match(field)
      end
      # puts "date is #{date}"
      # puts "company is #{company}"
      # puts "title is #{title}"
      found_vns << { location: "#{__dir__}/#{folder}", date: date, company: company, title: title }
    end
    found_vns
  end
end
