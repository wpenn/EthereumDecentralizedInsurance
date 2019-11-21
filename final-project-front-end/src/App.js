import React, {Component} from 'react';
import Web3 from 'web3';
import './App.css';

class App extends Component {
  constructor(props) {
    super(props);
  }

  componentDidMount() {
    this.loadBlockchainData()
  }

  async loadBlockchainData() {
    const web3 = new Web3(Web3.givenProvider || "http://localhost:8545");
    const network = await web3.eth.net.getNetworkType();
    const accounts = await web3.eth.getAccounts();
    const TODO_LIST_ADDRESS = '0xF1836F30291f8dacc99B6731E616f57BF5418D81';
    const TODO_LIST_ABI = [
          {
            "constant": false,
            "inputs": [
              {
                "internalType": "bytes32",
                "name": "_myid",
                "type": "bytes32"
              },
              {
                "internalType": "string",
                "name": "_result",
                "type": "string"
              }
            ],
            "name": "__callback",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "internalType": "bytes32",
                "name": "_myid",
                "type": "bytes32"
              },
              {
                "internalType": "string",
                "name": "_result",
                "type": "string"
              },
              {
                "internalType": "bytes",
                "name": "_proof",
                "type": "bytes"
              }
            ],
            "name": "__callback",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [],
            "name": "buyIn",
            "outputs": [],
            "payable": true,
            "stateMutability": "payable",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "termAmount",
            "outputs": [
              {
                "internalType": "uint256",
                "name": "",
                "type": "uint256"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "policyHolder",
            "outputs": [
              {
                "internalType": "address payable",
                "name": "",
                "type": "address"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": false,
            "inputs": [
              {
                "internalType": "uint256",
                "name": "_predictedPrice",
                "type": "uint256"
              },
              {
                "internalType": "uint256",
                "name": "_queryDelay",
                "type": "uint256"
              }
            ],
            "name": "proposeContract",
            "outputs": [],
            "payable": true,
            "stateMutability": "payable",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "boughtIn",
            "outputs": [
              {
                "internalType": "bool",
                "name": "",
                "type": "bool"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "expiryTime",
            "outputs": [
              {
                "internalType": "uint256",
                "name": "",
                "type": "uint256"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "gasPriceUSD",
            "outputs": [
              {
                "internalType": "uint256",
                "name": "",
                "type": "uint256"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "proposed",
            "outputs": [
              {
                "internalType": "bool",
                "name": "",
                "type": "bool"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "constant": true,
            "inputs": [],
            "name": "insurer",
            "outputs": [
              {
                "internalType": "address payable",
                "name": "",
                "type": "address"
              }
            ],
            "payable": false,
            "stateMutability": "view",
            "type": "function"
          },
          {
            "inputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "constructor"
          }
        ];

      const insuranceContract = new web3.eth.Contract(TODO_LIST_ABI, TODO_LIST_ADDRESS).methods;
      console.log("BoughtIn", insuranceContract.proposeContract(240, 0).call());
  }

  render(){
    return (
      <div className="containter">
        <h1> Hello, World!</h1>
      </div>
    );
  }
}

export default App;
