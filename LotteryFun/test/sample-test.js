const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Greeter", function () {
  it("", async function () {

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
