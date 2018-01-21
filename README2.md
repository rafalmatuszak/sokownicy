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
 Celem projektu było zrefaktoryzowanie oraz otworzenie na przyszłe zmiany kodu, umieszczonego na [githubie](https://l.facebook.com/l.php?u=https://github.com/kevinrutherford/rrwb-code/tree/master/tic_tac_toe&h=ATNJ-oGKdyVbs6xuY9iIpiGREpRUfqjiAvHlxe5O-Nzb6XhcLiV1VtXiBapAl49-ucpAbi6EnMZn5KpesLWsCjMDhnNFqJ_Ua10qEKEH-Ka9Pdt8tWBxk_HG8Om169s_b7w4Evt8bjxRy3CxNJuAAjae6J2Mag). 
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

W związku z powyższymi zmianami, nie jest możliwe stwierdzenie, czy kod otwarty jest na zaproponowaną zmianę.   

### Wersja 2
[Add gameboard class and move game mechanism to separate file](https://github.com/OpenClosed/solid-sokownicy/commit/93d3e9e99a5d8d61fc8772c8930083a0bfff90e1)

Zmiane została poddana definicja planszy do gry. Utworzona została klasa `Board`, która zawiera logikę gry. Zastępuje to dotychczasową reprezentację planszy (string z umiejscowieniem symboli graczy).

Powyższe korekty nie otwierają kodu na żądaną zmianę i nie jest wiadome, jak go na nią otworzyć. Należy dokonać dalszych poprawek.

### Wersja 3
[Add human and computer classess. Make project playable](https://github.com/OpenClosed/solid-sokownicy/commit/e58d7e387b84c150852adf82f9641892a2a108cd)

W tym kroku zostały utworzone konkretne implementacje graczy (klasy `ComputerPayer` oraz `HumanPlayer`). Dziedziczą one po klasie `Player`, obie zawierają w sobie metodę `move`. Metody te różni jednak to, że w klasie `ComputerPlayer` wybierany jest pierwszy możliwy ruch, natomiast w klasie `HumanPlayer` użytkownik pytany jest o współrzędne na planszy, w które ma zostać wprowadzony symbol. 

[comment]: #(Ponadto zostały dodane metody wyświetlające planszę do gry w terminalu. Po zastosowaniu tych zmian, możliwe stało się przeprowadzenie rozgrywki.)

Ta zmiana również nie umożliwia wprowadzenie zakładanej zmiany i nie jest wiadome, jak na tę zmianę otworzyć istniejący kod.

### Feature Envy smell oraz dodanie losowego ruchu komputera. 
[Fix Feature Envy smell. Add random method for computer move](https://github.com/OpenClosed/solid-sokownicy/commit/28a25e4e862c9bcc96cb39727248a29cb15a6a58)
Po dodaniu powyższych zmian, otrzymaliśmy Feature Envy Smell. "Zapach" ten powstaje, kiedy fragment kodu odwołuje się do innego obiektu, częściej niż do samego siebie. 

Aby pozbyć się tego "zapachu", przebudowana została metoda `move ` w klasie `HumanPlayer`. 

Dodatkowo zmieniona została logika poruszania się gracza komputerowego. Od teraz porusza się on po losowych polach. 

### Refaktoring podawania startowych parametrów
[Change passing start parameters method](https://github.com/OpenClosed/solid-sokownicy/commit/112ba129728676d6e14e545a589adf09ec929ec4)

Dodano metodę `start` w klasie `Game`, która odpowiada za pobranie parametrów niezbędnych do rozpoczęcia gry oraz jej rozpoczęcie. 

Za pobranie parametrów odpowiadają 3 metody (`choose_symbol, choose_mode, choose_board_size `). Dodatkowo walidują one wprowadzone argumenty.

### Warunki zwycięstwa
  [Add winner conditions](https://github.com/OpenClosed/solid-sokownicy/commit/6e0619a20aba6b6af56abd20e8c19033641bd7a1)

Zostały wprowadzone 4 warunki zwycięstwa:

 - sprawdzanie wierszy
 - sprawdzanie kolumn
 - sprawdzanie 2 różnych przekątnych
 
 Sprawdzenie polega na znalezieniu tylu takich samych symboli w dowolnym warunku, jak duży jest wymiar planszy. Gracz wygrywa, gdy któryś warunek jest spełniony.

### Wyświetlenie zwycięzcy 
[Add message with winner](https://github.com/OpenClosed/solid-sokownicy/commit/72d9958bf32a96ed651a863aba52b07e117d312d)

Ostatnią zmianą było wyświetlenie gracza który wygrał grę lub ogłoszenie remisu.
 

 ### Wybór trybu gry - to powinno być
[Add selecting game mod](https://l.facebook.com/l.php?u=https://github.com/OpenClosed/solid-sokownicy/commit/e5b76e90eb81a6d4242732d576757a80b25e1277&h=ATNJ-oGKdyVbs6xuY9iIpiGREpRUfqjiAvHlxe5O-Nzb6XhcLiV1VtXiBapAl49-ucpAbi6EnMZn5KpesLWsCjMDhnNFqJ_Ua10qEKEH-Ka9Pdt8tWBxk_HG8Om169s_b7w4Evt8bjxRy3CxNJuAAjae6J2Mag)

Dodana została możliwość wyboru trybu gry. Można wybrać rozgrywkę z komputerem lub drugim graczem.