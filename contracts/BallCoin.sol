// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25;

import "./ConvertLib.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract BallCoin is ERC20 {
	mapping (address => uint) balances;
	mapping (address => uint) numBalls;

	event BallTransfer(address indexed _from, address indexed _to, uint256 _number);

	constructor() ERC20("BallCoin", "BLC") {
		uint totalSupply = 1000000 * (10 ** uint256(decimals()));
		balances[tx.origin] = totalSupply;
		numBalls[tx.origin] = 3;
		_mint(msg.sender, totalSupply);
	}

	function sendCoin(address receiver, uint amount) public returns(bool sufficient) {
		if (balances[msg.sender] < amount) return false;
		balances[msg.sender] -= amount;
		balances[receiver] += amount;
		emit Transfer(msg.sender, receiver, amount);
		return true;
	}

	function sendBall(address _receiver, uint _number) public returns(bool sufficient) {
		require(numBalls[msg.sender] >= _number);
		numBalls[_receiver] += _number;
		numBalls[msg.sender] -= _number;
		emit BallTransfer(msg.sender, _receiver, _number);
		return true;
	}

	function getBalanceInEth(address addr) public view returns(uint){
		return ConvertLib.convert(getBalance(addr),2);
	}

	function getBalance(address addr) public view returns(uint) {
		return balances[addr];
	}

	function getBall(address _addr) public view returns(uint) {
		return numBalls[_addr];
	}
}
