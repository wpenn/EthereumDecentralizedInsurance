# Provable Insurance Ethereum Smart Contract [![MIT Licence](https://badges.frapsoft.com/os/mit/mit.svg?v=103)](https://opensource.org/licenses/mit-license.php) [![Provable](https://camo.githubusercontent.com/5e89710c6ae9ce0da822eec138ee1a2f08b34453/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f646f63732d536c6174652d627269676874677265656e2e737667)](https://github.com/provable-things)
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