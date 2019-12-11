pragma solidity >= 0.4.22 < 0.7.0;

import "./provableAPI.sol";

contract Insurance is usingProvable {
    //api
    string APIKEY = "{YOUR-API-KEY}"; // https://openweathermap.org/
    uint public tempReturned;
    bytes32 provableQueryId;
    
    //contract terms
    uint256 predictedTemp;//Threshold for temperature parameter
    uint256 toPayout; //Total winnings
    uint256 proposedDelay; // time the contract will end
    uint256 public payoutAmount; //Insurer Contribution
    uint256 public premiumAmount; //Policy holder contribution
    string public zipcode; //Zipcode location
    
    //addresses
    address payable policyHolder; // address of the person b eing insured
    address payable insurer; //address of the insurer
    
    //state of contract
    bool public proposed; //Has contract been proposed
    bool public boughtIn; //Has an insurer decided to buy into the contract
    uint256 timeOfProposal; //The timestamp of when the contract was proposed
    
    bool public policyHolderProposedKill; //Mechanism to kill contract (policyholder)
    bool public insurerProposedKill; //Mechanism to kill contract (insurer)
    
    //Initialize Empty Contract
    constructor() public {
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
    
    //Policy Holder Proposes Contract (pays into escrow)
    function proposeContract(string memory _zipcode, uint256 _predictedTemp, uint256 _proposedDelay, uint256 _payoutAmount) public payable {
        require(!proposed, "contract already proposed");
        require(msg.value > 0, "You need to put in some ether");
        policyHolder = msg.sender; //Policyholder address
        premiumAmount = msg.value; //Premium paid out by Policyholder
        payoutAmount = _payoutAmount; //Proposed amount paid out by Insurer
        toPayout = premiumAmount; //Total Paid out from escrow
        predictedTemp = _predictedTemp; //Set threshhold 
        zipcode = _zipcode; //Set zipcode of weather api
        
        proposedDelay = _proposedDelay; //set delay of the contract expiration (seconds until contract expires)
        
        proposed = true;
        timeOfProposal = now;
    }
    
    //Insurer Buys into Contract & Agrees to Terms (pays into escrow)
    function buyIn() public payable {
        require(proposed, "You need someone to propose a contract"); 
        require(!isContractExpired(), "Contract has expired, to return value from escrow please call proposeContractKill.");
        require(msg.value == payoutAmount, "You need to put in the same amount of ether as the contract requireds");
        require(msg.sender != policyHolder, "You can't buy into the contract if you proposed it."); // Remove to local testing ease
        insurer = msg.sender; //set insurer address
        toPayout = toPayout + payoutAmount; //escrow has increased by the payout of the insurer
            
        boughtIn = true;
            
        //Oracle API call
        uint256 secondsToExpiration = (timeOfProposal + proposedDelay) - now; //time until contract expires in seconds
        string memory restCall = string(abi.encodePacked("json(http://api.openweathermap.org/data/2.5/weather?zip=", string(zipcode), ",us&APPID=", APIKEY, ").main.temp")); //Oracle/Provable compatable API call
        provableQueryId = provable_query(secondsToExpiration, "URL", restCall); //API call to Provable (set query ID in contract)
    }
    
    //Oracle native function (Oracle rest call returning information to contract)
    function __callback(bytes32 _myid, string memory _result) public {
        require(msg.sender == provable_cbAddress());
        tempReturned = parseInt(_result, 2);
        
        if (toPayout > address(this).balance) { //Account for gas fees for payout (pays everthing remaining)
            toPayout = address(this).balance;
        }
        if (tempReturned > predictedTemp) { //If the temperature returned is above the threshold set
            policyHolder.transfer(toPayout); //Pay the policy holder
        } else {
            insurer.transfer(toPayout); //Pay the Insurer
        }
        clearContract(); //Reset the contract as it has now expired
    }
    
    //Clears contract --> Contract Reset
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
    
    //Calculates if contract is expired
    function isContractExpired() public view returns(bool) {
        require(proposed || boughtIn, "Contract is empty");
        uint256 timeOfExpiration = timeOfProposal + proposedDelay;
        return now >= timeOfExpiration;
    }
    
    //Insurer and Policy Holder can propose to kill the contract they created
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
                require(premiumAmount + payoutAmount < address(this).balance, "Contract needs more gas to kill and return ether.");
                policyHolder.transfer(premiumAmount); //Transfers policy holder's contribution back to them
                insurer.transfer(payoutAmount); //Transfer Insurer's contribution back to them
                clearContract(); //Contract is emptied
            }
        } else if (proposed) { //If no insurer has bought into the contract => no permission required from a Insurer to kill contract
            require(premiumAmount < address(this).balance, "Contract needs more gas to kill and return ether.");
            policyHolder.transfer(premiumAmount); //Only need to transfer the premium amount back to the policy holder
            clearContract(); //Empty out contract
        }
    }
}