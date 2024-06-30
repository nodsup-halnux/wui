::  Import strucutre file.
/-  *mines
:: Our Sail page is a gate that renders HTML that we
::  serve to our localhost website.
::  Bowl and gamestate supplied to gate. Bowl
::  currently used to fish out our.bowl for http-api JS
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
:: In the event dims is [0 0], clist will be ~
=/  clist=(list (list coord))  
  (make-keys x.dims.mstate y.dims.mstate)
::  Easier to type names than obscure utf-8 chars.
=/  utfsymbol  [dot="·" flag="⚑" mine="☠"]
::  The playing field %win %lose %live determines
::  the board colors.
=/  boardcolors  body-colors
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
    ;script(type "module")
      :: oust removes sig from tape conversion.
      ;+  ;/  (script (oust [0 1] <our.bol>))
    ==
  ==  ::head
  ::  body-colors is just a non-sample gate.
  ;body(style body-colors)
    ;h1: %mines - Minesweeper Board:
    ;p: Use console pokes to set moves.  Refresh the page to see the results.  
    ;p: Counting for board positions starts from zero.
    ;p:  See the /sur files for details on moves. 
    ::  A bunted dims means we just booted with no %start.
    ;+  ?:  ?&(=(dims.mstate [0 0]))
      ::T:  App has just booted.
      ;div.start: Bunted gamestate detected. Please start a game and refresh page.
      ::F:  As long as dims is defined, we can make a board.
        ?.  ?&((lte x.dims.mstate 20) (lte y.dims.mstate 20))
          ::  F:  Board is too big, remind user to properly size.
          ;div.start:  Board height or width ≥ 20. Please resize board, and refresh page.
        :: F: All pre-tests passed. We have dims so load a board.
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
                            ::  Dead men don't see the mines they step on,
                            ::  but we show it for completeness.
                            %mine  mine.utfsymbol
                          ==
                        ;div(class "square {xtra-class}", id "{<x.rc>}-{<y.rc>}"): {symbol}
                        ::F Case - not tested or present. Generate square and fill with dot.
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
::
::  Colors: espresso and yellow-orange.
::
++  body-colors
  ^-  tape  "background-color:#333333;color:#c6a615;"
::  Simple gate mapping game status to colors.
::
++  board-colors
  |=  stat=status
    ^-  main=tape 
    ?-  stat
      %live  "background-color:#333333;color:#c6a615;"
      %win  "background-color:green;color:white;"
      %lose  "background-color:red;color:white;"
    ==
::
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
::
+$  css-struct  
  $:
    gridprop=tape
    cell-h-w=tape
==
::
::  Inner support loop for make-keys. Gets a row of keys.
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
      background-color:#333333;
      color:#c6a615;
      text-align: center;
      font-size:24pt;
    }
    h1 {
      font-size: 36pt;
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
::  JS Comments are ugly, so explanation placed here.
::  We don't have a session.js as we don't use npm build 
::  with urbithttp-api. So there is no window.ship 
::  variable in session.  api.ship must be interpolated, 
::  and pulled from our bowl.
::
::  No authentication needed, as page is inside our app
::  (simple constructor used).
::
::  api.subscribe will request to Eyre.  
::  Will hit app's the ++on-watch arm.
::
::  Non intuitively, x is row, y is col. 
::  Origin is at Top Left corner.
::
::  function check_callback handles our %upstate responses 
::  from BE. Mainly used to update the board.
::  
::  Note that in check_callback, we handle the case where
::  the user makes a new game mid-game.  This is checked
::  by always comparing the board dims with the dims
::  provided by the upstate card.  An error message will
::  result if there is a difference, reminding the user
::  to refresh the page.
::
::  Curly braces are escaped \{ as compiler interprets
::  these in a tape as starting an interpolation site.
::
::  In closing, the unpleasant look of JS
::  slammed in a gate beats dealing with a bloated 
::  node_modules folder, and minified code.

++  script
  |=  our-bowl=tape
  ^-  tape 
  """


    import urbitHttpApi from 'https://cdn.skypack.dev/@urbit/http-api';

    const api = new urbitHttpApi('', '', 'mines');
    api.ship = '{our-bowl}';

    const rows = {<x.dims.mstate>};
    const cols = {<y.dims.mstate>};

    var subID = api.subscribe(\{
      app: 'mines',
      path: '/mines-sub',
      event: check_callback,
      err:  check_error
    })

    function board_scrub(rmax,cmax) \{
      for (let i = 0; i < rmax; i++) \{
        for (let j = 0; j < cmax; j++) \{
          let bcell = document.getElementById(i + '-' + j);
          bcell.innerHTML = '·';
        }
      }
    }

  function board_set(uparr) \{
      for (let i = 0; i < uparr.length; i++) \{
        let item = uparr[i];
        let bcell = document.getElementById(item.x + '-' + item.y);
        let cellsymbol = '?';

        switch (item.sq) \{
          case '%mine':
            cellsymbol = '☠'; break;
          case '%flag':
            cellsymbol = '⚑'; break;
          case '%0':
            cellsymbol = '0'; break;
          case '%1':
            cellsymbol = '1'; break;
          case '%2':
            cellsymbol = '2'; break;
          case '%3':
            cellsymbol = '3'; break;
          case '%4':
            cellsymbol = '4'; break;
          case '%5':
            cellsymbol = '5'; break;
          case '%6':
            cellsymbol = '6'; break;
          case '%7':
            cellsymbol = '7'; break;
          case '%8':
            cellsymbol = '8'; break;
          default:
            console.log("Error:  Unknown square character detected.");
        }
        bcell.innerHTML = cellsymbol;
      }
  }
    function state_set(rmax,cmax,stat) \{
      var fontCol = '#c6a615';
      var bgCol = '#066508';
      var flagCol = '#0D6CE5';
      var mineCol = '#E5480D'
      if (stat == 'win') \{
        fontCol = "#FFFFFF";
        bgCol = "#00FF00";
        flagCol = fontCol;
        mineCol = fontCol;
      }
      else if (stat == 'lose') \{
        fontCol = '#FFFFFF';
        bgCol = '#FF0000';
        flagCol = fontCol;
        mineCol = fontCol;
      }

      for (let i = 0; i < rmax; i++) \{
        for (let j = 0; j < cmax; j++) \{
          let bcell = document.getElementById(i + '-' + j);
          bcell.style.color = fontCol;
          if (bcell.innerHTML == '☠') \{
            bcell.style.color = mineCol;
          }
          else if (bcell.innerHTML == '⚑') \{
            bcell.style.color = flagCol;
          }
          bcell.style.backgroundColor = bgCol;
        }
      }
    }

    function check_error(er) \{
      console.log(er);
      console.log('Error: recieved an error from the back-end');
    }

    function dims_changed() \{
      const containDiv = document.querySelector('.contain');
      if (containDiv) \{
        containDiv.innerHTML = '';
        containDiv.className = 'start';
        containDiv.style.width = '';
        const warnDiv = document.createElement('div');
        warnDiv.textContent = 'Warning: Board dimensions changed mid-game. Refresh page.';
        containDiv.appendChild(warnDiv);
      }    
    }

    function check_callback(upd) \{
      console.log(upd);
      if ('init' in upd) \{
        console.log('Eyre Channel Subscription is: ' + api.uid + ', path: /mines-sub' );
      }
      else if ('upstate' in upd) \{
        let rmax = upd.upstate.rmax;
        let cmax = upd.upstate.cmax;

        if ((rmax  !=  rows) ||  (cmax  !=  cols)) \{
          console.log("Warning: Board dimensions have changed! Refresh page and start again.");
          dims_changed();
        }
        else \{
          board_scrub(rmax, cmax);
          board_set(upd.upstate.board);
          state_set(rmax, cmax, upd.upstate.gstat);
        }
      }
    }

    console.log('Sail page JS successfully loaded.');
  """
--
