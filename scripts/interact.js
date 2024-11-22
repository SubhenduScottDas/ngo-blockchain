const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  // Attach to deployed contract
  const CharityDonation = await ethers.getContractFactory("CharityDonation");
  const charityDonation = CharityDonation.attach("0x5FbDB2315678afecb367f032d93F642f64180aa3");

  // Create a cause
  console.log("Creating Cause...");
  const createTx = await charityDonation.createCause("Environmental Protection", "Help protect our planet", ethers.parseEther("15"));
  await createTx.wait();
  console.log("Cause Created!");

  // Donate to the cause
  console.log("Donating...");
  const donateTx = await charityDonation.donate(1, { value: ethers.parseEther("1") });
  await donateTx.wait();
  console.log("Donation Sent!");

  // Fetch cause details
  const cause = await charityDonation.causes(1);
  console.log("Cause Details:", cause);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
