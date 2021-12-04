const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("VolcanoCoin", () => {
    let volcanoContract;

    beforeEach(async () => {
        const Volcano = await ethers.getContractFactory("VolcanoCoin");
        volcanoContract = await Volcano.deploy();
        await volcanoContract.deployed();

        // [owner, addr1, addr2, addr3] = await ethers.getSigners();
    });

    it("should return it's symbol", async () => {
        expect(await volcanoContract.symbol()).to.equal("VLC");
    });

    it("should return it's name", async () => {
        expect(await volcanoContract.name()).to.equal("Volcano Coin");
    });
});