class Piece
  attr_accessor :symbol, :reference, :location, :neighbors

  def initialize(symbol, x, y)
    @symbol = symbol
    @reference = symbol.to_sym
    @location = {x: 0, y: 0}
    @location[:x] = x
    @location[:y] = y
    @neighbors = {}
    @directions = [:north, :south, :east, :west, :northwest, :southeast, :northeast, :southwest]
  end

  def addNeighbor(piece, direction)
    index = @directions.index(direction)
    opposite_direction = index % 2 == 0 ? @directions[index + 1] : @directions[index - 1]
    @neighbors[direction] = piece.reference
    piece.neighbors[opposite_direction] = @reference
  end
end