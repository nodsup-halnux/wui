/-  *ttt
/+  default-agent, agentio
/=  frontpage  /app/frontend/frontpage

|%
+$  statecell      
  $:  [%0 gameboard=board]
  ==
++  agent  
    ::  input a gall agent
    |=  game=agent:gall
    ::  return a gall agent
    ^-  agent:gall
    |_  bol=bowl:gall
        :: agent sample above is fed a bowl, and ref'ed by ag.
      +*  this  .
          ::This is cen-sig! go to arm and modifying.
          ::refers to line 6
          ag    ~(. game bol)
          default  ~(. (default-agent this %|) bol)
      ++  on-init
          ~&  "twui on-init called"
          :: We don't use (quip card this), as we don't have a structure def core
          :: up top - system defs are used instead.
          ^-  (quip card:agent:gall agent:gall)
          :_  this  [(~(arvo pass:agentio /bind) %e %connect `/'ttt' %ttt)]~
          ::=^  cards  agent  on-init:ag  [cards this]
      ++  on-save   on-save:ag
      ++  on-load
        |=  old-state=vase
          ^-  (quip card:agent:gall agent:gall)
          ~&  "twui on-load called"
          =^  cards  game  (on-load:ag old-state)  [cards this]
      ::  Poke Arm - most fleshed out because we interact this way
      ++  on-poke
        |=  [=mark =vase]
          ^-  (quip card:agent:gall agent:gall)
          |^ 
            ::Our $-arm
            ^-  (quip card:agent:gall agent:gall)
            ~&  "twui on-poke called"
            ?+  mark              
                :: [!!!] Null Case, just pass through!
                =^  cards  game  (on-poke:ag mark vase)  [cards this]
                :: Else, its an httprequest, deal with it.
                %handle-http-request
                :: We don't even need this in a separate arm. 
                :: Can be refactored more simply.
                    (handle-http !<([@ta inbound-request:eyre] vase))
            ==  ::End ?+  
            ::End $-arm
            ++  handle-http 
              |=  [rid=@ta req=inbound-request:eyre]
                ^-  (quip card:agent:gall agent:gall)
                ?.  authenticated.req
                    :_  this
                    (give-http rid [307 ['Location' '/~/login?redirect='] ~] ~)

                    ?+  method.request.req
                        :_  this
                        %^    give-http
                            rid
                            :-  405
                            :~  ['Content-Type' 'text/html']
                                ['Content-Length' '31']
                                ['Allow' 'GET, POST']
                            ==
                        (some (as-octs:mimes:html '<h1>405 Method Not Allowed</h1>'))
                    
                           %'GET'
                        :: board ((q:(need (need (on-peek:ag /x/dbug/state))))) -.+.game
                        :: reminder: peek produces a unit unit cage.
                        =/  mystate  on-save:ag  ~&  mystate
                        =/  extstate  !<(statecell on-save:ag)  
                        ?~  gameboard.extstate  !!
                        :_  this  (make-200 rid (frontpage bol gameboard.extstate))  ::!<(state on-save:ag)
                    == ::End ?+ and End arm
            ++  make-200
              |=  [rid=@ta dat=octs]
              ^-  (list card:agent:gall)
                  %^    give-http
                      rid
                  :-  200
                  :~  ['Content-Type' 'text/html']
                      ['Content-Length' (crip ((d-co:co 1) p.dat))]
                  ==
                  [~ dat]
            ++  give-http
              |=  [rid=@ta hed=response-header:http dat=(unit octs)]
              ^-  (list card:agent:gall)
                  :~  [%give %fact ~[/http-response/[rid]] %http-response-header !>(hed)]
                      [%give %fact ~[/http-response/[rid]] %http-response-data !>(dat)]
                      [%give %kick ~[/http-response/[rid]] ~]
                  ==
          -- ::End of barket |^
      ::End of our |= $ arm. 
      :: On peek returns a cage, not a `this!!
      ++  on-peek   |=(path ~)
      ++  on-watch
        |=  =path
        ~&  "twui on-watch called"
          ^-  (quip card:agent:gall agent:gall)
          =^  cards  game  (on-watch:ag path)  [cards this]
      ++  on-leave
        |=  =path
        ^-  (quip card:agent:gall agent:gall)
          =^  cards  game  (on-leave:ag path)  [cards this]
        ++  on-agent
        |=  [=wire =sign:agent:gall]
          ^-  (quip card:agent:gall agent:gall)
          ~&  "twui on-watch called"
          =^  cards  game  (on-agent:ag wire sign)  [cards this]
      :: Pass Through
        ++  on-arvo
        |=  [=wire =sign-arvo]
          ^-  (quip card:agent:gall agent:gall)
          ~&  "twui on-watch called"
          =^  cards  game  (on-arvo:ag wire sign-arvo)  [cards this]
      ++  on-fail
        |=  [=term =tang]
          ^-  (quip card:agent:gall agent:gall)
          =^  cards  game  (on-fail:ag term tang)  [cards this]
    --
--