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
::  Years of wondering why I can't use "that" in a 
::  language that implements OOP have cumulated into
::  this perfect, final moment.  
::  I'm clapping on the inside rn.
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
          ~&  "ttt-wui: Poke request. mark="  ~&  mark
          ?+  mark
            :: If not an HTTP request, send straight to %ttt
            =/  pre-state  !<(appstate on-save:ag)
            =^  cards  game  (on-poke:ag mark vase)
            =/  post-state  !<(appstate on-save:ag)
            =/  delta  (state-delta pre-state post-state) 
            =/  upcard  
                :*  %give 
                    %fact 
                    ~[/ttt-sub] 
                    %ttt-update 
                    :: A rare tall-form zap-gar appears.
                    !>(`update`[%upstate gstat=st.delta who=cp.delta r=r.rc.delta c=c.rc.delta])
                ==
            ~&  cards  
            ?~  cards
              :: If it is sig, we for a basic list
              :_  this  [upcard]~
              ::  If not, we append it to our current list.
              :_  this  (snoc cards upcard)
            ::  End of internal poke.
            ::The only other possible mark - a browser request
              %handle-http-request
                (handle-http !<([@ta inbound-request:eyre] vase))
          ==  ::End ?+  
        ::End $-arm
          ++  handle-http 
            :: Eyre takes our browser poke, and passes 
            :: a complex request structure.
            |=  [rid=@ta req=inbound-request:eyre]
              ^-  (quip cag that)
              ~&  "We are in the handle-http arm."
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
                        ~&  "Hit the GET case of the HTTP ARM."
                        =/  gamestate  !<(appstate on-save:ag)  
                        :: The board can be ~, but the gamestate itself cannot.
                        :: If this happens we have a serious error.
                        =/  ourpage  (make-200 rid (display bol gamestate))
                          :_  this  ourpage
                          
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
          ::We only care about the player, the game state, and the 
          ::coordinate for the move.
          +$  delta-state  
            $:  rc=coord
              cp=psymbol
            st=ssymbol
          ==
          ++  state-delta  
            |=  [old=appstate new=appstate]
              ^-  delta-state
              :+  (map-diff board.old board.new) 
                next.old
              status.new
          ::  What is going on:
          ::  ~(tap by bold)  turns a map into a [k v] list
          ::  ~(gas in ...)  ~tap by...  : takes our [k v] list and puts it into
          ::  we turn maps into [k v] sets, so that we can call:
          ::  (~(dif in newset) oldset) which picks out our last move...to form
          :: the upstate card.
          ++  map-diff
            |=  [bold=boardmap bnew=boardmap]
              ^-  coord
              =/  oldset  `(set [coord tsymbol])`(~(gas in `(set [coord tsymbol])`~) ~(tap by bold))
              =/  newset  `(set [coord tsymbol])`(~(gas in `(set [coord tsymbol])`~) ~(tap by bnew))
              =/  difflist  ~(tap in `(set [coord tsymbol])`(~(dif in newset) oldset))
              ?~  difflist  !!  
                ~&  "our difference is: "  ~&  -.i.difflist  -.i.difflist
          -- ::End of |^
::
++  on-peek   |=(path ~)
::
++  on-watch
  |=  =path
    ^-  (quip cag that)
    ?~  path  !!
      ::  Our cards generated by the HTTP arm get sent to Eyre,
      :: But also our on-watch arm (??)  This is to cut out
      :: The useless behaviour - which confuses eyre and gives us
      :: a 500 Error.
      ~&  "on-watch ttt wui path is:"  ~&  i.path
      ~&  "FYI our.bowl and src.bol are"  ~&  [our.bol src.bol]
      ?:  &(=(our.bol src.bol) ?=([%http-response *] path))
      `this
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
          ~&  'Arvo bind confirmed. Hosted at localhost:<yourport#>/ttt/display.'
          `this
          ::  %.n
          ~&  '(!) Error: arvo rejected frontend binding.'
          `this
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