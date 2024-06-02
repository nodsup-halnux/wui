|%
+$  action
  :: [!!!] Test and Print state need to be removed, with testfe
  $%  [%newgame ~]
      [%move r=@ud c=@ud next=psymbol]
      [%testfe player=psymbol stat=ssymbol]
  ==
+$  update  ::these are respones sent by BE to FE client.
  $%  [%init ack=@ud]
      [%upstate gstat=ssymbol next=psymbol r=@ud c=@ud]
  ==
::  An (X), an (O), and (E) for an empty square.
+$  tsymbol  $?  %x  %o  %e  ==
::  Player 1 uses X's and Player 2 uses O's
::  This structure uses @tas'es to represent whose turn it is.
+$  psymbol  $?  %p1x  %p2o  ==
::  Player 1 has won, Player 2 has won, 
::  it's a draw, or the game continues.
+$  ssymbol  $?  %p1win  %p2win  %draw  %cont  ==
::  Board dimensions. Always 3 x 3. Rememember that
:: list indexes start from zero.
+$  dims  [rows=@ud cols=@ud]
+$  coord  [r=@ud c=@ud]
::  A more meaningful reference for our map.
+$  square  tsymbol
::  This reprsents our ttt board.
+$  boardmap  (map coord square)
::  Note (!):  For Gall App development, devs do *not*
::  normally place there app state structure in /sur
::  this is done to help our display wrapper function.
+$  appstate  $:  
                %0 
                board=boardmap 
                bsize=dims 
                currplayer=psymbol
                moves=@ud
                status=ssymbol
              ==
--