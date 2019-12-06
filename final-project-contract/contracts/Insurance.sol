pragma solidity >= 0.4.22 < 0.7.0;

import "./provableAPI.sol";

contract Insurance is usingProvable {
    //api
    string APIKEY = "{YOUR-API-KEY}"; // https://openweathermap.org/
    uint public tempReturned;
    bytes32 provableQueryId;
    
    //contract terms
    uint256 predictedTemp;
    uint256 toPayout; //Total winnings
    uint256 proposedDelay; // time the contract will end
    uint256 public payoutAmount; //Insurer Contribution
    uint256 public premiumAmount; //Policy holder contribution
    string public zipcode; //Zipcode location
    
    //addresses
    address payable policyHolder; // address of the person b eing insured
    address payable insurer; //address of the insurer
    
    //state of contract
    bool public proposed;
    bool public boughtIn;
    uint256 timeOfProposal;
    
    bool public policyHolderProposedKill; //Mechanism to kill contract
    bool public insurerProposedKill;
    
    constructor() public{
        tempReturned = 0;
        provableQueryId = bytes32(0);
        
        predictedTemp = 0;
        toPayout = 0;
        proposedDelay = 0;
        payoutAmount = 0;
        premiumAmount = 0;
        zipcode = "";
        
        policyHolder = address(0);
        insurer = address(0);
        
        proposed = false;
        boughtIn = false;
        timeOfProposal = 0;
        
        policyHolderProposedKill = false;
        insurerProposedKill = false;
    }
    
    function proposeContract(string memory _zipcode, uint256 _predictedTemp, uint256 _proposedDelay, uint256 _payoutAmount) public payable {
        require(!proposed, "contract already proposed");
        require(msg.value > 0, "You need to put in some ether");
        policyHolder = msg.sender;
        premiumAmount = msg.value;
        payoutAmount = _payoutAmount;
        toPayout = premiumAmount;
        predictedTemp = _predictedTemp;
        zipcode = _zipcode;
        
        proposedDelay = _proposedDelay;
        
        proposed = true;
        timeOfProposal = now;
    }
    
    function buyIn() public payable {
        require(proposed, "You need someone to propose a contract");
        require(!isContractExpired(), "Contract has expired, to return value from escrow please call proposeContractKill.");
        require(msg.value == payoutAmount, "You need to put in the same amount of ether as the contract requireds");
        require(msg.sender != policyHolder, "You can't buy into the contract if you proposed it."); //TODO: Remove for testing purposes
        insurer = msg.sender;
        toPayout = toPayout + payoutAmount;
            
        boughtIn = true;
            
        //Oracle API call
        uint256 secondsToExpiration = (timeOfProposal + proposedDelay) - now; //time until contract expires in seconds
        string memory restCall = string(abi.encodePacked("json(http://api.openweathermap.org/data/2.5/weather?zip=", string(zipcode), ",us&APPID=", APIKEY, ").main.temp"));
        provableQueryId = provable_query(secondsToExpiration, "URL", restCall); //TODO: change url when replacing API
    }
    
    function __callback(bytes32 _myid, string memory _result) public { //Oracle native function (Oracle rest call returning information to contract)
        require(msg.sender == provable_cbAddress());
        tempReturned = parseInt(_result, 2);
        
        if (toPayout > address(this).balance) { //REVIEW
            toPayout = address(this).balance;
        }
        if (tempReturned > predictedTemp) { //TODO: fix statements with new api
            policyHolder.transfer(toPayout);
        } else {
            insurer.transfer(toPayout);
        }
        clearContract();
    }
    
    function clearContract() private{
        predictedTemp = 0;
        toPayout = 0;
        proposedDelay = 0;
        payoutAmount = 0;
        premiumAmount = 0;
        zipcode = "";
        
        policyHolder = address(0);
        insurer = address(0);
        timeOfProposal = 0;
        
        proposed = false;
        boughtIn = false;
        
        policyHolderProposedKill = false;
        insurerProposedKill = false;
    }
    
    function isContractExpired() public view returns(bool) {
        require(proposed || boughtIn, "Contract is empty");
        uint256 timeOfExpiration = timeOfProposal + proposedDelay;
        return now >= timeOfExpiration;
    }
    
    function pruposeContractKill() public payable {
        require(proposed || boughtIn, "Contract is empty");
        require(msg.sender == policyHolder || msg.sender == insurer, "You are not authorized to kill the contract");
        if (msg.sender == policyHolder) {
            policyHolderProposedKill = true;
        } else if (msg.sender == insurer) {
            insurerProposedKill = true;
        }
        
        if (proposed && boughtIn) { //Contract is in play
            if (insurerProposedKill && policyHolderProposedKill || isContractExpired()) { //both parties proposed kill (or contract is expired => hopefully never reaches this)
                require(premiumAmount + payoutAmount < address(this).balance, "Contract needs more gas to kill and return ether."); //REVIEW
                policyHolder.transfer(premiumAmount);
                insurer.transfer(payoutAmount);
                clearContract();
            }
        } else if (proposed) {
            require(premiumAmount < address(this).balance, "Contract needs more gas to kill and return ether."); //REVIEW
            policyHolder.transfer(premiumAmount);
            clearContract();
        }
    }
}