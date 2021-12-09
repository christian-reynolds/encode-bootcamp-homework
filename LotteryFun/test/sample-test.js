const { expect, use } = require("chai");
const { ethers } = require("hardhat");

describe("Attack", function () {
  let lotteryContract;
  let attackContract;

  beforeEach(async () => {
    const Lottery = await ethers.getContractFactory("Lottery");
    lotteryContract = await Lottery.deploy();
    await lotteryContract.deployed();

    const LotteryAttack = await ethers.getContractFactory("LotteryAttack");
    attackContract = await LotteryAttack.deploy(lotteryContract.address);
    await attackContract.deployed();

    [owner, addr1, addr2, addr3] = await ethers.getSigners();
  });

  it.only("Lottery has a balance after sending ETH to the contract", async function () {
    const tx = await owner.sendTransaction({
      to: lotteryContract.address,
      value: ethers.utils.parseEther("1")
    });
    await tx.wait();

    const balance = await ethers.provider.getBalance(lotteryContract.address);
    console.log("My test: ", ethers.utils.parseEther("1"));
    expect(balance).to.equal(ethers.utils.parseEther("1"));
  });

  it("Attaches to an external contract", async function () {
    const myContract = await (await ethers.getContractFactory("Lottery")).attach("0x90649B117656e54aB4F2592c1E83e7145Eae1290");

    // Do whatever you need with the external contract

  });

  it("Attaches gets data from storage at an external contract", async function () {
    for (let x = 0; x < 50; x++) {
      const test = await ethers.provider.getStorageAt("0x90649B117656e54aB4F2592c1E83e7145Eae1290", x);
      console.log("This is my test: ", test);
    }

    // Do whatever you need with the external contract

  });

  it("Gets the balance of an address", async function () {
    const balance0ETH = await ethers.provider.getBalance("0xF803aC944814374a8664B138E280526a2cEEa95b");
    console.log("This is the test value: ", ethers.utils.formatEther(balance0ETH));
  });
});
