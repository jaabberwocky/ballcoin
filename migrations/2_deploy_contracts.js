const ConvertLib = artifacts.require("ConvertLib");
const BallCoin = artifacts.require("BallCoin");

module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, BallCoin);
  deployer.deploy(BallCoin);
};
