const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ERC20", function () {

    let Nft;
    let nft

    let [_, person1, person2] = [1, 1, 1]


    it("Should deploy PaymentSplitter and ERC20 contract ", async function () {
        [_, person1, person2] = await ethers.getSigners()

        let MyPaymentSplitter = await ethers.getContractFactory("MyPaymentSplitter");
        let paymentSplitter = await MyPaymentSplitter.deploy([_.address,person1.address],[71,29]);
        await paymentSplitter.deployed();

        let ERC20V1 = await ethers.getContractFactory("ERC20V1");
        let erc20V1 = await ERC20V1.deploy(paymentSplitter.address);
        await erc20V1.deployed();
  
      

    });
    it("withdraw funds from", async function () {
        [_, person1, person2] = await ethers.getSigners()

        let MyPaymentSplitter = await ethers.getContractFactory("MyPaymentSplitter");
        let paymentSplitter = await MyPaymentSplitter.deploy([_.address,person1.address],[71,29]);
        await paymentSplitter.deployed();

        let ERC20V1 = await ethers.getContractFactory("ERC20V1");
        let erc20V1 = await ERC20V1.deploy(paymentSplitter.address);
        await erc20V1.deployed();
        try {
            let sadTx = await paymentSplitter.totalReleased();
        } catch (error) {
            console.log(error)
        }
       
        
         let Tx = await paymentSplitter.totalShares();

         console.log(Tx.toNumber())

         

          


        // wait until the transaction is mined
        // await Tx.wait();


  
        
    });
   
    
    
});
