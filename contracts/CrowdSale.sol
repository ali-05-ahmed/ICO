// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


import "hardhat/console.sol";


contract CrowdSale is Context{

    IERC20 private erc20;
    uint256 public price;
    bool public sale;
    address private payment;

    mapping(address => bool) private _owners;

    event TokenPurchase(
    address indexed purchaser,
    uint256 value,
    uint256 amount
  );
  
    constructor(address[2] memory owners,address _payment) {
        sale = false;
        payment = _payment;
        for(uint160 i=0;i<owners.length;i++){
            _owners[owners[i]]=true;
        }

    }

       modifier onlyOwner {
      require(_owners[_msgSender()]==true,"Not An owner");
      _;
      }
      modifier isSale {
      require(sale==true,"Not An owner");
      _;
      }
    
    function startSale(address _erc20, uint256 _price) public onlyOwner {
        erc20 =IERC20(_erc20);
        require(availabeToken()>0,"No funds Cant start Sale");
        price=_price * 1 wei;
        sale=true;
    }

    function availabeToken() public view returns(uint256){
        return erc20.balanceOf(address(this));
    }

    function buy(uint256 amount)public payable isSale {
        require(amount<=availabeToken());
        require(msg.sender != address(0),"address 0 detected");
        uint256 _value = amount * price * 1 wei ;
        require(msg.value == _value,"provide exact price in wei");

       // erc20.transferFrom(address(this), msg.sender, amount);
        SafeERC20.safeTransfer(erc20, msg.sender, amount);

        payable(payment).transfer(msg.value);
        emit TokenPurchase(msg.sender,msg.value,amount);

    }

    function setPrice(uint256 _price)public payable onlyOwner{
        price=_price;
    }
}