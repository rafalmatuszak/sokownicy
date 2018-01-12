require './board'
class Game
  def initialize_game()
    puts 'Wprowadź rozmiar planszy (przykladowo 3 oznacza 3 wiersze i 3 kolumny)'
    size=gets.chomp
    board=Board.new(size)
    board.show_size()
  end
end
gra=Game.new
gra.initialize_game