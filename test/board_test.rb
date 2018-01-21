require 'test/unit'
require_relative '../lib/board.rb'
require_relative '../lib/player.rb'
require_relative '../lib/computer_player.rb'
require_relative '../lib/human_player.rb'

class GameTest < Test::Unit::TestCase
  def test_possible_move
    player1 = HumanPlayer.new('X')
    player2 = ComputerPlayer.new('O')
    init_board = [
      [player1.symbol, player2.symbol, player1.symbol],
      [player1.symbol, player2.symbol, player1.symbol],
      [player1.symbol, player2.symbol, player1.symbol]
    ]
    board = Board.new(player1, player2, init_board)
    assert_equal(false, board.possible_move?(1, 1))
  end

  def test_default_move
    player1 = ComputerPlayer.new('X')
    player2 = ComputerPlayer.new('O')
    init_board = [
      [player1.symbol, '-', player1.symbol],
      [player1.symbol, player2.symbol, player1.symbol],
      [player1.symbol, player2.symbol, player1.symbol]
    ]
    board = Board.new(player1, player2, init_board)
    assert_equal(false, board.move)
    assert_equal(player1.symbol, board.board_array[0][1])
  end
end
