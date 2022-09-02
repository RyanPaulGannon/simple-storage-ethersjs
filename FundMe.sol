// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    // Using constant keeps gas cost down, syntactically uppercase and underscores 
    uint256 public constant MINIMUM_USD = 10 * 1e18;

    address[] public funders;
    mapping (address => uint256) public addressToAmountFunded;

    // Immutability, also saves gas
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        // Create custom error
        require(msg.value.getConversionRate() >= 1e18, "Not enough eth");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
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
        // require(msg.sender == i_owner); Revert and require do the same thing
        if (msg.sender != i_owner) { revert NotOwner(); } // Saves gas by remove strings as errors
        _; // This represents doing the rest of the code
    }

    // If someone sends funding to the contract, it can still be processed by one of the following transactions
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

}

// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD