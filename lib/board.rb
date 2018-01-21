require_relative "../lib/player.rb"
class Board
  attr_reader :board_array
  attr_reader :winner
  def initialize(player1, player2, init_board = nil, size = 3)
    @player1 = player1
    @player2 = player2
    @last_player = nil
    @winner = nil
    @board_array = if init_board
                     init_board
                   else
                     Array.new(size) { Array.new(size) { '-' } }
                   end
  end

  def move
    print_board
    player = choose_player
    row, col = player.move(@board_array)
    @board_array[row][col] = player.symbol
    next_move?
  end

  def choose_player
    @last_player = if @last_player == @player1
                     @player2
                   else
                     @player1
                   end
    @last_player
  end

  def next_move?
    @board_array.each do |row|
      return true if row.include?('-') && !winner?
    end
    false
  end

  def possible_move?(row, col)
    @board_array[row][col] == '-'
  end

  def compare_with_size(count)
    true if count == @board_array.length
  end

  def count_element_in_row(row)
    count = 0
    @board_array[row].each do |el|
      if el == @board_array[row].first && @board_array[row].first != '-'
        count = count+1
      end
    end
    compare_with_size(count)
  end

  def count_element_in_col(array)
    count = 0
    for i in 0..array.length-1
      if array[i] == array.first && array.first != '-'
        count = count+1
      end
    end
    compare_with_size(count)
  end

  def winner_by_rows
    count = 0
    @board_array.length.times do |row|
      if count_element_in_row(row)
        count = count + 1
        break
      end
    end
    true if count > 0
  end

  def winner_by_cols
    count=0
    for i in 0..@board_array.length-1
      array=@board_array.map{|col| col[i]}
      if count_element_in_col(array)
        count = count+1
        break
      end
    end
    true if count > 0
  end

  def winner_by_diagonal
    array=Array.new
    for i in 0..@board_array.length-1
      array.push(@board_array[i][i])
    end
    count_element_in_col(array)
  end

  def winner_by_reversed_diagonal
    array = Array.new
    i = @board_array.length - 1
    loop do
      array.push(@board_array[i][(@board_array.length - 1) - i])
      i = i - 1
      break if i < 0
    end
    count_element_in_col(array)
  end

  def winner?
    if winner_by_rows || winner_by_cols || winner_by_diagonal || winner_by_reversed_diagonal
      @winner = @last_player
      true
    else
      false
    end
  end

  def print_board
    print_header
    @board_array.each do |row|
      print_row(row)
    end
    print_header
  end

  def print_row(row)
    print '||'
    row.each do |col|
      print ' ' + col + ' ||'
    end
    puts ''
  end

  def print_header
    print '||'
    @board_array.length.times do
      print '===||'
    end
    puts ''
  end
  private :print_header
end
