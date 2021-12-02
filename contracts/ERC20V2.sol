// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";

import "hardhat/console.sol";

contract ERC20V1 is ERC20 {
  
    constructor(address contractAddress) ERC20("Creative creation","CTT"){
    require(Address.isContract(contractAddress),"This is not an ICO Contract address");
    _mint(contractAddress,20000000e18);
    }

}