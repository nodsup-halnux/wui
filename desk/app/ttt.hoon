:: Our structure file.
/-  *ttt
::  default-agent used to default un-implemented arms.
/+  default-agent, ttt-wui, dbug
:: Note:  Our state structure has been defined in /sur
:: This is done to aide the twui wrapper - this is not
:: standard practice in app development.
::  Set for our ~?  conditional gates to fire
=/  debugmode  %.n
|%
    +$  versioned-state
    $%  state-0
    ==
    +$  state-0  appstate
    ::  shorthand to reference card type.
    +$  card  card:agent:gall
--
::  Our wrapper takes in our gall agent, with state-0
::  pinned to its subject.  TWUI wraps around our app.
::  To the Gall vane, this is just another app. As long
::  As a [this card] is returned after every arm call, 
::  Gall is none-the-wiser.
::
::  Yes, we can (use +dbug)!
%-  agent:dbug
%-  agent:ttt-wui
::  Pin the state
=|  state-0  
::  Tis-tar deferred expression. state ref's state-0
::  Which is in the LH slot of our subject (-).
=*  state  -
::  Our sample app starts here (10 arm door).
^-  agent:gall
|_  =bowl:gall
+*  this     .
    default  ~(. (default-agent this %|) bowl)
::
++  on-init  on-init:default
::
++  on-save   !>(state)
::
++  on-load  
  |=  old=vase
  ^-  (quip card _this)
  ::  Shorthand for: Irregular form of cen-tis
  ::  ` creates a cell with a ~ in the front (no cards)
  `this(state !<(state-0 old))
::
++  on-poke
    |=  [=mark =vase]
        ^-  (quip card _this)
        ~?  debugmode
            ~&  '%ttt on-poke arm hit:'  mark
        =/  act  !<(action vase)
        ::  Unrecognized actions do nothing, instead
        ::  of crashing out.
        ?-  -.act
            ::Make a new game, or reset the game.
            %newgame
                :: Manually form our board cell.
                :_  
                    %=  
                        this  
                        bsize  [r=3 c=3]  
                        board  *boardmap  
                        moves  0  
                        next  %p1x  
                    status  %cont    
                ==  
            :: No cards.
            ~  :: End of %newgame case.
            %move  
            ::  Determine the current player, and switch to the other.
            ::  If we try to move the player that is not next, crash!
            ?>  =(next next.act)
                :: The game state records next player to move, but for some
                :: parts of the app we need to know who just moved. So both
                :: who structures are spawned for simplicity.
                ::  These structures can be simplified once testing is complete.
                =/  whonow  
                    ?:  =(next %p1x)
                        [p=%p1x q=%x]
                        [p=%p2o q=%o]
                =/  whonext  
                    ?:  =(next %p1x)
                        [p=%p2o q=%o]
                        [p=%p1x q=%x]
                :_  
                    %=  this
                        board  (~(put by board) [[r.act c.act] [q.whonow]])  
                        next  p.whonext
                        moves  +(moves)
                    ==  
                    ~
            ::  To test our outer ttt-wui 
            ::  - for the no difference in board case.
            %donothing  `this
            ::  This is done to return a huge structure 
            ::  test our /mar update file.
            %setboardtest1
                 =/  ntn  
                    :*
                        [[r=0 c=0] m=%o] 
                        [[r=0 c=1] m=%x]
                        [[r=0 c=2] m=%o]
                        [[r=1 c=0] m=%x] 
                        [[r=1 c=1] m=%o]
                        [[r=1 c=2] m=%x]
                        [[r=2 c=0] m=%o] 
                        [[r=2 c=1] m=%x]
                        [[r=2 c=2] m=%o]
                    ~
                    ==
                :_  
                    %=  
                        this  bsize  
                        [r=3 c=3]  
                        board  (my ntn)  
                        moves  0  
                        next  %p1x
                        status  %cont    
                    ==
                    ~
            ::  Board flipped, player flipped to test FE
            %setboardtest2
                 =/  ntn  
                    :*
                        [[r=0 c=0] m=%x] 
                        [[r=0 c=1] m=%o]
                        [[r=0 c=2] m=%x]
                        [[r=1 c=0] m=%o] 
                        [[r=1 c=1] m=%x]
                        [[r=1 c=2] m=%o]
                        [[r=2 c=0] m=%x] 
                        [[r=2 c=1] m=%o]
                        [[r=2 c=2] m=%x]
                    ~
                    ==
                :_  
                    %=  
                        this  bsize  
                        [r=3 c=3]  
                        board  (my ntn)  
                        moves  0  
                        next  %p2o
                        status  %cont    
                    ==
                    ~
            ::  Test a half board update, vs all or 1 move.
            %halfboard1
                 =/  ntn  
                    :*
                        [[r=0 c=0] m=%x] 
                        [[r=0 c=2] m=%x]
                        [[r=1 c=1] m=%x]
                        [[r=2 c=0] m=%x] 
                        [[r=2 c=2] m=%x]
                    ~
                    ==
                :_  
                    %=  
                        this  bsize  
                        [r=3 c=3]  
                        board  (my ntn)  
                        moves  0  
                        next  %p2o
                        status  %cont    
                    ==
                    ~
            %halfboard2
                 =/  ntn  
                    :*
                        [[r=0 c=1] m=%o]
                        [[r=1 c=0] m=%o] 
                        [[r=1 c=2] m=%o]
                        [[r=2 c=1] m=%o]
                    ~
                    ==
                :_  
                    %=  
                        this  bsize  
                        [r=3 c=3]  
                        board  (my ntn)  
                        moves  0  
                        next  %p1x
                        status  %cont    
                    ==
                    ~
        ==  ::  End of ?-::
++  on-peek  on-peek:default
++  on-watch
    |=  =path  
        ^-  (quip card _this)
        ?~  path  ~&  "Warning: on-watch path is ~ (!!)"  !!
            ~&  "on-watch %ttt app FE subscribe... "  ~&  "path is:"  ~&  path
            ::give a fact back - let FE know it sub was OK.
            :_  this  [%give %fact ~[path] %ttt-update !>(`update`[%init ack=1])]~
++  on-arvo   on-arvo:default
++  on-leave  on-leave:default
++  on-agent  on-agent:default
++  on-fail   on-fail:default
--