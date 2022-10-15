const hre = require("hardhat");

async function main() {
	const CoolTokenName = await hre.ethers.getContractFactory("CoolTokenName");
	const coolTokenName = await CoolTokenName.deploy(100000000, 50);

	await coolTokenName.deployed();

	console.log("CoolTokenName deployed: ", coolTokenName.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
