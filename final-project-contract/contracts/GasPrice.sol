pragma solidity >=0.4.22 <0.7.0;

import "./provableAPI.sol";

contract GasPrice is usingProvable {
    uint public gasPriceUSD;
    
    event LogNewGasPrice(string price);
    event LogNewProvableQuery(string description);
    
    constructor() public {
        update();
    }
    
    function __callback(bytes32 _myid, string memory _result) public {
        require(msg.sender == provable_cbAddress()); //AHHH why does it need to be a cb address
        emit LogNewGasPrice(_result);
        gasPriceUSD = parseInt(_result, 2);
    }
    
    function update() public payable {
        emit LogNewProvableQuery("Provable query was sent, waiting for answer...");
        provable_query("URL", "xml(https://www.fueleconomy.gov/ws/rest/fuelprices).fuelPrices.regular");
    }

    function resetToZero() public payable {
        gasPriceUSD = 0;
    }
}