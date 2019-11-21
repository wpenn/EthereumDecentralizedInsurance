// module.exports = {
//   // See <http://truffleframework.com/docs/advanced/configuration>
//   // for more about customizing your Truffle configuration!
//   networks: {
//     development: {
//       host: "127.0.0.1",
//       port: 7545,
//       network_id: "*" // Match any network id
//     },
//     develop: {
//       port: 8545
//     }
//   }
// };

const HDWalletProvider = require("@truffle/hdwallet-provider");
const mnemonic = "88D7C8ABB6EDBCE9575A557DA2F5F2BFB92B6FC4134D14E009D5DBC7749926FD";

module.exports = {
  networks: {
    ropsten: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/v3/d2c7fcefabe448ff853881cba5ca0599")
      },
      network_id: 3
    }   
  }
};