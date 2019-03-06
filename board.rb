require_relative "piece"

class Board
  attr_accessor :board, :size
  def initialize(size)
    @size = size
    @board = Array.new(size, Array.new(size, nil))
  end

  def drawBoard
    l = 0
    puts "\n\n"
    print "             "
    @size.times do |i|
      print i.to_s + "    "
    end
    print "\n"
    @board.each do |i|
      print "          "
      print l
      i.each do |j|
        if j == nil
          print "|   |"
        else
          print "| #{j.symbol} |"
        end
      end
      print "\n\n"
      l += 1
    end
  end

  def checkBounds(x, y)
    if (x > size - 1 or x < 0) or (y > size - 1 or y < 0)
      puts "Sorry that is out of bounds, please try again."
      return false
    elsif @board[y][x] != nil
      puts "Sorry there is already a piece there, please try again."
      return false
    else
      return true
    end
  end
end