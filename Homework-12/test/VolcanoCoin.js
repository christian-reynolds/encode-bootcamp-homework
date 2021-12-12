const { expect } = require("chai");
const { ethers, upgrades } = require("hardhat");

describe("VolcanoCoin", () => {
    let VolcanoCoin;
    let volcanoCoin;

    beforeEach(async function () {
        VolcanoCoin = await ethers.getContractFactory("VolcanoCoin");
        volcanoCoin = await upgrades.deployProxy(VolcanoCoin, { kind: 'uups' });
        await volcanoCoin.deployed();

        console.log("VolcanoCoin deployed to: ", volcanoCoin.address);
        console.log("VolcanoCoin version number: ", await volcanoCoin.versionNumber());
    });

    it("should return it's version", async () => {
        expect(await volcanoCoin.versionNumber()).to.equal(1);
    });

    it("should return it's name", async () => {
        expect(await volcanoCoin.name()).to.equal("Volcano Coin");
    });
});