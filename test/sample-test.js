const { expect } = require("chai");
const { ethers } = require("hardhat");
const {BigNumber} = require("ethers");

describe("ICO", function () {

    let ERC20V2;
    let erc20V2;
    let ICOPaymentSplitter;
    let icoPaymentSplitter
    let CrowdSale
    let crowdSale

    let [_, person1, person2] = [1, 1, 1]


    it("Should deploy PaymentSplitter and ERC20 and Crowdsale contract ", async function () {
        [_, person1, person2] = await ethers.getSigners()

        ICOPaymentSplitter = await ethers.getContractFactory("ICOPaymentSplitter");
        icoPaymentSplitter = await ICOPaymentSplitter.deploy([_.address,person1.address]);
        await icoPaymentSplitter.deployed();

        CrowdSale = await ethers.getContractFactory("CrowdSale");
        crowdSale = await CrowdSale.deploy([_.address,person1.address],icoPaymentSplitter.address);
        await crowdSale.deployed();

        ERC20V2 = await ethers.getContractFactory("ERC20V2");
        erc20V2 = await ERC20V2.deploy(crowdSale.address);
        await erc20V2.deployed();
  
      

    });
    it("Start ICO", async function () {
            let sale = await crowdSale.sale()
            expect(sale).to.equal(false);
            let Tx = await crowdSale.startSale(erc20V2.address,100);
       
            await Tx.wait()  
            sale = await crowdSale.sale()
            expect(sale).to.equal(true);
         
    });

    it("buy Tokens", async function () {
        let _value = await ethers.utils.parseUnits('1', 'wei')
        _value = 100 *_value
     //   console.log(_value)
        let Tx = await crowdSale.connect(person2).buy(1,{value:_value});
        await Tx.wait()  
        let balance = await erc20V2.balanceOf(person2.address)
        balance = await BigNumber.from(balance).toString()
     //   console.log(balance)
        expect(balance).to.equal('1');
   
     
});  

it("split the payment", async function () {
    // let _value = await ethers.utils.parseUnits('1', 'wei')
    // _value = 100 *_value
    // console.log(_value)

    // sadsad

    let balance = await icoPaymentSplitter.ETHbalance();
    balance = await BigNumber.from(balance).toString()
    console.log(balance)

    let ETHbal = _.getBalance();

    let release = await icoPaymentSplitter.release(_.address)
    await release.wait()

    // // expect(balance).to.equal('1');

 
});  

});
