  ::  /app/mines
::::  Version ~2023.12.14
::    ~lagrev-nocfep and ~tamlut-modnys
::
/-  *mines
/+  dbug,
    default-agent
::
|%
+$  versioned-state
  $%  state-zero
  ==
+$  state-zero
  $:  %zero
      game-state
  ==
+$  card  card:agent:gall
--
%-  agent:dbug
=|  state-zero
=*  state  -
^-  agent:gall
|_  =bowl:gall
+*  this     .
    default  ~(. (default-agent this %|) bowl)
++  on-init   on-init:default
++  on-save   !>(state)
++  on-load
  |=  old=vase
  ^-  [(list card) _this]
  :-  ^-  (list card)
      ~
  %=  this
    state  !<(state-zero old)
  ==
++  on-poke
  |=  [=mark =vase]
  ^-  [(list card) _this]
  ?>  ?=(%mines-action mark)
  =/  act  !<(action vase)
  ?-    -.act
      %start
    |^
    =.  mines  (lay-mines coord.act n.act)
    =.  neighbors  *^neighbors
    =.  tiles  *^tiles
    =.  playing  %.y
    :-  ~
    %=  this
      neighbors  get-neighbors
      dims   coord.act
    ==
    ::  Generate random coordinate pairs
    ++  lay-mines
      |=  [dims=coord n=@]
      ^-  ^mines
      =/  rng  ~(. og eny.bowl)
      =|  mines=(set coord)
      |-  ^-  (set coord)
      ?:  =(n ~(wyt in mines))  mines
      =^  tx  rng  (rads:rng x.dims)
      =^  ty  rng  (rads:rng y.dims)
      $(mines (~(put in mines) [tx ty]))
    ++  get-neighbors
      ^-  ^neighbors
      :: =.  neighbors
      =/  mines  ~(tap in mines)
      |-
      ?~  mines  neighbors
      $(neighbors (count-neighbors i.mines), mines t.mines)
    ++  count-neighbors
      |=  =coord
      ^-  ^neighbors
      =/  coords=(list ^coord)
        %~  tap  in
        ^-  (set ^coord)
        %-  silt
        ^-  (list ^coord)
        :~  :-  (dec x.coord)         (dec y.coord)
            :-  (dec x.coord)              y.coord
            :-  (dec x.coord)         (inc y.coord y.dims)
            :-       x.coord          (dec y.coord)
        ::  :-       x.coord               y.coord
            :-       x.coord          (inc y.coord y.dims)
            :-  (inc x.coord x.dims)  (dec y.coord)
            :-  (inc x.coord x.dims)       y.coord
            :-  (inc x.coord x.dims)  (inc y.coord y.dims)
        ==
      |-
      ?~  coords  neighbors
      =/  value  (~(gut by neighbors) i.coords %0)
      $(neighbors (~(put by neighbors) i.coords ;;(num +(value))), coords t.coords)
    ++  dec
      |=  p=@
      ^-  @
      ?:(=(0 p) 0 (^dec p))
    ++  inc
      |=  [p=@ q=@]
      ^-  @
      ?:(=(q p) q +(p))
    --
    ::
      %flag
    |^
    ?>  playing
    ?>  &((lth x.coord.act x.dims) (lth y.coord.act y.dims))
    :-  ~
    %=  this
      tiles  (toggle-flag coord.act)
    ==
    ::  Toggle flag
    ++  toggle-flag
      |=  =coord
      ^-  ^tiles
      =/  tile  (~(gut by tiles) coord %hide)
      ?:  =(%flag tile)
        :: toggle it off
        (~(del by tiles) coord)
      ?:  =(%hide tile)
        :: toggle it on
        (~(put by tiles) coord %flag)
      ::  TODO check win condition
      tiles
    --
    ::
      %test
    |^
    ?>  playing
    ?>  &((lth x.coord.act x.dims) (lth y.coord.act y.dims))
    ~&  >  "testing {<coord.act>}"
    :-  ~
    %=  this
      tiles  (test coord.act)
    ==
    ++  test
      |=  =coord
      ^-  ^tiles
      =/  tile  (~(gut by tiles) coord %hide)
      ?+    tile  ~|(%bad-test tiles)
          ?(%0 %1 %2 %3 %4 %5 %6 %7 %8)
        ~&  >>  'Already seen'
        tiles
          %flag
        ~&  >>  'Untoggle the flag first'
        tiles
          %hide
        ?:  (~(has in mines) coord)
          ~&  >>>  'You stepped on a mine'
          :: TODO trigger game over
          =.  playing  %.n
          (~(put by tiles) coord %mine)
        ?:  (~(has by neighbors) coord)
          (~(put by tiles) coord `^tile`(~(got by neighbors) coord))
        :: fallthrough case, found an empty non-neighbor so flood search
        ~&  >  'Hit an empty tile, searching for borders'
        (flood coord)
      ==
    ::  This is straightforward stack-based recursive eight-way flood fill.
    ++  flood
      |=  =coord
      ^+  tiles
      ?.  =(%0 (~(gut by neighbors) coord %0))
        (~(put by tiles) coord (~(got by neighbors) coord))
      =.  tiles  (~(put by tiles) coord %0)
      =/  coords  ~(tap in (get-neighbors coord))
      |-
      ?~  coords  tiles
      =?  tiles  !(~(has by tiles) i.coords)  (flood i.coords)
      $(coords t.coords)
    ++  get-neighbors
      |=  =coord
      ^-  (set ^coord)
      %-  silt
      ^-  (list ^coord)
      :~  :-  (dec x.coord)         (dec y.coord)
          :-  (dec x.coord)              y.coord
          :-  (dec x.coord)         (inc y.coord y.dims)
          :-       x.coord          (dec y.coord)
      ::  :-       x.coord               y.coord
          :-       x.coord          (inc y.coord y.dims)
          :-  (inc x.coord x.dims)  (dec y.coord)
          :-  (inc x.coord x.dims)       y.coord
          :-  (inc x.coord x.dims)  (inc y.coord y.dims)
      ==
    ++  dec
      |=  p=@
      ^-  @
      ?:(=(0 p) 0 (^dec p))
    ++  inc
      |=  [p=@ q=@]
      ^-  @
      ?:(=(q p) q +(p))
    --
    ::
      %view
    =|  i=@
    =|  j=@
    =/  out    *tang
    =/  qrose  *(list tank)
    |-
    ?:  (gte j y.dims)
      =/  rose  `tank`[%rose [" " " " " "] (flop qrose)]
      %=  $
        i      +(i)
        j      0
        out    `tang`[rose out]
        qrose  *(list tank)
      ==
    ?:  (gte i x.dims)
      =.  out  (flop out)
      |-
      ?~  out  [~ this]
      ~&  ~(ram re i.out)
      $(out t.out)
    =/  bit  (~(gut by tiles) [i j] %hide)
    =/  blit
      ?-  bit
        ?(%0 %1 %2 %3 %4 %5 %6 %7 %8)  (crip "{<`@`bit>}")
        %mine  '×'
        %flag  'F'
        %hide  '.'
      ==
    $(j +(j), qrose [blit qrose])
    ::
      %debug
    =|  i=@
    =|  j=@
    =/  out    *tang
    =/  qrose  *(list tank)
    |-
    ?:  (gte j y.dims)
      =/  rose  `tank`[%rose [" " " " " "] (flop qrose)]
      %=  $
        i      +(i)
        j      0
        out    `tang`[rose out]
        qrose  *(list tank)
      ==
    ?:  (gte i x.dims)
      =.  out  (flop out)
      |-
      ?~  out  [~ this]
      ~&  ~(ram re i.out)
      $(out t.out)
    =/  minelist  `(list (pair coord tile))`(turn ~(tap in mines) |=(=coord [coord %mine]))
    =/  bit  (~(gut by (~(gas by `(map coord tile)`neighbors) minelist)) [i j] %0)
    =/  blit
      ?-  bit
        ?(%0 %1 %2 %3 %4 %5 %6 %7 %8)  (crip "{<`@`bit>}")
        %mine  '×'
        %flag  'F'
      ==
    $(j +(j), qrose [blit qrose])
  ==  :: action
::
++  on-peek   on-peek:default
++  on-arvo   on-arvo:default
++  on-watch  on-watch:default
++  on-leave  on-leave:default
++  on-agent  on-agent:default
++  on-fail   on-fail:default
--
