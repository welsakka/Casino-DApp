pragma solidity ^0.4.24;

//go to https://github.com/merlox/casino-ethereum to check out secure number generation

/// @title Contract to bet Ether for a number and win randomly when the number of bets is met.
/// @author Merunas Grincalaitis

contract casino {

    //owner address
    address public owner;

    //minimum allowed bet
    uint256 public minimumBet;

    //total ether bet for a current game
    uint256 public totalBet;

    //total number of bets made by users
    uint256 public numberOfBets;

    //MAX allowed bets to be made; to reduce gas consumption when distributing prize
    uint256 public maxAmountOfBets = 100;

    //array of addresses so we may iterate
    address[] public players;

    //struct defining player; amount of ether bet and which number the player is betting on
    struct Player{
        uint256 amountBet;
        uint256 numberSelected;
    }

    //info associated with a particular address
    mapping(address => Player) public playerInfo;

   constructor(uint256 _minimumBet) public {
      owner = msg.sender;
      if(_minimumBet != 0 ) minimumBet = _minimumBet;
   }

    //Checks if an address is listed in the players array
    function checkPlayerExists(address player) public view returns(bool){
        for (uint256 i = 0; i <= players.length; i++){
            if (players[i] == player) return true;
        }   
        return false;
    }

    function distributePrizes(uint256 _numberGenerated) public {
        address[100] memory winners; //temp array to store winner addresses
        uint256 counter = 0; //counter variable for winner array
        for (uint256 i = 0; i <= players.length; ++i){
            if (playerInfo[players[i]].numberSelected == _numberGenerated) {
                winners[counter] = players[i];
                ++counter; 
            }               
        }
        for (uint256 j = 0; j <= winners.length; ++j){
            if(winners[j] != address(0)) //check that address is not empty
                winners[j].transfer(totalBet / winners.length);
        }
    }

    //generate a random number between 1 and 10, inclusive 
    function generateNumberWinner() public {
        //takes current block number, modulo it by 10, add 1
        //ex current block is 128142 % 10 = 2 + 1 = 3
        uint256 numberGenerated = block.number % 10 + 1; // not secure, easy to cheat
        distributePrizes(numberGenerated);
    }

    function makeBet(uint256 _numberSelected) public payable {
        require(!checkPlayerExists(msg.sender));
        require(_numberSelected >= 1 && _numberSelected <= 10);
        require(msg.value >= minimumBet);
        playerInfo[msg.sender].amountBet = msg.value;
        playerInfo[msg.sender].numberSelected = _numberSelected;
        numberOfBets++;
        players.push(msg.sender);
        totalBet += msg.value;
        if (numberOfBets >= maxAmountOfBets) generateNumberWinner();
    }

    /*Fallback function in case someone sends ether to the contract
    so it doesn't get lost and to increase the treasury of this contract*/
    function () public payable {}

    function kill() public {
        if (msg.sender == owner) selfdestruct(owner);
    }
}