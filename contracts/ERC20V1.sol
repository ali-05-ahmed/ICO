// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "hardhat/console.sol";

contract ERC20V1 is ERC20 {
    
    event PayeeAdded(address account, uint256 shares);
    event PaymentReleased(address to, uint256 amount);
    event PaymentReceived(address from, uint256 amount);

    uint256 private _totalShares;
    uint256 private _totalReleased;
    uint256 private _initialSupply = 20000000e18;
    uint256 private _currentSupply;
    uint256 public _price;

    mapping(address => uint256) private _shares;
    mapping(address => uint256) private _released;
    mapping(address => bool) private _owners;
    address[] private _payees;
    //uint256[2] private shares_ = [71,29];




    constructor(address[] memory payees,uint256[2] memory shares_) ERC20("ELU", "ELU") {
        require(payees.length == shares_.length, "payees and shares length mismatch");
        require(payees.length > 0, "no payees");
        _currentSupply = _initialSupply;
        for (uint256 i = 0; i < payees.length; i++) {
            _addPayee(payees[i], shares_[i]);
        }
    }

    modifier onlyOwner {
      require(_owners[_msgSender()]==true,"You cannot set price");
      _;
      }

    function release() public {
        address account =msg.sender;
        require(_shares[account] > 0, "account has no shares");

        uint256 totalReceived = _currentSupply + _totalReleased;
        uint256 payment = (totalReceived * _shares[account]) / _totalShares - _released[account];

        require(payment != 0, "account is not due payment");

        _released[account] = _released[account] + payment;
        _totalReleased = _totalReleased + payment;
        _currentSupply = _currentSupply - payment;

         _mint(account,payment);
        emit PaymentReleased(account, payment);
    }

     function _addPayee(address account, uint256 shares_) private {
        require(account != address(0), "account is the zero address");
        require(shares_ > 0, "shares are 0");
        require(_shares[account] == 0, "account already has shares");

        _payees.push(account);
        _shares[account] = shares_;
        _totalShares = _totalShares + shares_;
        _owners[_msgSender()]=true;
        emit PayeeAdded(account, shares_);
    }
    

    function setPrice(uint price) public onlyOwner{
        _price = price;
    }

    

}