## Manual Test Checklist:

In this document, each test performed is listed.  

### TTT App:

[V]  |nuke and |revive, successful Arvo bind.
[V]  Make a get request, and FE sub works.
[V]  Start a new game. State is initialized correctly.
[V]  Make a few moves, check that state difference is OK, and the FE updates.
[V]  Make a non-board change move. Does wrapper ignore upstate request?
[V]  Make another move, after non-move. Does the FE update?
[V]  Make an illegal move (wrong player). What happens?
[V]  Do a half board move twice.
[V]  Do a full board move twice.
[V]  Set a new game What happens?
[V]  Do one more half board move.

If new game made and display gives a warning,
player must refresh the page.

How can the player rebind the board? GET request.

One issue:  Between bunting and newgame, the board does not update.
Player has to make another get request.

Check-diff is overkill, but it stops non-moves from being sent to FE currently.
This can be refined later.

### Mines App:

[V]  |nuke and |revive, successful Arvo bind.
[V]  Make a get request, and FE sub works. Get message about %starting a new game
[V]  Start a new game that is too big. Get a message about shrinking the board
[V]  Start a normal sized game.
[V]  Refresh page, check board loads.
[V]  Test board until you get a space fill move.
[V]  Now start a new game of a different size. Test a space. Do you get a message about the board being resized?
[V]  Refresh the page, check the board loads correctly.
[V]  Play the game until a win/lose occurs.
[V]  Try ranboard mode=1
[V]  Try ranboard mode=0

In general, the player reloads the page if they change the board size midgame, 
make a board >= 20 in size, or if they have booted without a %start.
