|%
  +$  action
    $%  [%newgame ~]
        ::  for a move, we specify who is next. This is
        ::  compared against app state for verification.
        [%move r=@ud c=@ud next=psymbol]
        ::  [!!!] In the final version, these will be removed.
        ::  These are to test the FE and app.
        [%donothing ~]
        [%setboardtest1 ~]
        [%setboardtest2 ~]
        [%halfboard1 ~]
        [%halfboard2 ~]
    ==
  ::these are respones sent by BE to FE client.
  +$  update  
    ::  Doing a GET request in Browser will always load 
    ::  the entire board, based on current state.
      ::Sent only for sub request (spawned by GET)
    $%  [%init ack=@ud]
        ::  Note that for an upstate update to the FE,
        :: we care about who just moved, not who is next.
        :: The FE will infer who is next itself, but updating
        :: the status area.
        [%upstate gstat=ssymbol who=psymbol ourmap=boardmap]
  ==
  ::  An (X), an (O), and (E) for an empty square.
  +$  tsymbol  $?  %x  %o  %e  ==
  ::  Player 1 uses X's and Player 2 uses O's.
  +$  psymbol  $?  %p1x  %p2o  ==
  ::  Player 1 has won, Player 2 has won, it's a draw, 
  ::  or the game continues.
  +$  ssymbol  $?  %p1win  %p2win  %draw  %cont  ==
  ::  Board dimensions. Always 3 x 3. Rememember that
  ::  list indexes start from zero.
  +$  dims  [rows=@ud cols=@ud]
  +$  coord  [r=@ud c=@ud]
  ::  A more meaningful reference for our map.
  +$  square  tsymbol
  ::  This reprsents our ttt board.
  +$  boardmap  (map coord square)
  ::  Note 1:  For Gall App development, devs do *not*
  ::  normally place there app state structure in /sur
  ::  this is done to help our display wrapper function.
  ::  Note 2:  You can add fields to this structure
  ::  for your app, do not change the default fields.
+$  appstate  $:  
                %0 
                board=boardmap 
                bsize=dims 
                next=psymbol
                moves=@ud
                status=ssymbol
              ==
--