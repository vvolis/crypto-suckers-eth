// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const { ethers } = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');
  const [owner] = await ethers.getSigners();

  // We get the contract to deploy
  const Trophies = await ethers.getContractFactory("Trophies");
  const instance = await upgrades.deployProxy(Trophies);
  await instance.deployed();


    console.log("Trophies deployed to:", instance.address);


    const airDropTx = await instance.sendTokens(0, [owner.address/*, '0xb6B707a91eFD772a303fFe0727209708CE4ad655', '0x4572bEC0b73b319DfA81845036a62750566dfF43'*/]);
    await airDropTx.wait();

    const airDropTx2 = await instance.sendTokens(1, [owner.address/*, '0xb6B707a91eFD772a303fFe0727209708CE4ad655', '0x4572bEC0b73b319DfA81845036a62750566dfF43'*/]);
    await airDropTx2.wait();
    console.log("Airdrops done");

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
