var UserContract = artifacts.require("./UserContract.sol");
var Exchange = artifacts.require("./Exchange.sol");
var Membership = artifacts.require("./Membership.sol");

module.exports = function(deployer) {
  deployer.deploy(UserContract);
  deployer.deploy(Exchange);
  deployer.deploy(Membership);
};
