// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25;

import "./ConvertLib.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @dev Contract module for BallCoin. Pretty simple ERC20 token done for learning purposes.
 */
contract BallCoin is ERC20, Ownable {
	mapping (address => uint) balances;
	mapping (address => uint) numBalls;
	mapping (uint => address) ballToOwner;

	string public ballName = "DefaultBall";
	Ball[] public balls;

	struct Ball {
		string name;
		uint16 price;
		uint8 weight;
	}

	event BallTransfer(address indexed _from, address indexed _to, uint256 _number);

	constructor() ERC20("BallCoin", "BLC") {
		uint totalSupply = 10000 * (10 ** (decimals()));
		uint totalBalls = 30;
		balances[tx.origin] = totalSupply;

		for (uint i = 0; i < totalBalls; i++) {
			Ball memory b = Ball(ballName, 15, 2);
			ballToOwner[i] = msg.sender;
			balls.push(b);
			numBalls[msg.sender]++;
		}
		_mint(msg.sender, totalSupply);
	}

	function setBallName(string memory _ballName) external onlyOwner {
		ballName = _ballName;
	}

	function sendCoin(address _receiver, uint _amount) public returns(bool sufficient) {
		if (balances[msg.sender] < _amount) return false;
		balances[msg.sender] -= _amount;
		balances[_receiver] += _amount;
		emit Transfer(msg.sender, _receiver, _amount);
		return true;
	}

	function sendBall(address _receiver, uint _number) public returns(bool sufficient) {
		require(numBalls[msg.sender] >= _number);
		numBalls[_receiver] += _number;
		numBalls[msg.sender] -= _number;
		emit BallTransfer(msg.sender, _receiver, _number);
		return true;
	}

	function getBalanceInEth(address _addr) public view returns(uint){
		return ConvertLib.convert(getBalance(_addr),2);
	}

	function getBalance(address _addr) public view returns(uint) {
		return balances[_addr];
	}

	function getBall(address _addr) public view returns(uint) {
		return numBalls[_addr];
	}
}
