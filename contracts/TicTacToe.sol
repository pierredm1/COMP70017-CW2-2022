pragma solidity ^0.4.24;
/**
 * @title TicTacToe contract
 **/
contract TicTacToe {
    address[2] public players;

    /**
     turn
     1 - players[0]'s turn
     2 - players[1]'s turn
     */
    uint public turn = 1;

    /**
     status
     0 - ongoing
     1 - players[0] won
     2 - players[1] won
     3 - draw
     */
    uint public status;

    /**
    board status
     0    1    2
     3    4    5
     6    7    8
     */
    uint[9] private board;

    // this private variable records the number of moves that have been played
    // and is used for checking the current status of the board and the draw
    uint private n_moves = 0;


    /**
      * @dev Deploy the contract to create a new game
      * @param opponent The address of player2
      **/
    constructor(address opponent) public {
        require(msg.sender != opponent, "No self play");
        players = [msg.sender, opponent];
    }

    /**
      * @dev Check a, b, c in a line are the same
      * _threeInALine doesn't check if a, b, c are in a line
      * @param a position a
      * @param b position b
      * @param c position c
      **/

    function _threeInALine(uint a, uint b, uint c) private view returns (bool){
        /*Please complete the code here.*/
        return (board[a] == board[b]) && (board[b] == board[c]);
    }

    /**
     * @dev get the status of the game
     * @param pos the position the player places at
     * @return the status of the game
     */
    function _getStatus(uint pos) private view returns (uint) {
        /*Please complete the code here.*/

        // VERTICAL COMBINATION
        uint ver_pos = pos % 3;
        if(_threeInALine(ver_pos,ver_pos+3,ver_pos+6)){
            return board[pos];
        }
        // HORIZONTAL COMBINATION
        uint hori_pos = pos / 3;
        if(_threeInALine(pos, hori_pos*3+(pos+1)%3, hori_pos*3+(pos+2)%3)){
            return board[pos];
        }

        //DIAGONAL COMBINATION
        if(pos%2==0 && board[4]!=0){
          if(_threeInALine(0, 4, 8) || _threeInALine(2, 4, 6))
          return board[pos];
        }

        // board is full (9)
        if(n_moves>=9)
          return 3;

        //if any other case then game is ongoing so 0
        return 0;
    }

    /**
     * @dev ensure the game is still ongoing before a player moving
     * update the status of the game after a player moving
     * @param pos the position the player places at
     */
    modifier _checkStatus(uint pos) {
        /*Please complete the code here.*/
        //check the status is ongoing, default value of uint is 0
        require(status== 0);
        _;
        n_moves+=1;
        //update status
        status = _getStatus(pos);
    }

    /**
     * @dev check if it's msg.sender's turn
     * @return true if it's msg.sender's turn otherwise false
     */
    function myTurn() public view returns (bool) {
        /*Please complete the code here.*/
        return players[turn-1] == msg.sender;
    }

    /**
     * @dev ensure it's a msg.sender's turn
     * update the turn after a move
     */
    modifier _myTurn() {
        /*Please complete the code here.*/
        require(myTurn());
        _;
        //update turn
        if(turn == 1){
            turn = 2;
        }else{
            turn = 1;
        }
    }

    /**
     * @dev check a move is valid
     * @param pos the position the player places at
     * @return true if valid otherwise false
     */
    function validMove(uint pos) public view returns (bool) {
      /*Please complete the code here.*/
        if(board[pos] == 1 || board[pos] == 2){
            return false;
        }
        return true;
    }

    /**
     * @dev ensure a move is valid
     * @param pos the position the player places at
     */
    modifier _validMove(uint pos) {
        /*Please complete the code here.*/
        require(pos>=0);
        require(pos<9);
        require(board[pos]!= 1);
        require(board[pos]!= 2);
        _;
    }

    /**
     * @dev a player makes a move
     * @param pos the position the player places at
     */
    function move(uint pos) public _validMove(pos) _checkStatus(pos) _myTurn {
        board[pos] = turn;
    }

    /**
     * @dev show the current board
     * @return board
     */
    function showBoard() public view returns (uint[9]) {
        return board;
    }
}
