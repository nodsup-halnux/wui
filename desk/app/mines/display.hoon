::  Import strucutre file.
/-  *mines
:: Our Sail page is a gate that renders HTML that we
::  serve to our localhost website.
::  Bowl and gamestate supplied to gate. Bowl isn't
::  currently used, but kept for generality.
|=  [bol=bowl:gall mstate=[%zero game-state]]
  |^  ^-  octs
::  The nested gate calls below produce a format chain
::  that take us from xml manx structures, to outputted
::  html.
        %-  as-octs:mimes:html
      %-  crip
    %-  en-xml:html
  ^-  manx

:: Generate a list of cells to iterate on.
=/  clist=(list (list coord))  
  (make-keys x.dims.mstate y.dims.mstate)
::  Easier to type names than obscure utf-8 chars.
=/  utfsymbol  [dot="·" flag="⚑" mine="🟒"]
::  The playing field %win %lose %live determines
::  the board colors.
=/  boardcolors  (board-colors playing.mstate)

::  In the Sail guide, data formatting is just called
::  inside the sail elements, using ;+ and ;*.  Here,
::  data computation is separated for simplicity.

::  Notes about Sail:  Use a mictar rune for each 
::  new %+ turn and sub-elements generated. Using one 
::  mictar with multiple levels of loop and/or 
::  sub-elements leads to ruin.  When adding id and 
::  css attributes, its tag#css.class in that order!
::

;html
  ;head
    ;title: Minesweeper
    ;meta(charset "utf-8");
    ;style
      ;+  ;/  style
    ==  ::style
  ==  ::head
  ;body
    ;h1: %mines - Minesweeper Board:
    ;h2
      🖙 Use console pokes to set moves.  
      Refresh the page to see the results.  
      Counting for board positions starts from zero (0).
      See the structure file for more details on moves 🖘
    ==  ::h2
    ::  ~? seemed to be causing a nasty mull-grow error
    ::  switching to ?: seemed to help.
    ::  if you bake your map, you can get lost ~
    ;+  ?:  =(tiles.mstate ~)
        ::  div.start only shows up when game is init'ed.
        ;div.start:  Game Started - make a move to display the board.
        :: Main container. All children inheret colors.
        ;div.contain(style boardcolors)
          :: First turn pulls every row.
          ;*  ?~  clist  !!
            %+  turn  clist
              |=  rclist=(list coord)
              ::  row container - flex-y.
              ;div.boardrow
                ;*
                ?~  rclist  !!
                 :: run +turn on every coord, pull from map
                  %+  turn  rclist
                  |=  rc=coord
                    ?:  (~(has by tiles.mstate) rc)
                      ::T: We have a tile entry, so its a %flag or %num
                      =/  val  (~(get by tiles.mstate) rc)
                      =/  symbol  
                        ?-  (need val)
                            %0  "0"
                            %1  "1"
                            %2  "2"
                            %3  "3"
                            %4  "4"
                            %5  "5"
                            %6  "6"
                            %7  "7"
                            %8  "8"
                          %flag  flag.utfsymbol
                          %mine  mine.utfsymbol
                        ==
                      ;div(class "square", id "{<x.rc>}-{<y.rc>}"): {symbol}
                    ::F Case - not tested or a mine.
                    ;div(class "square", id "{<x.rc>}-{<y.rc>}"): {dot.utfsymbol}
              == ::div board
        ==  ::div contain
  ==  ::body
== ::html
::  Take our playing status, and output a css
::  style tape.
++  board-colors
  |=  stat=status
    ^-  tape
    ?-  stat
      %live  "background-color:orange;color:blue;"
      %win  "background-color:green;color:white;"
      %lose  "background-color:red;color:white;"
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
+$  css-struct  
  $:
    gridprop=tape
    cell-h-w=tape
==
::  Inner support loop for make-keys. Gets a row of  keys.
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
::  Our style sheet is one big tape.
++  style
  ^~
  %-  trip
'''
    body {
      background-color:black;
      color:orange;
      text-align: center;
    }
    h1 {
      font-size: 36pt;
    }
    h2 {
      font-size: 24pt;
    }
    div  {  
      font-size: 16pt;
    }
    .start {
      width: 50%;
      height: 20%;
      background-color: orange;
      color: blue;
      text-align: center;
      line-height: 20vh; 
      font-size: 24pt;
      margin: 0 auto; 
      display: block;
    }
    .contain {
       width: 70%;
       margin: 0 auto; 
    }
    .boardrow {
      display: flex;
    }
    .square {
        flex: 1;
        padding: 2px;
        border: 1px solid black;
        font-size: 48px;
        align-items: center;
        justify-content: center;
        font-weight: bold;
    }
'''
--
