##  %wui - Web User Interface

July 1st, 2024
Reward: 2 Stars
ID: ???
Grantee:  ~nodsup-halnux
Champion: ~tamlut-modnys

##  Description:

For the new App School curriculum and Docs website, students will iteratively build a board games as they learn how urbit apps are constructed. Currently, the method of debugging and printing out to terminal (as a form of app interaction) is non-optimal.  

We propose a Web-User-Interface (WUI) to assist students in their Gall app projects.  More specifically, students will use WUI as a wrapper library around their Tic-Tac-Toe and Minesweeper apps, which will display the state of their app via a Sail webpage.


###  Implementation Details:

WUI will...

    • WUI will be implemented as a library file.
    • It will follow the same functionality as the +dbug application – intercepting all interactions with the app, before acting on its own marks, or passing them onto the app.
    • bind a Sail page to a front-end URL, using an arvo card on initialization.
    • have separate library and structure files for each board.
    • implements a basic http-server in its on-poke arm. Each page served back will be rendered as a card, and sent through Eyre.
    • be represented as a separate library file, per game app (minesweeper and tic-tac-toe).

###  User Requirements:

Students should...

    • be provided with a wrapper library that they can download, and should be able to wrap their game applications with one %- gate call.
    •  be able to play game boards that are of any rectangular shape (minesweeper only).
    •  be able to display boards that are upto 20 x 20 in size (minesweeper only).
    •  have a basic structure file provided to them, to standardize app development for the course.
    •  may extend game state by adding their own fields (they must not alter existing fields, however).
    • be able to use the +dbug library (the wrapper must function while being wrapped by +dbug).


Overall, the WUI libraries should make it easy for students to test their game apps, while standardizing homework solutions for instructors. Both parties can devote more time to Gall app development, and less time to development minutiae.


###  Other Requirements:

After completion of Minesweeper and Tic-Tac-Toe WUI wrappers,  the Grantee must assist with:

    •  helping the Champion with the documentation of both libraries, for docs.urbit.org website.
    •  address any student questions (provide a point of contact), when libraries are used in the next App School cohort.
    •  provide adjustments to the two said libraries, if other users discover bugs.
    •  provide minor adjustments to the libraries (within scope), as teaching requirements change in the future.

