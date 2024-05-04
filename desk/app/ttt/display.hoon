::  Import strucutre file.
/-  *ttt
:: Our Sail page is a gate that renders HTML that we
::  serve to our localhost website.
::   Bowl and gamestate supplied to gate. Bowl isn't
::  currently used, but kept for generality.
|=  [bol=bowl:gall gstate=appstate]
  |^  ^-  octs
::  The nested gate calls below produce a format chain
::  that take us from xml manx structures, to outputted
::  html.
        %-  as-octs:mimes:html
      %-  crip
    %-  en-xml:html
  ^-  manx

::  In the Sail guide, data formatting is just called
::  inside the sail elements, using ;+ and ;*.  Here,
::  data computation is separated for simplicity.
=/  clist=(list (list coord))  
    (make-keys rows.bsize.gstate cols.bsize.gstate)
=/  play-classes  
    (assign-classes status.gstate currplayer.gstate)

::  Notes about Sail:  Use a mictar rune for each 
::  new %+ turn and sub-elements generated. Using one 
::  mictar with multiple levels of loop and/or 
::  sub-elements leads to ruin.  When adding id and 
::  css attributes, its tag#css.class in that order!

;html
  ;head
    ;title: tictactoe
    ;meta(charset "utf-8");
    ;style
      ;+  ;/  style
    ==  ::style
  ==  ::head
  ;body
    ;h1: %ttt - Tic-Tac-Toe Board:
    ;h2 
      🖙 Use console pokes to set moves.  
      Refresh the page to see the results.  
      See the structure file for more details. 🖘
    ==  ::h2
      ;div.contain
        ;*  ?~  clist  !!
          %+  turn  clist
            |=  rclist=(list coord)
            ;div.board
              ;*
              ?~  rclist  !!
                %+  turn  rclist
                |=  rc=coord
                  =/  val  (need (~(get by board.gstate) rc))
                  =/  symbol  ?-  val
                          %o  "⭘"
                          %e  "_"
                          %x  "⨯"
                        ==
                    ;div(class "square", id "{<r.rc>}-{<c.rc>}"): {symbol} 
            == ::div board
    ==  ::div contain
    ;br;
    ;br;
    ;div.ffcontain  
        ;div(id "p1", class p1.play-classes):  Player 1 - ⨯
        ;div(id "p2", class p2.play-classes):  Player 2 - ⭘
    ==  ::div ffcontain
  == ::body
== ::html
::
::  Gate that takes in our status and player states,
::  and produces the correct classes for our player
::  status bar.
++  assign-classes
  |=  [status=statussymbol player=playersymbol]
    ^-  [p1=tape p2=tape]
    ::  First check if the game is currently won, lost of drawn.
    ?-  status
        %p1win  [p1="player master" p2="player slave"]
        %p2win  [p1="player slave" p2="player master"]
        %draw  [p1="player limbo" p2="player limbo"]  
        %cont 
          ?:  =(player %p1x)
            [p1="player active" p2="player waiting"]
            [p1="player waiting" p2="player active"]
    ==
::  This gate generates keys for our board map.
++  make-keys 
  |=  [rmax=@ud cmax=@ud]
    ^-  (list (list coord))
    =/  row  0
    =/   llcord  `(list (list coord))`~
    |-
      ^-  (list (list coord))
      ?:  (lth row rmax)
        %=  $
          llcord  (snoc llcord (get-row row cmax))
          row  +(row)
        ==
        llcord
::  Inner support loop for make-keys. Gets a row of
::  keys.
++  get-row
  |=  [row=@ud cmax=@ud]
    ^-  (list coord)
      =/  col  0
      =/  result  `(list coord)`~
      |- 
      ^-  (list coord)
       ?:  (lth col cmax)
         %=  $
            result  (snoc result [row col])
            col  +(col)
          ==
          result
::  The css for the page is just one big tape.
++  style
  ^~
  %-  trip
    '''
    body {background-color:black; color: orange;}
    h1 {font-size: 36pt; text-align: center;}
    h2 {font-size: 24pt; text-align: center;}
    div {font-size: 16pt;}

    .contain {
      position:relative;
      left:20%;
    }

    .ffcontain {
      width: 80%;
      margin: 0 auto; 
      display: flex;
    }

    .player {
      flex: 1; 
      text-align: center;
      font-size: 24pt;
      padding: 10px;
      border: 1px solid #000; 
    }

    .active {
      background-color: orange;
      color: black;
    }

    .waiting {
      background-color: black;
      color: orange;
    }

    .master  {
      background-color: green;
      color: white;
    }

    .slave {
      background-color: red;
      color: white;
    }

    .limbo {
      background-color: gray;
      color: white;
    }

    .board {
      margin-top: 5px;
      display: grid;
      grid-template-columns: repeat(3, 500px);
      column-gap: 5px;

    }

    .square {
      width: 500px;
      height: 250px;
      background-color: orange;
      color: blue;
      font-size: 72px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: bold;
    }
    '''
--
