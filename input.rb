module Input
  extend self

  def get_input
    gets.chomp.strip.downcase
  end

  def valid_input?(input)
    /\w/.match(input)
  end
end
