::  Import strucutre file.
/-  *ttt
:: Our Sail page is a gate that renders HTML that we
::  serve to our localhost website.
::  Bowl and gamestate supplied to gate. Bowl isn't
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
=/  play-classes  (assign-classes status.gstate next.gstate)

::  Notes about Sail:  Use a mictar rune for each 
::  new %+ turn and sub-elements generated. Using one 
::  mictar with multiple levels of loop and/or 
::  sub-elements leads to ruin.  When adding id and 
::  css attributes, its tag#css.class in that order!
::
;html
  ;head
    ;title: tictactoe
    ;meta(charset "utf-8");
    ;style
      ;+  ;/  style
    ==  ::style
    ;script(type "module")
      :: oust removes sig from tape conversion.
      ;+  ;/  (script (oust [0 1] <our.bol>))
    ==
  ==  ::head
  ;body
    ;h1: %ttt - Tic-Tac-Toe:
    ;h2: Use console pokes to set moves.  
    ;h2: Page auto-refreshes on player %moves.  
    ;h2: See the structure file for more details.
    ;br;
    ;br;  
    ;+  ?:  =(rows.bsize.gstate 0)
        ;div.sigdiv:  Bunted game state detected. Please make a newgame poke to begin.
        ;div.contain
          ;*  ?~  clist  !!
            %+  turn  clist
              |=  rclist=(list coord)
              ;div.boardrow
                ;*
                ?~  rclist  !!
                  %+  turn  rclist
                  |=  rc=coord
                    ?:  (~(has by board.gstate) rc)
                      ::T: Display the unique piece. It is present, so no (need...
                      =/  val  (~(get by board.gstate) rc)
                      =/  symbol  ?-  (need val)
                              %o  "⭘"
                              %x  "⨯"
                              %e  "·"
                            ==
                        ;div(class "square", id "{<r.rc>}-{<c.rc>}"): {symbol} 
                      :: F: No item present. Let's make a default (dotted) square.
                      ;div(class "square", id "{<r.rc>}-{<c.rc>}"): {"·"}
              == ::div board
      ==  ::div contain
      ;br;
      ;br;
      ;br;
      ;div.statuscontainer  
          ;div(id "p1", class p1.play-classes):  Player 1 - ⨯
          ;div(id "p2", class p2.play-classes):  Player 2 - ⭘
      ==  ::div statuscontainer
  == ::body
== ::html
::
::  Gate that takes in our status and player states,
::  and produces the correct classes for our player
::  status bar.
++  assign-classes
  |=  [status=ssymbol player=psymbol]
    ^-  [p1=tape p2=tape]
    :: Null case: state is bunted.
    ?:  =(rows.bsize.gstate 0)
      [p1="player limbo" p2="player limbo"]
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
    body {
      background-color:#333333;
      color:#c6a615;
      text-align: center;
      font-weight:bold;
    }
    h1 {
      font-size: 56pt;
    }
    h2 {
      font-size: 30pt;
      margin-top: 8px;
      margin-bottom:8px;
    }
    div  {  
      font-size: 16pt;
    }
    .sigdiv {
      width: 50%;
      height: 20%;
      text-align: center;
      font-size: 48pt;
      margin: 0 auto; 
      display: block;
    }
    .statuscontainer {
      width: 70%;
      margin: 0 auto; 
      display: flex;
    }
    .player {
      flex: 1; 
      font-size: 24pt;
      padding: 10px;
      border: 1px solid #000;
      border-radius:5px; 
    }
    .active {
      background-color: #066508;
    }
    .waiting {
      background-color: #333333;
      border-color:#111111;
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
  .contain {
      margin-top: 5%;
      width: auto;
      display: flex;
      flex-direction: column;
      align-items: center;
      margin: 0 auto; 
      padding: 10px; 
  }
  .boardrow {
      display: flex;
      width: 25%; 
  }
  .square {
      border-radius:5px;
      flex: 1;
      padding: 20px 5px 5px 5px;
      background-color: #066508;
      border: 1px solid #03440E;
      font-size: 72pt;
      align-items: center;
      justify-content: center;
      font-weight: bold;
      display: flex;
      aspect-ratio: 1 / 1;
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
::  function check_callback handles our %upstate responses 
::  from BE. Mainly used to update the board.
::
::  When an upstate card is recieved, we do three things
::  (1) reset the board with board_scrub, (2) set the board
::  with board_set, and (3) set status bar with
::  set_state.  
::
::  Curly braces are escaped \{ as compiler interprets
::  these in a tape as starting an interpolation site.
::
::  In closing, the unpleasant look of JS
::  slammed in a gate beats dealing a bloated 
::  node_modules folder, and minified code.

++  script
  |=  our-bowl=tape
  ^-  tape 
  """
  import urbitHttpApi from 'https://cdn.skypack.dev/@urbit/http-api';

  const api = new urbitHttpApi('', '', 'ttt');
  api.ship = '{our-bowl}';

  var subID = api.subscribe(\{
    app: 'ttt',
    path: '/ttt-sub',
    event: check_callback,
    err:  check_error
  })

  function check_error(er) \{
    console.log(er);
  }

  function state_set(gstat, who) \{
    let p1p = document.getElementById('p1');
    let p2p = document.getElementById('p2'); 
    switch (gstat) \{
      case 'cont':
        if (who == 'p1x') \{
          p1p.className = 'player waiting'; 
          p2p.className = 'player active';
        }
        else if (who == 'p2o') \{
          p1p.className = 'player active'; 
          p2p.className = 'player waiting'; 
        }
        break;
      case 'p1win':
        p1p.className = 'player master'; 
        p2p.className = 'player slave';
        break;
      case 'p2win':
        p1p.className = 'player slave'; 
        p2p.className = 'player master';
        break;
      case 'draw':
        p1p.className = 'player limbo'; 
        p2p.className = 'player limbo';
        break;
      default:
        console.log('[!] Error:  Invalid game state detected.');
    }
  }

  function board_scrub(r,c) \{
    for (let i = 0; i < r; i++) \{
      for (let j = 0; j < c; j++) \{
        let bcell = document.getElementById(i + '-' + j);
        bcell.innerHTML = '·';
      }
    }
  }

  function board_set(uparr) \{
      for (let i = 0; i < uparr.length; i++) \{
        let item = uparr[i];
        let bcell = document.getElementById(item.r + '-' + item.c);
        bcell.innerHTML = (item.sq == 'x') ? '⨯' : ((item.sq == 'o') ? '⭘' : '·');
      }
  }

  function check_callback(upd) \{
    console.log(upd);
    if ('init' in upd) \{
      console.log('Eyre Channel Subscription is: ' + api.uid + ', path: /ttt-sub' );
    }
    else if ('upstate' in upd) \{
      board_scrub(3,3);
      board_set(upd.upstate.board);
      state_set(upd.upstate.gstat, upd.upstate.who);
    }
  }

  console.log('Sail page JS successfully loaded.');
  """
--
