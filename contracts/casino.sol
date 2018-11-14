pragma solidity 0.4.24;

import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

/// @title Contract to bet Ether for a number and win randomly when the number of bets is met.
/// @author Merunas Grincalaitis

contract Casino is usingOracalize {

    //owner address
    address public owner;

    //minimum allowed bet
    uint256 public minimumBet = 100 finney;

    //total ether bet for a current game
    uint256 public totalBet;

    //total number of bets made by users
    uint256 public numberOfBets;

    //MAX allowed bets to be made; to reduce gas consumption when distributing prize
    uint256 public maxAmountOfBets = 10;

    uint256 public constant limitBets = 100;

    //array of addresses
    address[] public players;

    //struct defining player; amount of ether bet and which number the player is betting on
    struct Player{
        uint256 amountBet;
        uint256 numberSelected;
    }

    //the number each player has bet on
    mapping(address => Player) public playerInfo;

    mapping (uint => address[]) public numberBetOn; 

    modifier onEndGame() {
        if (numberOfBets >= maxAmountOfBets) _;
    }

    constructor (uint256 _minimumBet, uint256 _maxAmountOfBets) public{
        owner = msg.sender;

        if (_minimumBet > 0)
            _minimumBet = minimumBet;
        if (_maxAmountOfBets > 0 && _maxA)
    }

    function makeBet() public payable {

    }

    function kill() public {
        if (msg.sender == owner) selfdestruct(owner);
    }
}