// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 amount);
}

contract Faucet {
    address payable owner;
    IERC20 public token;

    uint256 public withdrawAmount = 50 * (10 ** 18);
    uint256 public lockTime = 1 minutes;

    event Deposit(address indexed from, uint256 amount);
    event Withdrawal(address indexed to, uint256 amount);

    mapping(address => uint256) nextClaimAttempt;

    constructor(address tokenAddress) payable {
        token = IERC20(tokenAddress);
        owner = payable(msg.sender);
    }

    function requestTokens() public {
        require(msg.sender != address(0), "Request must not originate from a zero account");
        require(token.balanceOf(address(this)) >= withdrawAmount, "Insufficient balance in faucet for withdrawal request");
        require(block.timestamp >= nextClaimAttempt[msg.sender], "Insufficient time elapsed since last claim - try again later");

        nextClaimAttempt[msg.sender] = block.timestamp + lockTime;

        token.transfer(msg.sender, withdrawAmount);
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function faucetBalance() external view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function setWithdrawAmount(uint256 withdrawAmount_) public onlyOwner {
        withdrawAmount = withdrawAmount_ * (10 ** 18);
    }

    function setLockTime(uint256 lockTime_) public onlyOwner {
        lockTime = lockTime_ * 1 minutes;
    }

    function withdrawFaucetFunds() external onlyOwner {
        emit Withdrawal(msg.sender, token.balanceOf(address(this)));
        token.transfer(msg.sender, token.balanceOf(address(this)));
    } 

    modifier onlyOwner {
        require(owner == msg.sender, "Only the contract owner can call this function");
        _; 
    }
}