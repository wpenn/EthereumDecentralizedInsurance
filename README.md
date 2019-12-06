# Decentralized Insurance Application

## Description
The "Decentralized Insurance Application" is a web DApp that interacts with the Ropsten testnet. It is an automated insurance policy that utilizes a smart contract to automatically pay out to the policyholder once a preset condition, or “parameter,” is met. In our application, if the temperature goes above a threshold chosen by the policyholder, the contract will automatically pay the policyholder. Otherwise, the insurer is paid instead. Our oracle data is from the open weather api website https://openweathermap.org/. It is a trusted API among both parties so there is little fear for either party of tampering or a breach. 

The policy holder proposes terms with our frontend built using React and OneClickDApp; specifically they propose the temperature parameter, the time delay for when the payout condition will be checked, the premium amount, and the payout amount. Once these terms are met, an insurer will accept the terms by buying in, and at the prespecified time, the smart contract will check the parameter and pay the “winner”. To check whether parameter is met, the smart contract calls the Oracle, which periodically calls the API based on the specified conditions in our smart contract.

## Components
* Contracts: [Contract Repository](https://github.com/wpenn/DecentralizedInsurance/tree/master/final-project-contract)
* Python Flask API: [Custom API Repository](#)