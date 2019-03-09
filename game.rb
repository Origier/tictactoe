require_relative "board"
require_relative "player"
require_relative "piece"
$counter = 0


#Checking the board for other nearby pieces

def checkForNeighbors(x, y)
  checkForDirection(x, y, 1, 0, :east) unless x == 2
  checkForDirection(x, y, 0, -1, :north) unless y == 0
  checkForDirection(x, y, 0, 1, :south) unless y == 2
  checkForDirection(x, y, -1, 0, :west) unless x == 0
  checkForDirection(x, y, 1, -1, :northeast) unless y == 0 or x == 2
  checkForDirection(x, y, -1, -1, :northwest) unless y == 0 or x == 0
  checkForDirection(x, y, 1, 1, :southeast) unless y == 2 or x == 2
  checkForDirection(x, y, -1, 1, :southwest) unless y == 2 or x == 0
end

def checkForDirection(x, y, delta_x, delta_y, direction)
  $board.board[y][x].addNeighbor($board.board[y + delta_y][x + delta_x], direction) if $board.board[y + delta_y][x + delta_x] != nil
end



#Checking for win Conditions

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
  if $board.board[y][x].neighbors.length == 0
    return false
  else
    $board.board[y][x].neighbors.each do |direction, symbol|
      if symbol == $board.board[y][x].reference
        step = stepTowards(direction)
        if $board.board[y + step[:y]][x + step[:x]].neighbors[direction] == $board.board[y][x].reference
          return true
        end
      else
        return false
      end
    end
    return false
  end
end

def checkWinCondition
  if $board.board[0][0] == nil and $board.board[2][0] == nil and $board.board[0][2] == nil and $board.board[2][2] == nil and $board.board[0][1] == nil and $board.board[1][0] == nil
    return false
  else
    if $board.board[0][0] != nil and threeInARow(0, 0)
      return true
    elsif $board.board[0][2] != nil and threeInARow(2, 0)
      return true
    elsif $board.board[2][0] != nil and threeInARow(0, 2)
      return true
    elsif $board.board[2][2] != nil and threeInARow(2, 2)
      return true
    elsif $board.board[0][1] != nil and threeInARow(1, 0)
      return true
    elsif $board.board[1][0] != nil and threeInARow(0, 1)
      return true
    else
      return false
    end
  end
end



#Main Functionality of the game including the creating of characters and playing the actual game

def createCharacters
  $players = []
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

def playAgain?
  sleep(1)
  puts "Would you like to play again?"
  input = gets.chomp.downcase
  if input == "yes"
    playGame($players)
  else
    exit
  end
end

def playGame(players = nil)
  system "clear" or system "cls"
  $board = Board.new(3)
  $players = players
  $board.drawBoard
  turns = 0
  puts "Welcome to Tic-Tac-Toe Ruby edition, once you find yourself a second player type \"start\" and hit enter to get started."
  input = ""
  while input != "start"
    input = gets.chomp.downcase
  end
  createCharacters unless $players != nil
  system "clear" or system "cls"
  $board.drawBoard
  puts "Alright let's begin, #{$players[$counter].name.capitalize} will start the game, simply type in the x and y coordinate that you wish to place a piece at, separate the coordinates by a comma please: "
  coors = gets.chomp.gsub(/\s+/, "").split(",")
  until $board.checkBounds(coors[0].to_i, coors[1].to_i)
    coors = gets.chomp.gsub(/\s+/, "").split(",")
  end
  $board.addPiece($players[0], coors[0].to_i, coors[1].to_i)
  until checkWinCondition
    system "clear" or system "cls"
    $board.drawBoard
    $counter = $counter == 0 ? 1 : 0
    puts "It is now #{$players[$counter].name.capitalize}'s turn, type your coordinates to continue: "
    coors = gets.chomp.gsub(/\s+/, "").split(",")
    until $board.checkBounds(coors[0].to_i, coors[1].to_i)
      coors = gets.chomp.gsub(/\s+/, "").split(",")
    end
    $board.addPiece($players[$counter], coors[0].to_i, coors[1].to_i)
    checkForNeighbors(coors[0].to_i, coors[1].to_i)
    if checkWinCondition
      system "clear" or system "cls"
      $board.drawBoard
      puts "#{$players[$counter].name.capitalize} has won! Congratulations!."
      playAgain?
    elsif turns == 7
      system "clear" or system "cls"
      $board.drawBoard
      puts "Looks like neither of you have one, better luck next time..."
      playAgain?
    else
      turns += 1
    end
  end
end

playGame