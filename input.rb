module Input
  extend self

  def get_input
    gets.chomp.strip.downcase
  end

  def valid_input?(input)
    /[0-9]{1,99}/.match(input) || /skip/.match(input)
  end
end
