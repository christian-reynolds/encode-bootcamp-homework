const { expect } = require("chai");

describe("VolcanoCoin (proxy)", () => {
    let VolcanoCoin;
    let volcanoCoin;

    beforeEach(async function () {
        VolcanoCoin = await ethers.getContractFactory("VolcanoCoin");
        volcanoCoin = await upgrades.deployProxy(VolcanoCoin);
    });

    // it("should return it's symbol", async () => {
    //     expect(await volcanoCoin.symbol()).to.equal("VLC");
    // });

    // it("should return it's name", async () => {
    //     expect(await volcanoCoin.name()).to.equal("Volcano Coin");
    // });
});