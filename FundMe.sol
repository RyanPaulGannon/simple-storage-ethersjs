// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 public minimumUSD = 10 * 1e18;

    address[] public funders;
    mapping (address => uint256) public addressToAmountFunded;

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value.getConversionRate() >= 1e18, "Not enough eth");
    }

    function withdraw() public {
        for (uint256 fundersIndex = 0; fundersIndex < funders.length; fundersIndex++) {
            address funder = funders[fundersIndex];
            addressToAmountFunded[funder] = 0;
        } 
        // Reset the array
        funders = new address[](0);
        // Withdraw the funds

        // Three ways: Transfer, send, call. Transfer easiest way.

        // // Transfer (capped at 2300 gas, throws error)
        // payable (msg.sender).transfer(address(this).balance);

        // // Send (capped at 2300 gas, returns boolean)
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send Failed");

        // Call (one of the first lower level commands, can be used to call almost any function without 
        // needing abi. Looks similar to send.
        (bool callSuccess, ) = payable (msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call Failed");
    }

    // Modifier is the first code processed
    modifier onlyOwner {
        require(msg.sender == owner);
        _; // This represents doing the rest of the code
    }

}

// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD