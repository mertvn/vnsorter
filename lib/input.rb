module Input
  extend self
  def get_input
    $stdin.gets.chomp.strip.downcase
  end

  def valid_input?(input)
    /[0-9]{1,99}/.match(input) || /(next)|(skip)|(stop)/.match(input)
  end
end
