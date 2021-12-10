const { expect } = require("chai");

describe("VolcanoCoin", () => {
    let VolcanoCoin;
    let volcanoCoin;

    beforeEach(async function () {
        VolcanoCoin = await ethers.getContractFactory("VolcanoCoin");
        volcanoCoin = await VolcanoCoin.deploy();
        await volcanoCoin.deployed();
    });

    it("should return it's symbol", async () => {
        expect(await volcanoCoin.symbol()).to.equal("VLC");
    });

    it("should return it's name", async () => {
        expect(await volcanoCoin.name()).to.equal("Volcano Coin");
    });
});