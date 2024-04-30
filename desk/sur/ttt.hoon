|%
+$  action
  $%  [%teststate ~]
      [%newgame ~]
      [%printstate ~]
      [%move r=@ud c=@ud ttype=tokensymbol]
      [%testfe current=playersymbol stat=statussymbol]
  ==
+$  update
  $%  [%init values=(list @)]
  ==
::  An X, an O or Empty (E)
:: %x is the X, %o is the O token, %e is an empty square
:: used for the boardmap
+$  tokensymbol  $?  %x  %o  %e  ==
::  player1 uses x's and player2 uses o's
::  used to signify whose turn it is.
+$  playersymbol  $?  %p1x  %p2o  ==
::  use to signifiy the game state.
::  p1 has won, p2 has won, its a draw, or game not finished
+$  statussymbol  $?  %p1win  %p2win  %draw  %cont  ==
+$  dims  [rows=@ud cols=@ud]
+$  coord  [r=@ud c=@ud]
+$  square  tokensymbol::[m=tokentype]
+$  boardmap  (map coord square)
+$  appstate  $:  
                %0 
                board=boardmap 
                bsize=dims 
                currplayer=playersymbol
                moves=@ud
                status=statussymbol
              ==
--