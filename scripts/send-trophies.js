// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const Trophies = await ethers.getContractFactory("Trophies");
  const instance = await Trophies.attach("0xf6264d65f45022751fb9a594d1e2ab07f1abbb20");

  
  var addresses = ['0x11e365DFEa23EF2E2Af5814ec2cdDEbECEa01023',
    '0x9C5a35728c602e1ca275C6d2ccD4622346db8752',
    '0x7b7eAe6A6c6dD6D66F75a93ca8D1C063D01730EC',
    '0x944C9EF3Ca71E710388733E6C57974e8923A9020',
];

    const airDropTx2 = await instance.sendTokens(0, addresses);
    await airDropTx2.wait();
    console.log("Trophies airdropped");

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
