|%
+$  action
  :: [!!!] Test and Print state need to be removed, with testfe
  $%  [%teststate ~]
      [%newgame ~]
      [%printstate ~]
      [%move r=@ud c=@ud ttype=tokensymbol]
      [%testfe current=playersymbol stat=statussymbol]
  ==
:: [!!!]  Is an update pattern even needed?
+$  update
  $%  [%init values=(list @)]
  ==
::  An (X), an (O), and (E) for an empty square.
+$  tokensymbol  $?  %x  %o  %e  ==
::  Player 1 uses X's and Player 2 uses O's
::  This structure uses @tas'es to represent whose turn it is.
+$  playersymbol  $?  %p1x  %p2o  ==
::  Player 1 has won, Player 2 has won, 
::  it's a draw, or the game continues.
+$  statussymbol  $?  %p1win  %p2win  %draw  %cont  ==
::  Board dimensions. Always 3 x 3. Rememember that
:: list indexes start from zero.
+$  dims  [rows=@ud cols=@ud]
+$  coord  [r=@ud c=@ud]
::  A more meaningful reference for our map.
+$  square  tokensymbol
::  This reprsents our ttt board.
+$  boardmap  (map coord square)
::  Note (!):  For Gall App development, devs do *not*
::  normally place there app state structure in /sur
::  this is done to help our display wrapper function.
+$  appstate  $:  
                %0 
                board=boardmap 
                bsize=dims 
                currplayer=playersymbol
                moves=@ud
                status=statussymbol
              ==
--