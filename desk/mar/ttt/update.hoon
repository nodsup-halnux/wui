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
      ::  We can construct more complicated pair
      ::  structures, but atomic is more simple.
      %upstate  
      =/  jtap  (turn ~(tap by ourmap.upd) jsonify)  
      %+  frond  'upstate'
        %-  pairs
          :~  ['gstat' s+gstat.upd]
              ['who' s+who.upd]
              ['board' [%a jtap]]
          ==
    ==  :: End ?-
  --
++  jsonify 
  |=  [p=coord q=square]
    ^-  json
      %-  pairs:enjs:format
        :~  
            ['r' (numb:enjs:format r.p)]
            ['c' (numb:enjs:format c.p)]
            ['sq' [%s q]]
        ==

++  grab
  |%
  ++  noun  update
  --
++  grad  %noun
--