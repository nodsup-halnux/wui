/-  *mines
/+  default-agent, agentio
::  our path to our frontpage display.
/=  display  /app/mines/display
::  Toggle debug mode for console.
=/  debugmode  %.y
|%
+$  cag  card:agent:gall
++  agent  
  |=  game=agent:gall
    ^-  agent:gall
    |_  bol=bowl:gall
      +*  this  .
          ag    ~(. game bol)
          default  ~(. (default-agent this %|) bol)
          io    ~(. agentio bol)
::
    ++  on-init
    ~?  debugmode  
      ~&  "on-init:ms-wui: "  ":Initializing MS-WUI"
      ^-  (quip cag _this)
      ::  This is an arvo call that binds the path 
      ::  /ttt/display to localhost:8080.  We do not 
      ::  send a card to on-poke:ag to initialize 
      ::  the board. The user must do this manually.
      :_  this  
      [(~(arvo pass:io /bind) %e %connect `/'mines' %mines)]~
::
    ++  on-save  on-save:ag
::
    ++  on-load
      |=  old-state=vase
        ^-  (quip cag _this)
        =^    cards
            game
          (on-load:ag old-state)
        [cards this]
::  Poke Arm - most fleshed out because we interact this way.
    ++  on-poke
      |=  [=mark =vase]
        ^-  (quip cag _this)
        ::  A bar-ket is stuffed in the gate, so as to
        ::  compartmentalize our HTTP server code.
        |^ 
          ::Our $-arm
          ^-  (quip cag _this)
            ~?  debugmode  
              ~&  "ms-wui: Poke request. Mark:"  mark
          ?+  mark
            :: If not an HTTP request, send straight to %mines
              =^  cards  game  (on-poke:ag mark vase)
              =/  post-state  !<([%zero game-state] on-save:ag)  
              ::  If dims is bunted, it means we have just booted with no %start
              ?:  =(dims.post-state [0 0])
              ::T:  Don't send an upstate.
                ~&  "%mines booted: please %start a game and load the display page."
                `this
                ::F:  We have %started, but not %tested.  Don't send a card.
                ?:  =(tiles.post-state ~)
                    ~?  debugmode  
                      ~&  "~ tiles map,"  " no card sent." 
                    `this
                  ::F:  A game is running.
                    ~?  debugmode  
                      ~&  "Sending upstate card"  " to FE." 
                  =/  upcard  
                    :*  %give 
                        %fact 
                        ~[/mines-sub] 
                        %mines-update 
                        !>(`update`[%upstate gstat=playing.post-state bdims=dims.post-state tboard=tiles.post-state])
                    ==
                  :_  this  (snoc cards upcard)
          ::  An Eyre GET request routs here.
          ::  If we start our app, and load display directly,
          :: display.hoon must handle the bunted case.
          %handle-http-request
            (handle-http !<([@ta inbound-request:eyre] vase))
          ==  ::End ?+  
        ::End $-arm
          ++  handle-http 
            :: Eyre takes our browser poke, and passes 
            :: a complex request structure.
            |=  [rid=@ta req=inbound-request:eyre]
              ^-  (quip cag _this)
              :: First check to see if user auth'ed.
              ?.  authenticated.req
                  :_  this
                  %^    give-http 
                      rid 
                    [307 ['Location' '/~/login?redirect='] ~] 
                  ~
::
                  :: Check if we have a GET/other req.
                  ?+  method.request.req
                      :_  this
                      %^      give-http
                            rid
                          :-    405
                            :~    ['Content-Type' 'text/html']
                                ['Content-Length' '31']
                              ['Allow' 'GET, POST']
                             ==
                      (some (as-octs:mimes:html '<h1>405 - Forbidden Req</h1>'))
::
                      %'GET'
                      ~?  debugmode  
                        ~&  "%handle-http-req:"  
                          " GET Request received"
                        =/  minestate  !<([%zero game-state] on-save:ag)  
                        :: The board can be ~, but the gamestate itself cannot.
                        :: If this happens we have a serious error.
                          :_  this  (make-200 rid (display bol minestate))
                  == ::End ?+
            ::  End handle-http gate
::
          ++  make-200
            |=  [rid=@ta dat=octs]
            ^-  (list cag)
                %^    give-http
                    rid
                :-  200
                :~  ['Content-Type' 'text/html']
                    ['Content-Length' (crip ((d-co:co 1) p.dat))]
                ==
                [~ dat]
::
          :: Used to generate a response.
          :: Just a stack of (complex) cards returned.
          ++  give-http
            |=  [rid=@ta hed=response-header:http dat=(unit octs)]
              ^-  (list cag)
              :~  [%give %fact ~[/http-response/[rid]] %http-response-header !>(hed)]
                  [%give %fact ~[/http-response/[rid]] %http-response-data !>(dat)]
                  [%give %kick ~[/http-response/[rid]] ~]
              ==
          -- ::End of |^
::
    ++  on-peek   |=(path ~)
::
++  on-watch
  |=  =path
    ^-  (quip cag _this)
    ?~  path  !!
    ~?  debugmode  
      ~&  "on-watch ms-wui path is:"  i.path
  ::  Our cards generated by the HTTP arm get sent 
  ::  to Eyre,  but also our on-watch arm.  This is 
  ::  done to cut out behaviour - which confuses 
  ::  eyre and gives us a 500 Error.
    ?:  &(=(our.bol src.bol) ?=([%http-response *] path))
      `this
        =^    cards  
            game  
          (on-watch:ag path)  
        [cards this]
::
    ++  on-leave
      |=  =path
        ^-  (quip cag _this)
        =^    cards
            game
          (on-leave:ag path)
        [cards this]
::
    ++  on-agent
      |=  [=wire =sign:agent:gall]
        ^-  (quip cag _this)
        =^    cards
            game
          (on-agent:ag wire sign)
        [cards this]
::
    ++  on-arvo
      |=  [=wire =sign-arvo]
         ^-  (quip cag _this)
        ~?  debugmode  
          ~&  "wire="  ~&  wire  ~&  ",sign-arvo"  sign-arvo
        ?:  ?&(=([%bind ~] wire) =(%eyre -.sign-arvo))
           ::  %.y
          ~&  'Arvo bind confirmed. Hosted at localhost:<yourport#>/mines/display.'
          `this
          ::  %.n
          ~&  '(!) Error: arvo rejected frontend binding.'
          `this
::
    ++  on-fail
      |=  [=term =tang]
        ^-  (quip cag _this)
        =^    cards
            game
          (on-fail:ag term tang)
        [cards this]
    --  ::End |_
::  End |%
--