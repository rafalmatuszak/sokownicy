require 'test/unit'
require_relative '../lib/board.rb'
require_relative '../lib/computer_player'
require_relative '../lib/human_player'

class PlayerTest < Test::Unit::TestCase
  def test_possible_player_move
    player1 = HumanPlayer.new('X')
    player2 = ComputerPlayer.new('O')
    init_board = [
      [player1.symbol, player2.symbol, player1.symbol],
      [player1.symbol, '-', player1.symbol],
      [player1.symbol, player2.symbol, '-']
    ]
    board = Board.new(player1, player2, init_board)
    row, col = player1.move(board.board_array, 1, 1)
    assert_equal(1, row)
    assert_equal(1, col)
  end
end
