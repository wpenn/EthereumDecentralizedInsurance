pragma solidity >= 0.4.22 < 0.7.0;

import "./provableAPI.sol";

contract Insurance is usingProvable {
    //api
    uint public gasPriceUSD; //TODO: Remove when replacing API
    bytes32 public provableQueryId;
    
    //contract terms
    uint256 predictedPrice;
    uint256 toPayout; //Total winnings
    uint256 proposedDelay; // time the contract will end
    uint256 public payoutAmount; //Insurer Contribution
    uint256 public premiumAmount; //Policy holder contribution
    string public zipcode; //Zipcode location
    
    //addresses
    address payable public policyHolder; // address of the person b eing insured
    address payable public insurer; //address of the insurer
    
    //state of contract
    bool public proposed;
    bool public boughtIn;
    uint256 public timeOfProposal; //TODO: remove public after testing
    
    bool public policyHolderProposedKill; //Mechanism to kill contract
    bool public insurerProposedKill;
    
    constructor() public{
        gasPriceUSD = 0; //TODO: remove when replacing API
        provableQueryId = bytes32(0);
        
        predictedPrice = 0;
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
    
    function proposeContract(string memory _zipcode, uint256 _predictedPrice, uint256 _proposedDelay, uint256 _payoutAmount) public payable {
        require(!proposed, "contract already proposed");
        require(msg.value > 0, "You need to put in some ether");
        policyHolder = msg.sender;
        premiumAmount = msg.value;
        payoutAmount = _payoutAmount;
        toPayout = premiumAmount;
        predictedPrice = _predictedPrice;
        zipcode = _zipcode;
        
        proposedDelay = _proposedDelay;
        
        proposed = true;
        timeOfProposal = now;
    }
    
    function buyIn() public payable {
        require(proposed, "You need someone to propose a contract");
        require(!isContractExpired(), "Contract has expired, to return value from escrow please call proposeContractKill.");
        require(msg.value == payoutAmount, "You need to put in the same amount of ether as the contract requireds");
        require(msg.sender != policyHolder, "You can't buy into the contract if you proposed it."); //Remove for testing purposes
        insurer = msg.sender;
        toPayout = toPayout + payoutAmount;
            
        boughtIn = true;
            
        //Oracle API call
        uint256 secondsToExpiration = (timeOfProposal + proposedDelay) - now; //time until contract expires in seconds
        string memory restCall = string(abi.encodePacked("json(http://api.openweathermap.org/data/2.5/weather?zip=", string(zipcode), ",us&APPID=201d8f5eb38a067fce3ba183d9826aed).main.temp"));
        provableQueryId = provable_query(secondsToExpiration, "URL", restCall); //TODO: change url when replacing API
    }
    
    function __callback(bytes32 _myid, string memory _result) public { //Oracle native function (Oracle rest call returning information to contract)
        require(msg.sender == provable_cbAddress());
        gasPriceUSD = parseInt(_result, 2);
        
        if (toPayout > address(this).balance) { //REVIEW
            toPayout = address(this).balance;
        }
        if (gasPriceUSD > predictedPrice) { //TODO: fix statements with new api
            policyHolder.transfer(toPayout);
        } else {
            insurer.transfer(toPayout);
        }
        clearContract();
    }
    
    function clearContract() private{
        predictedPrice = 0;
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