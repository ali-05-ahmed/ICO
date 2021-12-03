// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";


import "hardhat/console.sol";


contract CrowdSale is Context , Pausable{

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

    function buy(uint256 qunatity)public payable isSale whenNotPaused() {
        require(qunatity<=availabeToken());
      //  require(_owners[_msgSender()]==false,"owner cannot buy");
        require(msg.sender != address(0),"address 0 detected");
        uint256 _value = qunatity * price * 1 wei ;
        require(msg.value == _value,"provide exact price in wei");

        SafeERC20.safeTransfer(erc20, msg.sender, qunatity);

        payable(payment).transfer(msg.value);
        emit TokenPurchase(msg.sender,msg.value,qunatity);

    }

    function setPrice(uint256 _price)public payable onlyOwner{
        price=_price;
    }

    function pause() public onlyOwner whenNotPaused {
     _pause();
    }

    function unpause() public onlyOwner whenPaused {
     _unpause();
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */

}