var casino = artifacts.require("./casino.sol");

module.exports = function(deployer) {
  deployer.deploy(casino);
};