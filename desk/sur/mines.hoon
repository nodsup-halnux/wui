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
      ::playing=_| ??
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
      ::  These two states have been added, to assist
      ::  In debugging. Also, the game app isn't finished.
      [%check-win ~]   ::  flag and test call this.
      [%set-playing stat=status]
  ==
--
