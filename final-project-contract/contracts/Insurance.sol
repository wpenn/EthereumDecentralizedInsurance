pragma solidity >= 0.4.22 < 0.7.0;

import "./provableAPI.sol";

contract Insurance is usingProvable {
    //api
    uint public gasPriceUSD; //TODO: oracle api will dictate this variable
    bytes32 public provableQueryId;
    
    //contract terms
    uint256 predictedPrice;
    uint256 toPayout; //Total winnings
    uint256 public expiryTime; // time the contract will end --> calls oracle query and automatically triggers the API call and payout
    uint256 public termAmount; //TODO: temporary variable for MVP -- premium/payout
    
    //addresses
    address payable public policyHolder; // address of the person b eing insured
    address payable public insurer; //address of the insurer
    
    //state of contract
    bool public proposed;
    bool public boughtIn;
    
    constructor() public{
        gasPriceUSD = 0;
        
        predictedPrice = 0;
        toPayout = 0;
        expiryTime = 0;
        termAmount = 0;
        
        policyHolder = address(0);
        insurer = address(0);
        
        proposed = false;
        boughtIn = false;
        
        provableQueryId = bytes32(0);
    }
    
    function proposeContract(uint256 _predictedPrice, uint256 _queryDelay) public payable {
        require(!proposed, "contract already proposed");
        require(msg.value > 0, "You need to put in some ether");
        policyHolder = msg.sender;
        termAmount = msg.value;
        toPayout = termAmount;
        predictedPrice = _predictedPrice;
        
        // expiryTime = now + _queryDelay; //TODO: need to figure out how to deal with expire time
        expiryTime = _queryDelay;
        
        proposed = true;
    }
    
    function buyIn() public payable {
        require(proposed, "You need someone to propose a contract");
        require(msg.value == termAmount, "You need to put in the same amount of ether");
        //require(msg.sender != policyHolder, "You can't buy into the contract if you proposed it."); //Remove for testing purposes
        insurer = msg.sender;
        toPayout = toPayout + msg.value;
        
        boughtIn = true;
        
        //Oracle API call
//      uint queryDelay = expiryTime - now; //TODO
        uint queryDelay = 0;
        provableQueryId = provable_query(queryDelay, "URL", "xml(https://www.fueleconomy.gov/ws/rest/fuelprices).fuelPrices.regular");
    }
    
    function __callback(bytes32 _myid, string memory _result) public {
        require(msg.sender == provable_cbAddress());
        gasPriceUSD = parseInt(_result, 2);
        
        if (gasPriceUSD > predictedPrice) { //TODO
            policyHolder.transfer(toPayout);
        } else {
            insurer.transfer(toPayout);
        }
        clearContract();
    }
    
    function clearContract() private{
        predictedPrice = 0;
        toPayout = 0;
        expiryTime = 0;
        termAmount = 0;
        
        policyHolder = address(0);
        insurer = address(0);
        
        proposed = false;
        boughtIn = false;
    }
}