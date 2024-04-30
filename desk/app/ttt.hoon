:: This app uses the %squad page serving/index.hoon code, and %charlie as a Gall App template.
:: Our structure file. Standard action/update pattern is also used (in /mar)
/-  *ttt
/+  default-agent, twui
::Import FE file that we will serve up in ++on-poke
::/=  frontpage  /app/frontend/frontpage
::We call the agent arm from the core in the twui library
::The idea:  ++agent is fed our state and our agent together. So it
::has access to them, and can call them. Its just arm calls in the end,
::nested in a given subject tree...
::  This is our state core - twui needs to be able to see it!
|%
    +$  versioned-state
    $%  state-0
    ==
    +$  state-0  appstate
        :: A very basic state to test Sail with.  $:  [%0 board=boardmap bsize=dims] ==
    +$  card  card:agent:gall
--

%-  agent:twui

=|  state-0  
=*  state  -
::  Our sample app starts here (10 arm door)
^-  agent:gall
|_  =bowl:gall
+*  this     .
    default  ~(. (default-agent this %|) bowl)
  ++  on-init  
    ~&  "ttt on-init called"  on-init:default
    :: :_  this  [(~(arvo pass:agentio /bind) %e %connect `/'frontpage' %ourapp)]~
++  on-save   !>(state)
++  on-load  
  |=  old=vase
  ^-  (quip card _this)
  `this(state !<(state-0 old))
++  on-poke
    |=  [=mark =vase]
    |^  ::reminder, actions come from /sur
        ^-  (quip card _this)
        ~&  'ttt on poke has been called.'
        ~&  'our mark is'  ~&  mark
        ~&  'our vase is'  ~&  vase
        ?+  mark  `this
            %ttt-action             
                (handle-action !<(action vase))
         ==  ::End ?+  ::End $-arm
        ++  handle-action
            |=  act=action
                ^-  (quip card _this)
                ~&  "our action"  ~&  act
                ?-    -.act
                    ::Here, we set a basic state using a poke via the terminal. This will test our Sail render gates
                    %newgame
                        ~&  "TTT has received a newgame poke."
                        =/  ntn  
                                :*
                                    [[r=0 c=0] m=%e] 
                                    [[r=0 c=1] m=%e]
                                    [[r=0 c=2] m=%e]
                                    [[r=1 c=0] m=%e] 
                                    [[r=1 c=1] m=%e]
                                    [[r=1 c=2] m=%e]
                                    [[r=2 c=0] m=%e] 
                                    [[r=2 c=1] m=%e]
                                    [[r=2 c=2] m=%e]
                                    ~
                                ==
                        :_  %=  this  bsize  [r=3 c=3]  board  (my ntn)  moves  0  currplayer  %p1x  status  %cont    ==  ~
                    %printstate
                        ~&  'Board='  ~&  board
                        ~&  'Dims='  ~&  bsize
                        ~&  'currplayer='  ~&  currplayer
                        ~&  'moves'  ~&  moves
                        ~&  'status'  ~&  status
                        `this
                    %teststate
                        ~&  "TTT has received a teststate poke."  
                        =/  ntn  
                                :*
                                    [[r=0 c=0] m=%o] 
                                    [[r=0 c=1] m=%x]
                                    [[r=0 c=2] m=%e]
                                    [[r=1 c=0] m=%o] 
                                    [[r=1 c=1] m=%x]
                                    [[r=1 c=2] m=%x]
                                    [[r=2 c=0] m=%o] 
                                    [[r=2 c=1] m=%e]
                                    [[r=2 c=2] m=%e]
                                    ~
                                ==
                        :_  %=  this  bsize  [r=3 c=3]  board  (my ntn)  moves  6  currplayer  %p1x  status  %cont  ==  ~
                    %move  
                    ~&  "TTT has received a setpos poke."  
                    :_  %=  this  board  (~(put by board) [[r.act c.act] [ttype.act]])  moves  +(moves)  ==  ~
                    %testfe
                    ~&  "TTT has received a testfe poke."  
                    :_  %=  this  currplayer  current.act  status  stat.act  ==  ~
                == ::End ?-
    --  ::End |^
++  on-peek  on-peek:default
++  on-watch
  |=  =path
  ^-  (quip card _this)  `this
++  on-arvo   on-arvo:default
++  on-leave  on-leave:default
++  on-agent  on-agent:default
++  on-fail   on-fail:default
--