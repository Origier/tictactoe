require_relative "board"
require_relative "player"
require_relative "piece"
$players = []
$counter = 0



def addPiece(player, x, y)
  @board[y][x] = Piece.new(player.symbol, x, y)
  checkForNeighbors(x, y)
end

def checkForNeighbors(x, y)
  checkForEast(x, y)
  checkForNorth(x, y)
  checkForSouth(x, y)
  checkForWest(x, y)
  checkForNorthEast(x, y)
  checkForNorthWest(x, y)
  checkForSouthEast(x, y)
  checkForSouthWest(x, y)
end

def stepTowards(direction)
  case direction
  when :north
    return {x: 0, y: -1}
  when :south
    return {x: 0, y: 1}
  when :east
    return {x: 1, y: 0}
  when :west
    return {x: -1, y: 0}
  when :northeast
    return {x: 1, y: -1}
  when :northwest
    return {x: -1, y: -1}
  when :southeast
    return {x: 1, y: 1}
  when :southwest
    return {x: -1, y: 1}
  end
end

def threeInARow(x, y)
  puts "running inside threeInARow"
  if @board[y][x].neighbors.length == 0
    return false
  else
    @board[y][x].neighbors.each do |direction, symbol|
      puts symbol
      puts direction
      if symbol == @board[y][x].reference
        step = stepTowards(direction)
        puts direction
        puts step
        if  @board[y + step[:y]][x + step[:x]].neighbors[direction] == @board[y][x].reference
          return true
        else
          return false
        end
      else
        return false
      end
    end
  end
end

def checkWinCondition
  if @board[0][0] == nil and @board[2][0] == nil and @board[0][2] == nil and @board[2][2] == nil and @board[0][1] == nil and @board[1][0] == nil
    return false
  else
    if @board[0][0] != nil and threeInARow(0, 0)
      return true
    elsif @board[0][2] != nil and threeInARow(2, 0)
      return true
    elsif @board[2][0] != nil and threeInARow(0, 2)
      return true
    elsif @board[2][2] != nil and threeInARow(2, 2)
      return true
    elsif @board[0][1] != nil and threeInARow(1, 0)
      return true
    elsif @board[1][0] != nil and threeInARow(0, 1)
      return true
    else
      return false
    end
  end
end

def checkForDirection(board, x, y, delta_x, delta_y, direction)
  board[y][x].addNeighbor(board[y + delta_y][x + delta_x], direction) if board[y + delta_y][x + delta_x] != nil
end

def checkForWest(x, y)
  @board[y][x].addNeighbor(@board[y][x - 1], :west) if @board[y][x - 1] != nil
end

def checkForEast(x, y)
  @board[y][x].addNeighbor(@board[y][x + 1], :east) if @board[y][x + 1] != nil
end

def checkForNorth(x, y)
  @board[y][x].addNeighbor(@board[y - 1][x], :north) if @board[y - 1][x] != nil
end

def checkForSouth(x, y)
  @board[y][x].addNeighbor(@board[y + 1][x], :south) if @board[y + 1][x] != nil
end

def checkForNorthWest(x, y)
  @board[y][x].addNeighbor(@board[y - 1][x - 1], :northwest) if @board[y - 1][x - 1] != nil
end

def checkForSouthWest(x, y)
  @board[y][x].addNeighbor(@board[y + 1][x - 1], :southwest) if @board[y + 1][x - 1] != nil
end

def checkForNorthEast(x, y)
  @board[y][x].addNeighbor(@board[y - 1][x + 1], :northeast) if @board[y - 1][x + 1] != nil
end

def checkForSouthEast(x, y)
  @board[y][x].addNeighbor(@board[y + 1][x + 1], :southeast) if @board[y + 1][x + 1] != nil
end






def createCharacters
  2.times do |i|
    system "clear" or system "cls"
    puts "Alright Player #{i + 1} please enter your name: "
    name = gets.chomp
    if i == 1
      while name.downcase == $players[0].name.downcase
        puts "Sorry you can't use the same name as player 1, please try again."
        name = gets.chomp
      end
    end
    puts "Alright #{name}, type a single character that you wish to represent your game piece: "
    char = gets.chomp
    if i == 1
      while char == $players[0].symbol or char.length > 1
        puts "Sorry you may only use one character and it can't be the same as player 1."
        char = gets.chomp
      end
    else
      while char.length > 1 or char.length < 1
        puts "Sorry please only enter a single character and then we can continue: "
        char = gets.chomp
      end
    end
    $players << Player.new(char, name)
    sleep(2)
  end
end

def playGame
  board = Board.new
  board.drawBoard
  puts "Welcome to Tic-Tac-Toe Ruby edition, once you find yourself a second player type \"start\" and hit enter to get started."
  input = ""
  while input != "start"
    input = gets.chomp.downcase
  end
  createCharacters
  board.drawBoard
  puts "Alright let's begin, #{$players[0].name.capitalize} will start the game, simply type in the x and y coordinate that you wish to place a piece at, separate the coordinates by a comma please: "
  coors = gets.chomp.gsub(/\s+/, "").split(",")
  until board.checkBounds(coors[0].to_i, coors[1].to_i)
    coors = gets.chomp.gsub(/\s+/, "").split(",")
  end
  board.addPiece($players[0], coors[0].to_i, coors[1].to_i)
  until board.checkWinCondition
    system "clear" or system "cls"
    board.drawBoard
    $counter = $counter == 0 ? 1 : 0
    puts "It is now #{$players[$counter].name.capitalize}'s turn, type your coordinates to continue: "
    coors = gets.chomp.gsub(/\s+/, "").split(",")
    until board.checkBounds(coors[0].to_i, coors[1].to_i)
      coors = gets.chomp.gsub(/\s+/, "").split(",")
    end
    board.addPiece($players[$counter], coors[0].to_i, coors[1].to_i)
    if board.checkWinCondition
      board.drawBoard
      puts "#{$players[$counter].name.capitalize} has won! Congratulations!."
    end
  end
end

# playGame

def test
  board_test = Board.new(5)
  
end

test