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

In order to implement both tools, the overall codebase must be implemented as a library - that will be imported by a student's Gall App. 

Appropriately, I name the library **"TWUI" or "Terminal & Web User Interface"**.

#### Board Game Renderer (in Terminal) "t-ui":

The board game terminal renderer will accessed via a gate call `(boardprint ... )`.

Practically, it will exist as a main gate call with a series of support arms.

Various parameters can be specified, or default values are used if a default structure is provided as input.  No board inputs are given in the game call, as our scry functionality should handle this automatically.

See the `/desk/gameuis/gen/tui.hoon` file for a basic sample.

#### Renderer (in Web Browser) "w-ui":

The core of this is based on the minimum implementation of the Squad App - in which we handle page serving (via Get Request) using the ++on-poke arm, and bind a basic url to our app using an Arvo call:  `(~(arvo pass:agentio /bind) %e %connect /'gameuis %gameuis)`

Essentially, students will navigate to the bound url via Landscape (example: http:localhost:8080/wui, running out of a fakezod), and simply refresh the page.  This will result in a GET request handled by the ++on-poke arm, which will run a Sail page (which generates our board as a $manx XML structure), which is tranformed into HTML that is sent back to the browser.

See the `/frontend/fe-board.hoon` and `gameuis.hoon` files in `/desk/gameuis/app/` for a sample of this code.





Questions:

1) Describe the new curriculum for ASL in brief.



2) Are the students developing one boardgame througout ASL, or many different board games?
    - I need some user stories here, to visualize what you want more.

3) Boardgame format has been finalized (map coordinate  -->  boardsquare)

4) Who is championing this grant?

5)  Is a wrapper library implementation (similar to +dbug) suitable for this?


WUI:  Usage of Sail FE to display the FE. Students will navigate to localhost:8080/<appname> and just refresh the page to view their current board.
    - 

TUI: A lot of gate logic to format a dill terminal, or custom usage of the %homunculus code. Not sure what...yet.
    - Neal's minesweeper.
	

