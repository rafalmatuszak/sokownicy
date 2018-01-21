require_relative "player.rb"

class HumanPlayer < Player
  def move(board_array, row = nil, col = nil)
    return row, col if row && col
    loop do
      row, col = coordinates
      return row, col if board_array[row][col] == '-'
    end
  end

  def coordinates
    puts 'Podaj wiersz: '
    row = gets.chomp
    puts 'Podaj kolumnę: '
    col = gets.chomp
    return row.to_i, col.to_i
  end
end
