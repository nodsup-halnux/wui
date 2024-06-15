## Manual Test Checklist:

In this document, each test performed is listed.  


### TTT App:

[V]  Make a get request, and arvo bind works.
[V]  Start a new game. State is initialized correctly.
[V]  Make a few moves, check that state difference is OK, and the FE updates.
[V]  Make a non-board change move. Does wrapper ignore upstate request?
[V]  Make another move, after non-move. Does the FE update?
[V]  Make an illegal move (wrong player). What happens?
    => App poke fails.
[X]  Reset the board half-way through the game. What happens?
    => Board does not reflect state, as we only send one move
    at a time. Player must make another GET request.

#### Tests that don't work:

[]  Player resets the board half-way through game.
[]  Player completely reconfigures the board.

In both cases, the player must re-bind the FE to BE - 
as upstate only transmit one move at a time.


### Mines App:


####