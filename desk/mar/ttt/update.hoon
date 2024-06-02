/-  *ttt
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
      %upstate
           %+  frond  'upstate'
            %-  pairs
              :~  ['gstat' s+gstat.upd]
                  ['next' s+next.upd]
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