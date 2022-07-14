const { expect } = require("chai");
const { ethers } = require("hardhat");

const WL_TOKEN_ID = 0;

describe("Trophies", function () {
    this.timeout(100000);
    it('airdrops', async () => {
        const [owner] = await ethers.getSigners();

        const Trophies = await ethers.getContractFactory("Trophies");
        const instance = await upgrades.deployProxy(Trophies);

        const airDropTx = await instance.sendTokens(0, [owner.address,owner.address,owner.address]);
        await airDropTx.wait();

        const airDropTx2 = await instance.sendTokens(1, [owner.address,owner.address,owner.address]);
        await airDropTx2.wait();

        const value = await instance.balanceOf(owner.address, WL_TOKEN_ID);
        expect(value.toString()).to.equal('3');
    });


    it('Sets uris', async () => {
        const [owner] = await ethers.getSigners();

        const Trophies = await ethers.getContractFactory("Trophies");
        const instance = await upgrades.deployProxy(Trophies);

        var tx1 = await instance.setContractURI("contractURI");
        await tx1.wait();

        var tx2 = await instance.setURI("tokenUri");
        await tx2.wait();


        var tokenUri = await instance.uri(WL_TOKEN_ID);
        expect(tokenUri).to.equal('tokenUri');

        var contractUri = await instance.contractURI();
        expect(contractUri).to.equal('contractURI');

    });


    it('Can be burned for WL', async () => {
        const [owner] = await ethers.getSigners();

        const Trophies = await ethers.getContractFactory("Trophies");
        const CryptoSucker = await ethers.getContractFactory("CryptoSucker");


        const trophiesInstance = await upgrades.deployProxy(Trophies);
        const suckerInstance = await upgrades.deployProxy(CryptoSucker, ["Crypto Suckers", "CS" ]);

        await trophiesInstance.setSuckerContract(suckerInstance.address);
        await suckerInstance.setTrophies(trophiesInstance.address);


        const airDropTx = await trophiesInstance.sendTokens(0, [owner.address]);
        await airDropTx.wait();

        var value = await trophiesInstance.balanceOf(owner.address, WL_TOKEN_ID);
        expect(value.toString()).to.equal('1');


        const mintTx = await suckerInstance.mintWhitelist(1)
        await mintTx.wait();


        var value = await trophiesInstance.balanceOf(owner.address, WL_TOKEN_ID);
        expect(value.toString()).to.equal('0');
    });


    it('Cant be burned by others', async () => {
        const [owner] = await ethers.getSigners();
        const Trophies = await ethers.getContractFactory("Trophies");
        const trophiesInstance = await upgrades.deployProxy(Trophies);
        const airDropTx = await trophiesInstance.sendTokens(0, [owner.address]);
        await airDropTx.wait();

        try {
            await trophiesInstance.burn(owner.address, 0 , 1);
            expect.fail("The burn transaction should have thrown an error");
        }
        catch (err) {
            expect(err.message).to.include('Burn');
        }
    });

});
