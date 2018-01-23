# Refaktoryzacja gry Kółko i Krzyżyk
```bash
Player 1: Podaj swój symbol 
X
Player 2: Podaj swój symbol
O
Wybierz rodzaj gry:
1) 1 vs computer
2) 1 vs 1
1
Wpisz rozmiar planszy do gry
3
||===||===||===||
|| - || - || - ||
|| - || - || - ||
|| - || - || - ||
||===||===||===||
Podaj wiersz: 
```
## Autorzy

 Matuszak Rafał, 
 Piecuch Mikołaj, 
 Tracki Mateusz
## Opis projektu
 Celem projektu było zrefaktoryzowanie oraz otworzenie na przyszłe zmiany kodu, umieszczonego na [githubie](https://github.com/kevinrutherford/rrwb-code/tree/master/tic_tac_toe). 
## Proponowana zmiana
 Zaproponowaną przez autorów zmianą będzie możliwość przeprowadzenia dwóch trybów gry 
 1. czlowiek vs komputer
 2. czlowiek vs czlowiek


## Refactoring
### Wstępne "zapachy"

Istniejący kod zawierał kilka "zapachów", które należało usunąć przed rozpoczęciem refaktoryzacji:
 
 1. Attribute smell - klasa `Game` zawierała pole `attr_accessor :board`, które umożliwiało jego edycję. Aby to naprawić, należało zmienić typ pola na `attr_reader`, by pole było tylko do odczytu.  
 2. Nill Check - w klasie `Game` znajdowało się porównanie obiektu do obiektu typu `nil`, które naruszało zasadę "Tell, don't ask".  

Po usunięciu "zapachów", autorzy przeszli do etapu właściwej refaktoryzacji.

### Wersja 1
[Change player definition](https://github.com/OpenClosed/solid-sokownicy/commit/e18753a9b72029ba1f243e4289c91e4785be7875)

Rozgrywka przewidywała reprezentowanie gracza za pomocą obiektu typu string (symbol gracza). Aby umożliwić zaproponowaną zmianę, potrzebna była zmiana definicji na obiekt typu `symbol`. Od tej pory gracz jest obiektem klasy `Player`.

```ruby
class Player
  attr_reader :symbol

  def initialize(symbol)
    @symbol = symbol
  end
end
```

W związku z powyższymi zmianami, nie jest możliwe stwierdzenie, czy kod otwarty jest na zaproponowaną zmianę.   

### Wersja 2
[Add gameboard class and move game mechanism to separate file](https://github.com/OpenClosed/solid-sokownicy/commit/93d3e9e99a5d8d61fc8772c8930083a0bfff90e1)

Zmiane została poddana definicja planszy do gry. Utworzona została klasa `Board`, która zawiera logikę gry. Zastępuje to dotychczasową reprezentację planszy (string z umiejscowieniem symboli graczy).

```ruby
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
end
```

Powyższe korekty nie otwierają kodu na żądaną zmianę i nie jest wiadome, jak go na nią otworzyć. Należy dokonać dalszych poprawek.

### Wersja 3
[Add human and computer classess. Make project playable](https://github.com/OpenClosed/solid-sokownicy/commit/e58d7e387b84c150852adf82f9641892a2a108cd)

W tym kroku zostały utworzone konkretne implementacje graczy (klasy `ComputerPayer` oraz `HumanPlayer`). Dziedziczą one po klasie `Player`, obie zawierają w sobie metodę `move`. Metody te różni jednak to, że w klasie `ComputerPlayer` wybierany jest pierwszy możliwy ruch, natomiast w klasie `HumanPlayer` użytkownik pytany jest o współrzędne na planszy, w które ma zostać wprowadzony symbol. 

```ruby
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
```

```ruby
require_relative "player.rb"

class HumanPlayer < Player
  def move(board_array, row = nil, col = nil)
    return row, col if row && col
    loop do
      row, col = coordinates
      return row, col if board_array[row][col] == '-'
    end
  end
end
```

Ponadto zostały dodane metody wyświetlające planszę do gry w terminalu. Po zastosowaniu tych zmian, możliwe stało się przeprowadzenie rozgrywki.

Ta zmiana również nie umożliwia wprowadzenie zakładanej zmiany i nie jest wiadome, jak na tę zmianę otworzyć istniejący kod.

### Wersja 4
[Fix Feature Envy smell. Add random method for computer move](https://github.com/OpenClosed/solid-sokownicy/commit/28a25e4e862c9bcc96cb39727248a29cb15a6a58)

Zmiany z Wersji 3 i Wersji 4 wprowadziły nowy "zapach" - FeatureEnvy. Zawierał się on w metodzie `move` klasy `HumanPlayer`. Wynikał on ze zbyt częstego odwoływania się metody do obiektów innego typu niż `HumanPlayer`.

Przebudowano metodę `move` wyżej wymienionej klasy. Zmieniono również metodę `move` klasy `ComputerPlayer` - od teraz gracz komputerowy losowo wstawia znaki na planszy.

Również ta zmiana nie umożliwia wprowadzenia przewidywanej zmiany. Należało nadal zmieniać kod.

### Wersja 5
[Add winner conditions](https://github.com/OpenClosed/solid-sokownicy/commit/6e0619a20aba6b6af56abd20e8c19033641bd7a1)
Zostały wprowadzone 4 warunki zwycięstwa:

- sprawdzanie wierszy
- sprawdzanie kolumn
- sprawdzanie dwóch różnych przekątnych
 
Do stwierdzenia wygranej wystarczy spełnienie jednego z powyższych warunków. Sprawdzenie polega na zliczeniu ilości występowania symboli w wierszu/kolumnie/przekątnej. Jeśli uzyskana liczba równa jest wymiarowi planszy, stwierdzana jest wygrana.

```ruby
def winner?
    if winner_by_rows || winner_by_cols || winner_by_diagonal || winner_by_reversed_diagonal
      @winner = @last_player
      true
    else
      false
    end
  end
```

Poprawki te otworzyły ostatecznie kod na wprowadzenie zamierzonej zmiany - wyboru trybu gry. 

### Wersja 6 - ostateczna
[Change passing start parameters method](https://github.com/OpenClosed/solid-sokownicy/commit/112ba129728676d6e14e545a589adf09ec929ec4)
[Add message with winner](https://github.com/OpenClosed/solid-sokownicy/commit/72d9958bf32a96ed651a863aba52b07e117d312d)
[Add selecting game mod](https://github.com/OpenClosed/solid-sokownicy/commit/e5b76e90eb81a6d4242732d576757a80b25e1277)

Dodano metodę `start` w klasie `Game`, która odpowiada za pobranie parametrów niezbędnych do rozpoczęcia gry oraz jej uruchomienie. 
Za pobranie parametrów odpowiadają trzy metody (`choose_symbol, choose_mode, choose_board_size `). Sprawdzają one również poprawność wprowadzonych argumentów.

```ruby
def choose_mode
  print "Wybierz rodzaj gry:\n1) 1 vs computer\n2) 1 vs 1\n"
  loop do
    mode = gets.chomp
    return mode.to_i if mode == '1' || mode == '2'
    puts 'Zły wybór'
  end
end
```

Ponadto, udoskonalono pętlę główną gry w klasie `Game`(metoda `play`), aby wyświetlała zwycięzcę.

Wśród parametrów startowych gry znajduje się parametr trybu gry, czyli zakładanej na początku projektu zmiany.



