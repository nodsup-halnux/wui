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
          ::  (list [coord tile])
          =/  kvlist  `(list [coord tile])`~(tap by tboard.upd)
          =/  jtap  
            ?:  =((lent kvlist) 1)
              ::T
              (turn kvlist jsonify)
              ::F 
              =/  kvlrefined  (skim-list kvlist x.bdims.upd y.bdims.upd)
              (turn kvlrefined jsonify)
          ::Generate $json cells.
          :: Third slot of the =/ jtap line.
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
:: ruin.
::  This gate assumes that duplicates have been removed
++  jsonify 
    |=  [p=coord q=tile]
        =/  limoed  
          %-  limo 
            :~  
                ['x' (numb:enjs:format x.p)]
                ['y' (numb:enjs:format y.p)]
                ['sq' (tape:enjs:format <q>)]
            ==
        %-  pairs:enjs:format  limoed
::  Can't just use ++noun to pull bdims, as update.hoon 
::  is recompiled every time and sometimes we have an 
::  %init update.
::  So removing out-of-bounds cells is done manually.
++  skim-list
    |=  [kv-list=(list [p=coord q=tile]) rmax=@ud cmax=@ud]
      ^-  (list [coord tile])
      ::  Should never be empty. Get access to i/t
      =/  result  `(list [coord tile])`~
      |-
        ^-  (list [coord tile])
        ?~  kv-list  
          ::  Return result, if empty.
          result
          :: Otherwise, traverse the list.
          =/  item  i.kv-list
            ?.  ?&((lth x.p.item rmax) (lth y.p.item cmax))
              ::T - out of bounds - do not append
              %=  $
                kv-list  t.kv-list
              ==
              ::F  - in bounds - append to result
              %=  $
                result  (snoc `(list [coord tile])`result item)
                kv-list  t.kv-list
              ==
--
++  grab
  |%
  ++  noun  update
  --
++  grad  %noun
--