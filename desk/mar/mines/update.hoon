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
           %+  frond  'upstate'
            %-  pairs
              :~  ['gstat' s+gstat.upd]
                  ['who' s+who.upd]
                  ['r' (numb r.upd)]
                  ['c' (numb c.upd)]
              ==
    ==
  --
++  grab
  |%
  ++  noun  update
  --
++  grad  %noun
--