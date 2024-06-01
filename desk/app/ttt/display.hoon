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
=/  play-classes  
    ?:  =(board.gstate ~)
        [p1="player limbo" p2="player limbo"]
        (assign-classes status.gstate currplayer.gstate)

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
      ;+  ;/  script
    ==
  ==  ::head
  ;body
    ;h1: %ttt - Tic-Tac-Toe Board:
    ;h2: Use console pokes to set moves.  
    ;h2: Page auto-refreshes on player %moves.  
    ;h2: See the structure file for more details.
    ;br;
    ;br;
      ;+  ?:  =(board.gstate ~)
        ;div.sigdiv:  ~ No game state initialized. Start a %newgame ~ 
        ;div.contain
          ;*  ?~  clist  !!
            %+  turn  clist
              |=  rclist=(list coord)
              ;div.boardrow
                ;*
                ?~  rclist  !!
                  %+  turn  rclist
                  |=  rc=coord
                    =/  val  (need (~(get by board.gstate) rc))
                    =/  symbol  ?-  val
                            %o  "⭘"
                            %e  "·"
                            %x  "⨯"
                          ==
                      ;div(class "square", id "{<r.rc>}-{<c.rc>}"): {symbol} 
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
  |=  [status=statussymbol player=playersymbol]
    ^-  [p1=tape p2=tape]
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
      background-color: orange;
      color: black;
      text-align: center;
      line-height: 20vh; 
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
++  script
  ^~
  %-  trip
'''
 //  We don't have a session.js as we don't use npm build with urbithttp-api
 //  so api.ship must be interpolated, and pulled from our bowl.
  import urbitHttpApi from "https://cdn.skypack.dev/@urbit/http-api";
 
 //  Simple init. No need for authentication - as FE inside ship.
  const api = new urbitHttpApi("", "", "ttt");
  api.ship = "med";

  //  This is our subscribe request to Eyre.  Will hit the on-watch arm.
  var subID = api.subscribe({
    app: "ttt",
    path: "/ttt-sub",
    event: check_callback,
     err:  check_error
  })

  //Default error function, if something goes wrong.
  function check_error(er) {
    console.log(er);
    alert("we recieved an error from the back-end");
  }

  //This handles %upstate responses from BE. Will update our board for us.
  function check_callback(upd) {
    console.log(upd);
    if ('init' in upd) {
      console.log("Our Eyre Channel Subscription is: " + api.uid + ", with path: /ttt-sub" );
    }
    else if ('upstate' in upd) {
      let uup = upd.upstate;
      var cell = document.getElementById(uup.r + "-" + uup.c);
      cell.innerHTML = (uup.token == "o") ? "⭘" : ((uup.token == "x") ? "⨯" : "·");
      let p1p = document.getElementById("p1");
      let p2p = document.getElementById("p2"); 
      switch (uup.gstat) {
        case 'cont':
          if (uup.token == 'x') {
            p1p.className = "player waiting"; p2p.className = "player active";
          }
          else if (uup.token == 'o') {
            p1p.className = "player active"; p2p.className = "player waiting";
          }
          break;
        case 'p1win':
          p1p.className = "player master"; p2p.className = "player slave";
          break;
        case 'p2win':
          p1p.className = "player slave"; p2p.className = "player master";
          break;
        case 'draw':
          p1p.className = "player limbo"; p2p.className = "player limbo";
          break;
        default:
          console.log("Error:  Invalid game state.");
      }
    }
  }

    console.log("Sail page loaded.");
'''
--
