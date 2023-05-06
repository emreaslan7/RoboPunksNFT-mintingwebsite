const hre = require("hardhat");

async function main() {

  const RoboPunksNFT = await hre.ethers.getContractFactory("RoboPunksNFT");
  const roboPunksNFT = await RoboPunksNFT.deploy();

  await roboPunksNFT.deployed();

  console.log(`deployed ${roboPunksNFT.address}`);
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
