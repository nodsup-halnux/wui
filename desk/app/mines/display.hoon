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
=/  utfsymbol  [dot="·" flag="⚑" mine="☠"]
::  The playing field %win %lose %live determines
::  the board colors.
=/  boardcolors  (board-colors playing.mstate)
::
::  In the Sail guide, data formatting is just called
::  inside the sail elements, using ;+ and ;*.  Here,
::  data computation is separated for simplicity.
::
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
  ;body(style (board-colors playing.mstate))
    ;h1: %mines - Minesweeper Board:
    ;p: Use console pokes to set moves.  Refresh the page to see the results.  
    ;p: Counting for board positions starts from zero.  See the /sur files for details on moves. 
    ::  ~? seemed to be causing a nasty mull-grow error
    ::  switching to ?: seemed to help.
    ::  if you bake your map, you can get lost ~
    ;+  ?.  ?&((lte x.dims.mstate 20) (lte y.dims.mstate 20))
          ::F
          ;div.start:  Board height and width cannot exceed 20. Please resize board.
          ::T: Display our board then!
          ;div.contain(style (board-width y.dims.mstate))
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
                        ::T  get the map value.
                        =/  val  (~(get by tiles.mstate) rc)
                          ::and set xtra-class if mine or flag.
                          =/  xtra-class
                            ?+  (need val)  ""
                            %flag  "flag"
                            %mine  "mine"
                          ==
                          :: We have a tile entry, so its a %flag or %num
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
                        ;div(class "square {xtra-class}", id "{<x.rc>}-{<y.rc>}"): {symbol}
                        ::F Case - not tested.
                        ;div(class "square", id "{<x.rc>}-{<y.rc>}"): {dot.utfsymbol}
                == ::div board
          ==  ::div contain
  ==  ::body
== ::html
::
::This calculates the needed board width, and converts it to a tape.
:: because we are dealing with an @ud from (mul a b), we need to deal
:: with numbers that exceed 999px.
++  board-width  
  |=  n=@ud
    ^-  tape
    =/  wid  (mul 75 n)
      ?:  (lth wid 999)
        "width:{<wid>}px;"
        =/  convert  (oust [1 1] <wid>)  "width:{convert}px;"
        
++  board-colors
  |=  stat=status
    ^-  main=tape 
    ?-  stat
      %live  "background-color:#333333;color:#c6a615;"
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
      text-align: center;
      font-size:24pt;
    }
    h1 {
      font-size: 36pt;
    }
    div  {  
      font-size: 16pt;
    }
    .start {
      width: 50%;
      height: 20%;
      background-color:#066508;
      color:#c6a615;
      text-align: center;
      line-height: 20vh; 
      font-size: 24pt;
      margin: 0 auto; 
      display: block;
    }
    .contain {
       border-style:double;
       border-width:5px;
       border-color:#03440E;
       margin-top:10%;
       width: 75px;
       margin: 0 auto; 
    }
    .boardrow {
      display: flex;
    }
    .square {
        flex: 1;
        padding: 2px;
        background-color:#066508;
        border: 1px solid #03440E;
        font-size: 40pt;
        align-items: center;
        justify-content: center;
        font-weight: bold;
    }
    .flag {
      color: #0D6CE5;
    }
    .mine {
      padding-top:3px;
      font-size: 36pt;
      color: #E5480D;
    }

'''
--
