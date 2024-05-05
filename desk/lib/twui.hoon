/-  *ttt
::  default agent used for template arm calls,
::  agentio used for binding requests
/+  default-agent, agentio
::  our path to our frontpage display.
/=  display  /app/ttt/display
::
::  How wui works:  User imports wui
::  and passes their state core + agent door into 
::  this library.  This gets inputted into the agent
::  arm gate below.  The wrapper intercepts every
::  interaction sent by Gall.  If a poke is intended
::  for the agent, it hands it off and then returns
::  what the agent returns to Gall.  As far as Gall
::  is aware, it is interacting a core that is shaped
::  like and behaves like an agent, so it does not 
::  care.
|%
::  Using (quip card this) for our kethep
::  in the arms causes weird nesting problems,
::  likely because we are monkeying around with wrappers
::  and agent+state as [code-as-data]. Likely there
::  is a namespace issue.
::  These shorthands are used instead.
+$  cag  card:agent:gall
::  Please don't give me "that" look rn.
+$  that  agent:gall
++  agent  
  |=  game=agent:gall
    ^-  agent:gall
    |_  bol=bowl:gall
      +*  this  .
          ::The ~()'s  are %~ irregular forms.
          ag    ~(. game bol)
          default  ~(. (default-agent this %|) bol)
          io    ~(. agentio bol)
::
    ++  on-init
      ~&  "on-init:wui::Initializing WUI"
      ::  We don't use (quip card this), as we don't have 
      ::  a structure def core up top - system defs 
      ::  are used instead.
      ^-  (quip card:agent:gall agent:gall)
      ::  This is an arvo call that binds the path 
      ::  /ttt/display to localhost:8080.  We do not 
      ::  send a card to on-poke:ag to initialize 
      ::  the board. The user must do this manually.
      :_  this  
      [(~(arvo pass:io /bind) %e %connect `/'ttt' %ttt)]~
::
    ++  on-save  on-save:ag
::
    ++  on-load
      |=  old-state=vase
        ^-  (quip cag that)
        =^    cards
            game
          (on-load:ag old-state)
        [cards this]
::  Poke Arm - most fleshed out because we interact this way
    ++  on-poke
      |=  [=mark =vase]
        ^-  (quip cag that)
        ::  A bar-ket is stuffed in the gate, so as to
        ::  compartmentalize our little HTTP
        ::  server code into the on-poke arm.
        |^ 
          ::Our $-arm
          ^-  (quip cag that)
          ?+  mark
            :: If not an HTTP request, send straight to %ttt
              =^  cards  game  (on-poke:ag mark vase)  [cards this]
              %handle-http-request
                (handle-http !<([@ta inbound-request:eyre] vase))
          ==  ::End ?+  
        ::End $-arm
          ++  handle-http 
            :: Eyre takes our browser poke, and passes 
            :: a complex request structure.
            |=  [rid=@ta req=inbound-request:eyre]
              ^-  (quip cag that)
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
                        =/  gamestate  !<(appstate on-save:ag)  
                        ?~  board.gamestate  !!
                          :_  this  
                          (make-200 rid (display bol gamestate))
                  == ::End ?+
            ::  End handle-http gate
            :: Construct a 200 series HTTP request.
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
          :: Used to generate a non-200 series response.
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
        ^-  (quip cag that)
        =^    cards  
            game  
          (on-watch:ag path)  
        [cards this]
::
    ++  on-leave
      |=  =path
        ^-  (quip cag that)
        =^    cards
            game
          (on-leave:ag path)
        [cards this]
::
    ++  on-agent
      |=  [=wire =sign:agent:gall]
        ^-  (quip cag that)
        =^    cards
            game
          (on-agent:ag wire sign)
        [cards this]
::
    ++  on-arvo
      |=  [=wire =sign-arvo]
         ^-  (quip cag that)
        ~&  "wire="  ~&  wire  ~&  "sign-arvo"  ~&  sign-arvo
        ?:  ?&(=([%bind ~] wire) =(%eyre -.sign-arvo))
           ::  %.y
          ~&  'Arvo bind confirmed. Navigate to localhost:<yourport#>/ttt/display to view board.'  `this
          ::  %.n
          ~&  '(!) Error: arvo rejected frontend binding.'  `this
::
    ++  on-fail
      |=  [=term =tang]
        ^-  (quip cag that)
        =^    cards
            game
          (on-fail:ag term tang)
        [cards this]
    --  ::End of our door |_
::  End of our |%
--