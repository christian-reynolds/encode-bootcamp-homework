const { expect } = require("chai");
const { ethers, upgrades } = require("hardhat");

describe("VolcanoCoin", () => {
    let VolcanoCoin;
    let volcanoCoin;

    let VolcanoCoinV2;
    let volcanoCoinV2;

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

    it("should upgrade the implementation contract and return it's version", async () => {
        VolcanoCoinV2 = await ethers.getContractFactory("VolcanoCoinV2");
        volcanoCoinV2 = await upgrades.upgradeProxy(volcanoCoin.address, VolcanoCoinV2);
        await volcanoCoinV2.deployed();

        console.log("VolcanoCoinV2 deployed to: ", volcanoCoinV2.address);

        expect(await volcanoCoinV2.versionNumber()).to.equal(2);
    });
});