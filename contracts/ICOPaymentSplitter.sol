// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/finance/PaymentSplitter.sol";

import "hardhat/console.sol";


contract ICOPaymentSplitter is PaymentSplitter{

    uint256[] private shares_ = [71,29];

constructor(address[] memory owners) PaymentSplitter(owners,shares_){

}

}