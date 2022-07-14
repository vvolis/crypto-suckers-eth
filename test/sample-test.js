const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("CryptoSucker", function () {
    it('upgrades', async () => {
        const CryptoSucker = await ethers.getContractFactory("CryptoSucker");
        const instance = await upgrades.deployProxy(CryptoSucker, ["Crypto Suckers", "CS" ]);

        //const setGreetingTx = await instance.setGreeting("Hola, mundo111!");
        //await setGreetingTx.wait();
        /*
        const BoxV2 = await ethers.getContractFactory("Greeter2");
        const upgraded = await upgrades.upgradeProxy(instance.address, BoxV2);
        const setGreetingTx2 = await upgraded.setGreeting("Hola, mundo!");
        await setGreetingTx2.wait();
        */
        //expect(await upgraded.greet()).to.equal("Hola, mundo!");

        //const value = await upgraded.value();
        //expect(value.toString()).to.equal('42');
    });
});
