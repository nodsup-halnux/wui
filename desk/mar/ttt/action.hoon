/-  *ttt
|_  act=action
++  grow
  |%
  ++  noun  act
  --
++  grab
  |%
  ++  noun  action
  ++  json
    =,  dejs:format
    |=  jon=json
    ^-  action
    %.  jon
    %-  of
    :~ 
        [%teststate (se %p)]
        [%clearstate (se %p)]
    ==
  --
++  grad  %noun
--