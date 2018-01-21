require_relative "player.rb"

class ComputerPlayer < Player
  def move(board_array)
    loop do
      row = rand(0..board_array.length - 1)
      col = rand(0..board_array.length - 1)
      return row, col if board_array[row][col] == '-'
    end
  end
end
