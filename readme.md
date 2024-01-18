## TWUI: Terminal and Web User Interface:

This repository documents an API and implementation for a generic 
interface library to be  used with Urbit Gall Apps. 

In its most basic form, this library designed to display the state of a 
gameboard app for App Academy project work, with a goal of exposing
minimal overhead and code boilerplate to students.  

Much of the underlying functionality can be used for other app GUI 
requirements, however.



###  Gameboard Format:

The library is designed to scry a user's Gall App state, and then 
display it accordingly - with a minimum number of user inputs supplied
(the user just has to set it up once). 

In order to facilitate this requirement, users must adhere to a specific
gameboard format. Two Formats are proposed below:

The following common assumptions are made, about the kinds of gameboards
that may be represented:

- Board has a specific *width* and *height*. 
	- It has a rectangular shape, with no gaps.
	- A board is made up of squares.
- There are *K* types of squares.
- There are *N* number of players.
- There are *M* kinds of game pieces (or objects).
- There is a player ordering, and a mapping of player number to player 
objects
- Player Objects contain various pieces of information, including name,
 and piece data (number of pieces, which pieces are owned, captured, etc).
- There is some kind of mapping of pieces to board positions.

An implementation of such a state is below:

####  Direct Format:


```
+$  boarddims  [rows=@ud cols=@ud]
+$  squaretypes  $?  %grass  %water  %forest  %bog  ==
+$  houses  $?  %red  %green  %blue  %yellow  ==
+$  tokentypes  $?  %mage  %cleric  %knight  %peon  %none  ==
+$  ptagtoken [pname=@p ttype=tokentypes]
+$  boardsquare  [stype=squaretypes ptt=ptagtoken]
+$  boardrow  (list boardsquare)
+$  board  (list boardrow)
::For players
+$  player  [name=@p pnum=@ud house=houses]
+$  playerinfo  (map @ud player)
+$  playerorder  (map @p @ud)
```

with our `board` object (for a 2 x 2 board), looking as follows:

```
~[ 
	~[ 	[stype=%grass ptt=[pname=@zod ttype=%cleric]]
		[stype=%water ptt=[pname=@fes ttype=%mage]]
		
	~[ 	[stype=%forest ptt=[pname=@zod ttype=%knight]]
		[stype=%bog ptt=[pname=@fes ttype=%peon]]
]
```

#### Alternative format:

We can shorten our structures as follows. Instead of specifying 
dimension cells - and all sorts of bounds - we can simply have a map
from board-coordinates to a cell strucutre. The bounds are implicit
in that we just have a (list (list [struct])) to traverse as normal.

An example of such a format is below:

```
+$  coordinate [row=@ud col=@ud]
+$  squaretypes  $?  %grass  %water  %forest  %bog  ==
+$  tokentypes  $?  %mage  %cleric  %knight  %peon  %none  ==
+$  tlist  (list tokentypes)
+$  boardsquare  [stype=boardsquare tl=tlist]
+$  board  (map coordinate boardsquare)

```

And a 2 x 2 board example (using similar player structures as before)
can be seen below:

```
~[ 
	~[ 	[stype=%grass tl=[%knight %knight ~]]
		[stype=%water tl=[%cleric ~]]
		
	~[ 	[stype=%forest tl=[%peon %peon %peon ~]]
		[stype=%bog tl=[%mage %knight ~]]
]


```

In general, either of the two strucutres formats can be used for our
library.  As long as the sub-structures (for pieces and tiles and players)
is properly defined, we should be able to produce a ;* loop in Sail,
or a |- trap in tui to render our results to the user.














