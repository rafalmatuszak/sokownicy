require_relative "./board.rb"

class Player
  attr_reader :symbol

  def initialize(symbol)
    @symbol = symbol
  end

  def move(board)
    raise NotImplementedError
  end
end
