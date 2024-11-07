# Brainstorming (11/5)

* Anthony: main
    - takes the initial time
    - contains event loop getting input, processing, and render_board()
    - processing includes changing another matrix of binary values that decides which cells are shown
    - a third matrix stores numbers as is, with expressions being their number values. This matrix is used to check equivalence
    - event loop stops if check_win() is true

### Methods

* Theo: render_board - prints the game board given the first address of matrix and the initial time
    - the matrix it uses for printing can be treated as ascii values, but don't print leading zeroes
    - also print the time elapsed since the initial time
* Anthony: parse_input - takes a string (or two numbers) and return the address of the cells within the matrix
* Theo: set_matrix - takes addresses of cells, changes the binary matrix based on the equivalence matrix
* Anthony: check_win - returns true if the binary matrix is all 1s
