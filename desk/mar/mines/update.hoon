/-  *mines
|_  upd=update
++  grow
  |%
  ++  noun  upd
  ++  json
    =,  enjs:format
    ^-  ^json
    ?-    -.upd
      %init
           %+  frond  'init'
             %-  pairs
              :~  ['ack' (numb ack.upd)]  ==
      ::  We can construct more complicated pair
      ::  structures, but atomic is more simple.
      %upstate
          ::  if tappified ~, turn returns ~
          =/  jtap  (turn ~(tap by tboard.upd) jsonify)
           %+  frond  'upstate'
            %-  pairs
              :~  ['gstat' s+gstat.upd]
                  ['rmax' (numb x.bdims.upd)]
                  ['cmax' (numb y.bdims.upd)]
                  ['board' [%a jtap]]
              ==  :: end pairs
    ==  ::End ?-
::  Got stuck for a while on this gate, with a nest fail
:: error. Lesson: Always use the enjs:format functions
:: to build the cells.  Doing it manually can lead to
:: ruin. You can thank me later.
::  This gate assumes that duplicates have been
++  jsonify 
    |=  [p=coord q=tile]
        :: lots of weird list interp errors. No, ~
        :: was not the problem. Limo to be sure.
        =/  limoed  
          %-  limo 
            :~  
                ['x' (numb:enjs:format x.p)]
                ['y' (numb:enjs:format y.p)]
                ['sq' (tape:enjs:format <q>)]
            ==
        %-  pairs:enjs:format  limoed
--
++  grab
  |%
  ++  noun  update
  --
++  grad  %noun
--