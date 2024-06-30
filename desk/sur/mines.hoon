  ::  /sur/mines
::::  Version ~2023.12.14
::    ~lagrev-nocfep and ~tamlut-modnys
::
|%
+$  mines  (set coord)
+$  neighbors  (map coord num)
+$  tiles  (map coord tile)
+$  board  (list (list @tas))
::
+$  num   ?(%0 %1 %2 %3 %4 %5 %6 %7 %8)
+$  tile  ?(num %mine %flag)
+$  status  ?(%live %win %lose)
::
+$  game-state
  $:  =mines
      =neighbors
      =tiles
      dims=coord
      playing=status
      ::playing=_| ???
  ==
::
+$  coord  [x=@ y=@]
::
+$  action
  $%  [%flag =coord]       :: toggle flag
      [%test =coord]       :: reveal mine
      [%view ~]            :: display tiles (seen board)
      [%debug ~]           :: display whole board
      [%start =coord n=@]  :: start game
      ::  The below actions are for testing only.
      ::  These actions have been added, to assist
      ::  In debugging. 
      [%check-win ~]   
      :: random board 1 and 2. Just for harder FE testing.
      :: mode is 1 or 2 for mode.
      [%ranboard mode=@ud rc=coord stat=status]
      ::  do nothing move to test sig/no move logic.
      [%dn ~]
  ==
+$  update
      ::  Doing a GET request in Browser will always load 
    ::  the entire board, based on current state.
      ::Sent only for sub request (spawned by GET)
    $%  [%init ack=@ud]
        ::  FE only wants current tiles, game state,
        ::  and board size.
        [%upstate gstat=status bdims=coord tboard=tiles]
  ==
--
