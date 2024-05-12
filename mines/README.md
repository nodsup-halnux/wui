#   `%mines`

To start a game:

```hoon
:mines &mines-action [%start [10 10] 5]
```

To flag a square:

```hoon
:mines &mines-action [%flag [5 5]]
```

To probe a square:

```hoon
:mines &mines-action [%test [7 3]]
```

To view the board:

```hoon
:mines &mines-action [%view ~]
```

To debug view the underlying minefield:

```hoon
:mines &mines-action [%debug ~]
```

---

```
> :mines &mines-action [%start [10 10] 8]

> :mines &mines-action [%debug ~]
" 0 0 1 × 1 0 1 × 1 0 "
" 0 0 1 1 1 0 1 1 1 0 "
" 0 0 0 1 1 1 0 1 1 1 "
" 0 0 1 2 × 1 0 1 × 1 "
" 0 0 1 × 3 2 0 1 2 2 "
" 0 0 2 3 × 1 0 0 1 × "
" 0 0 1 × 2 1 0 0 1 1 "
" 0 0 1 1 1 0 0 0 0 0 "
" 0 0 0 0 0 0 0 0 0 0 "
" 0 0 0 0 0 0 0 0 0 0 "

> :mines &mines-action [%test [1 1]]
>   "testing [x=1 y=1]"
>   'Hit an empty tile, searching for borders'

> :mines &mines-action [%view ~]
" 0 0 1 . 1 0 1 . . . "
" 0 0 1 1 1 0 1 1 . . "
" 0 0 0 1 1 1 0 1 . . "
" 0 0 1 2 . 1 0 1 . . "
" 0 0 1 . . 2 0 1 2 . "
" 0 0 2 . . 1 0 0 1 . "
" 0 0 1 . 2 1 0 0 1 1 "
" 0 0 1 1 1 0 0 0 0 0 "
" 0 0 0 0 0 0 0 0 0 0 "
" 0 0 0 0 0 0 0 0 0 0 "
```
