const HDWalletProvider = require("@truffle/hdwallet-provider");
const mnemonic = "{YOUR-METAMASK-PRIVATE-KEY}";

module.exports = {
  networks: {
    ropsten: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/v3/{YOUR-INFURA-LINK}")
      },
      network_id: 3
    }   
  }
};