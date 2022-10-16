// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

interface IERC20 {
    function transfer(address to, uint256 amount) external view returns(bool);
    function balanceOf(address account) external view returns(uint256);
}

contract Faucet {
    address payable owner;
    IERC20 public token;

    uint256 withdrawAmount = 50 * (10 ** 18);
    uint256 lockTime = 1 minutes;

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
}