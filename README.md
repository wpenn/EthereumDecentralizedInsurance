# Decentralized Insurance Application

## Description
The "Decentralized Insurance Application" is a web DApp that interacts with the Ropsten testnet. It is an automated insurance policy that utilizes a smart contract to automatically pay out to the policyholder once a preset condition is met: if the fuel price goes above a price chosen by the policyholder, the contract will automatically pay the policyholder, and if not, the insurer is paid instead. The policy holder proposes terms with our frontend built using React and OneClickDApp; specifically they propose the fuel price parameter, the time delay for when the payout condition will be checked, the premium amount, and the payout amount. Once these terms are met, an insurer will accept the terms by buying in, and at the prespecified time, the smart contract will check the parameter and pay the “winner”. For now, the premium and the insurer’s contribution must be the same, and the “winner” receives the total pot  which is equivalent to the total sum of the premium and the insurer’s contribution.

The contract is built with [Solidity](https://solidity.readthedocs.io/en/v0.5.13/), which is deployed to the [Ropsten](https://ropsten.etherscan.io/) network with [Truffle](https://www.trufflesuite.com/truffle), [HDWalletProvider](https://github.com/trufflesuite/truffle-hdwallet-provider), and [Infura](http://Infura.io/). 
The front-end that interacts with the contract using [OneClickDapp](http://oneclickdapp.com).


## Install
```

```
## Run
```

```
## Demo
* You can find a demo [here]().
* This demo is hosted by [OneClickDapp](http://oneclickdapp.com).
