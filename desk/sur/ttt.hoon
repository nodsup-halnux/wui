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
+$  dims  [rows=@ud cols=@ud]
+$  coord  [x=@ud y=@ud]
::  An X, an O or Empty (E)
+$  tokentype  $?  %x  %o  %e  ==
+$  square  [mark=tokentype]
+$  boardrow  (list tokentype)
+$  board  (list boardrow)
+$  boardmap  (map coord square)
::For players
:: Dont even need player data. Make it simple!
::+$  player  [name=@p pnum=@ud token=tokentypes colour=colours]
::+$  playerinfo  (map @ud player)
::+$  playerorder  (map @p @ud)
--