## WUI: Web User Interface:

This repository documents an agent wrapper library 
to be  used with Urbit Gall Apps. 

This library designed to display the state of a 
gameboard app for App Academy project work, with a goal of exposing
minimal overhead and code boilerplate to students. 


###  Using the Library:

WUI is implemented as a pair of /lib and /sur files, which
are imported into a Gall App directory.

Currently, the library is split depending on the board game
a user wishes to play - either Tic-Tac-Toe or Minesweeper.
The files are named `ttt-wui` and `ms-wui`, respectively.

To use this library, setup your Tic-Tac-Toe or Minesweeper
desk as follows:

```
%yourapp
├── app
│   ├── yourappname.hoon
│   └── frontend
│        └──  display.hoon
│
├── lib
│   └── *-wui.hoon
│
├── sur 
│   └── *-wui.hoon
│
├── mar
│    └── action ...
│    └── update ...
│...
```

###  Gameboard Format:

In order to facilitate this requirement, users must adhere to a specific
gameboard format. Two Formats are proposed below:




#### How WUI works:

The core of this is based on the minimum implementation of the Squad App - in which we handle page serving (via Get Request) using the ++on-poke arm, and bind a basic url to our app using an Arvo call:  `(~(arvo pass:agentio /bind) %e %connect /'gameuis %gameuis)`

Essentially, students will navigate to the bound url via Landscape (example: http:localhost:8080/wui, running out of a fakezod), and simply refresh the page.  This will result in a GET request handled by the ++on-poke arm, which will run a Sail page (which generates our board as a $manx XML structure), which is tranformed into HTML that is sent back to the browser.

See the `/frontend/fe-board.hoon` and `gameuis.hoon` files in `/desk/gameuis/app/` for a sample of this code.
