require_relative 'player.rb'
require_relative 'human_player'
require_relative 'computer_player'

class Game
  attr_reader :board

  def start
    symbol1, symbol2 = choose_symbol
    player2 = if choose_mode == 1
                ComputerPlayer.new(symbol2)
              else
                HumanPlayer.new(symbol2)
              end
    @board = Board.new(HumanPlayer.new(symbol1), player2, nil, choose_board_size)
    play
  end

  def choose_symbol
    loop do
      puts 'Player 1: Podaj swój symbol '
      symbol1 = gets.chomp
      puts 'Player 2: Podaj swój symbol'
      symbol2 = gets.chomp
      return symbol1, symbol2 if symbol1 != symbol2
      puts 'Symbole nie mogą być takie same'
    end
  end

  def choose_mode
    print "Wybierz rodzaj gry:\n1) 1 vs computer\n2) 1 vs 1\n"
    loop do
      mode = gets.chomp
      return mode.to_i if mode == '1' || mode == '2'
      puts 'Zły wybór'
    end
  end

  def choose_board_size
    puts 'Wpisz rozmiar planszy do gry'
    loop do
      size = gets.chomp
      return size.to_i if size.to_i >= 3 && size.to_i <= 10
      puts 'Zły wybór. Plansza może mieć rozmiar od 3x3 do 10x10'
    end
  end

  def play
    while board.move
    end
    if board.winner
      print "Wygrał gracz o symbolu " + board.winner.symbol
    else
      print "Remis!"
    end
  end
end
