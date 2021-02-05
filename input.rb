module Input
  def self.get_input
    gets.chomp.strip.downcase
  end

  def self.valid_input?(input)
    /[0-9]{1,99}/.match(input) || /skip/.match(input)
  end
end
