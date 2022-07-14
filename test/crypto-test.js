const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Crypto", function () {
    /*it('signs', async () => {


        const [account] = await ethers.getSigners();

        const Crypto = await ethers.getContractFactory("Crypto");
        const instance = await Crypto.deploy();



        var message = "coffee and donuts"
        var messageHash = ethers.utils.solidityKeccak256(['string'], [message]);
        var signature = await account.signMessage(ethers.utils.arrayify(messageHash));
        console.log("Signature", signature)

        var verified = await instance.verifyMessage(message, signature);


        console.log("acc", await account.getAddress());
        console.log("verified", verified)
    });*/

    it('check-signed', async () => {
        const Crypto = await ethers.getContractFactory("Crypto");
        const instance = await Crypto.deploy();
        var verified = await instance.verifyMessage("coffee and donuts", "0x6c341d073d3c29fefcc72593d7a6e074f362f33c4d0b1d6e9436243c64b4d75033c747e5af64da09b660bf0ce8db75ea635a8ec63b3d28b86beb569b0cba00bc1b");
        console.log("Verified", verified);
        
    });
    
    
});
