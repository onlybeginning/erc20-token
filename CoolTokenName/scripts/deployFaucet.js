const hre = require("hardhat");

async function main() {
    const Faucet = await hre.ethers.getContractFactory("Faucet");
    const faucet = await Faucet.deploy("0x8EECaB3b817408748C3dA95EE05f72bc1b585cea");

    await faucet.deployed();

    console.log("Faucet contract deployed: ", faucet.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});