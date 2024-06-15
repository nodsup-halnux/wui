/-  *ttt
::  default agent used for template arm calls,
::  agentio used for binding requests
/+  default-agent, agentio
::  our path to our frontpage display.
/=  display  /app/ttt/display
::  Set for our ~?  conditional gates to fire
=/  debugmode  %.n
|%
+$  cag  card:agent:gall
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
      ~?  debugmode  
        ~&  "on-init:wui:"  ":Initializing WUI"
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
        ^-  (quip cag _this)
        =^    cards
            game
          (on-load:ag old-state)
        [cards this]
::  Poke Arm - most fleshed out because we interact this way
    ++  on-poke
      |=  [=mark =vase]
        ^-  (quip cag _this)
        ::  A bar-ket is stuffed in the gate, so as to
        ::  compartmentalize our little HTTP
        ::  server code into the on-poke arm.
        |^ 
          ::Our $-arm
          ^-  (quip cag _this)
          ~?  debugmode  
            ~&  "ttt-wui: Poke request. Mark:"  mark
            ?+  mark
              :: If not an HTTP request, send straight to %ttt
              =/  pre-state  !<(appstate on-save:ag)
              =^  cards  game  (on-poke:ag mark vase)
              =/  post-state  !<(appstate on-save:ag)
              ::  A ~ board means we started a new game, or
              ::  We made a non-move after a new game.
              ::  We send no cards if the board is ~,
              ::  or if the player makes a non-move.
              ?:  ?|  =(board.post-state ~)
                      (check-diff board.pre-state board.post-state)
                  ==
                ~?  debugmode  
                  ~&  "~ boardmap or no board" 
                    " difference detected by ttt-wui."
                `this
              ::  F:  There is a difference in board, 
              ::  send an upstate card.
              ~?  debugmode  
                ~&  "~ boardmap difference"  
                " detected by ttt-wui."
              =/  delta  (state-delta pre-state post-state) 
              =/  upcard  
                :*  %give 
                    %fact 
                    ~[/ttt-sub] 
                    %ttt-update 
                    !>(`update`[%upstate gstat=st.delta who=cp.delta r=r.rc.delta c=c.rc.delta])
                ==
                ::  Add our upcard to the end of our cards.
                :_  this  (snoc cards upcard)
              ::The only other possible mark - a browser request
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
                  :: Check if we have a non-GET req.
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
                        =/  gamestate  !<(appstate on-save:ag)  
                        :: The board can be ~, but the gamestate itself cannot.
                        :: If this happens we have a serious error.
                        =/  ourpage  (make-200 rid (display bol gamestate))
                          :_  this  ourpage
                          
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
          :: Used to generate a non-200 series response.
          :: Just a stack of (complex) cards returned.
          ++  give-http
            |=  [rid=@ta hed=response-header:http dat=(unit octs)]
              ^-  (list cag)
              :~  [%give %fact ~[/http-response/[rid]] %http-response-header !>(hed)]
                  [%give %fact ~[/http-response/[rid]] %http-response-data !>(dat)]
                  [%give %kick ~[/http-response/[rid]] ~]
              ==
::
          ::We only care about the player, the game state, and the 
          ::coordinate for the move.
          +$  delta-state  
            $:  rc=coord
              cp=psymbol
            st=ssymbol
          ==
::
          ::  Generate our upstate cell.
          ++  state-delta  
            |=  [old=appstate new=appstate]
              ^-  delta-state
              :+  (calc-diff board.old board.new) 
                next.old
              status.new
::
          ::  Wrapper that calls get-diff and returns
          :: a loobean for tests.
          ++  check-diff  
            |=  [bold=boardmap bnew=boardmap]
              ^-  ?  =((get-diff bold bnew) ~)
::
          ::  Wrapper gate that calls get-diff and
          :: returns a coord.
          ++  calc-diff
            |=  [bold=boardmap bnew=boardmap]
              ^-  coord
              =/  dlist  (get-diff bold bnew)
                ?~  dlist  !!  ::Should never crash.
                  ~?  debugmode  
                    ~&  "our pre/post state diff is: " 
                     -.i.dlist
                  -.i.dlist
::
          ::  All pre and post state board diffs are
          ::  computed by this base gate.
          ++  get-diff
            |=  [bold=boardmap bnew=boardmap]
              ^-  (list [coord tsymbol])
                =/  smold  ,(set [coord tsymbol])
                =/  oldset  (get-set bold)
                =/  newset  (get-set bnew)
                =/  difflist  
                  ~(tap in `smold`(~(dif in newset) oldset))
                  difflist
            ::  Makes get-diff a bit cleaner.
            ++  get-set
              |=  aboard=boardmap
              ^-  (set [coord tsymbol])
                  %-  
                    %~  gas  
                        in 
                      ^-  (set [coord tsymbol])  ~
                      %~  tap 
                        by 
                      aboard
          -- ::End |^
::
++  on-peek   |=(path ~)
::
++  on-watch
  |=  =path
    ^-  (quip cag _this)
    ?~  path  !!
      ~?  debugmode  
        ~&  "on-watch ttt-wui path is:"  i.path
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
        ?:  ?&(=([%bind ~] wire) =(%eyre -.sign-arvo))
          ~?  debugmode  
            ~&  "wire="  ~&  wire  ~&  ",sign-arvo"  sign-arvo
          ~&  'Arvo bind confirmed. Hosted at localhost:<yourport#>/ttt/display.'
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
    --  ::End  |_
::  End |%
--