# Decentralized Insurance Application

## Description
The "Decentralized Insurance Application" is a web DApp that interacts with the Ropsten testnet. It is an automated insurance policy that utilizes a smart contract to automatically pay out to the policyholder once a preset condition, or “parameter,” is met. In our application, if the temperature goes above a threshold chosen by the policyholder, the contract will automatically pay the policyholder. Otherwise, the insurer is paid instead. Our oracle data is from the open weather api website https://openweathermap.org/. It is a trusted API among both parties so there is little fear for either party of tampering or a breach. 

The policy holder proposes terms with our frontend built using React and OneClickDApp; specifically they propose the temperature parameter, the time delay for when the payout condition will be checked, the premium amount, and the payout amount. Once these terms are met, an insurer will accept the terms by buying in, and at the prespecified time, the smart contract will check the parameter and pay the “winner”. To check whether parameter is met, the smart contract calls the Oracle, which periodically calls the API based on the specified conditions in our smart contract.

The contract is built with [Solidity](https://solidity.readthedocs.io/en/v0.5.13/), which is deployed to the [Ropsten](https://ropsten.etherscan.io/) network with [Truffle](https://www.trufflesuite.com/truffle), [HDWalletProvider](https://github.com/trufflesuite/truffle-hdwallet-provider), and [Infura](http://Infura.io/).  The contract is also [Oraclized/Provable](https://provable.xyz/), consuming weather data about [temperature](https://openweathermap.org/api).
The front-end that interacts with the contract using [OneClickDapp](http://oneclickdapp.com).


## Install
* Install [Metamask](https://metamask.io) for Chrome.
* Install [Node.js and npm](https://nodejs.org/en/) (or with brew below)
```
cd /PATH/TO/YOUR/FOLDER/final-project-contract
brew install node
npm install truffle -g
npm install @truffle/hdwallet-provider
```
## Modify Project
### In ```truffle-config.js```:
Replace the values in the following lines with your [MetaMask private key](https://metamask.zendesk.com/hc/en-us/articles/360015289632-How-to-Export-an-Account-Private-Key) and [Infura Project ID](https://infura.io/dashboard).
```
const mnemonic = "{YOUR-METAMASK-PRIVATE-KEY}";
...
return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/v3/{YOUR-INFURA-PROJECT-ID}")
```
### In ```Insurance.sol```:
Replace the values in the following lines with your [Open Weather Map API Key](https://openweathermap.org/).
```
string APIKEY = "{YOUR-API-KEY}";
```

## Run
```
cd /PATH/TO/YOUR/FOLDER/final-project-contract
truffle compile
truffle migrate --network ropsten --reset
```
Then, you will find the "contract address" for the file ```2_deploy_contracts.js``` and copy it. In [OneClickDapp](https://oneclickdapp.com/new/), paste the contract address into *Address*, select Ropsten for *Network*, and copy the contents of ```.../final-project-contract/abi.json``` into the *Interface ABI* section.

**Note:** Copy and paste the contents of the solidity contract ```Insurance.sol``` into a new soliditity file in [Remix](https://remix.ethereum.org/), an online solidity IDE and compiler.

## Demo
* You can find a demo [here](https://oneclickdapp.com/verona-alpine/).
* This demo is hosted by [OneClickDapp](http://oneclickdapp.com).
