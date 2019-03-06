class Player
  attr_accessor :symbol, :name

  def initialize(symbol, name)
    @symbol = symbol
    @name = name
    introduction
  end

  def introduction
    puts "Hello and welcome to Tic Tac Toe for Ruby #{name.capitalize}!"
  end
end