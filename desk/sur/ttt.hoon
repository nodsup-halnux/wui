|%
+$  action
  $%  [%teststate target=@p]
      [%clearstate target=@p]
  ==
+$  update
  $%  [%init values=(list @)]
  ==
+$  page  [sect=@t success=?]
::Rudimentary board structures
+$  boarddims  [rows=@ud cols=@ud]
::  An X, an O or Empty (E)
+$  tokentype  $?  %x  %o  %e  ==
+$  boardsquare  [ppiece=tokentype]
+$  boardrow  (list boardsquare)
+$  board  (list boardrow)
::For players
:: Dont even need player data. Make it simple!
::+$  player  [name=@p pnum=@ud token=tokentypes colour=colours]
::+$  playerinfo  (map @ud player)
::+$  playerorder  (map @p @ud)
--