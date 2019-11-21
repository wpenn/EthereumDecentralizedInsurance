const Contract = artifacts.require("Insurance");

module.exports = function(deployer) {
  deployer.deploy(Contract);
};