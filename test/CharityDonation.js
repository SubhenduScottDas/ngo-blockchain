const { expect } = require("chai");

describe("CharityDonation", function () {
  it("Should create a cause", async function () {
    const CharityDonation = await ethers.getContractFactory("CharityDonation");
    const charityDonation = await CharityDonation.deploy();

    const createTx = await charityDonation.createCause(
      "Education Fund",
      "Funds for rural education",
      ethers.parseEther("10")
    );

    await createTx.wait();
    const cause = await charityDonation.causes(1);

    expect(cause.name).to.equal("Education Fund");
  });
});
