const { expect, use } = require("chai");
const { network, ethers } = require("hardhat");

const { solidity } = require("ethereum-waffle");
use(solidity);

describe("DeFi", () => {
  let owner;
  let DAI_TokenContract;
  let cDAI_TokenContract;
  let DeFi_Instance;
  const INITIAL_AMOUNT = "1000";

  before(async function () {
    [owner, addr1, addr2, addr3, addr4, addr5] = await ethers.getSigners();

    // Deploy our contract
    const DeFi = await ethers.getContractFactory("DeFi");
    DeFi_Instance = await DeFi.deploy();

    // This is needed to impersonate an account on the forked network
    await network.provider.request({
      method: "hardhat_impersonateAccount",
      params: ["0x503828976D22510aad0201ac7EC88293211D23Da"],
    });
    
    const whale = await ethers.getSigner(
      "0x503828976D22510aad0201ac7EC88293211D23Da"
    );

    DAI_TokenContract = await ethers.getContractAt("ERC20", DeFi_Instance.DAI());
    cDAI_TokenContract = await ethers.getContractAt("ERC20", DeFi_Instance.CDAI());
   
    // Transfer DAI from the whale to the owner address
    await DAI_TokenContract.connect(whale).transfer(
      owner.address,
      ethers.utils.parseUnits(INITIAL_AMOUNT)
    );
  });

  it("should check transfer succeeded", async () => {
    const balance = await DAI_TokenContract.balanceOf(owner.address);
    console.log("Owner balance: ", ethers.utils.formatUnits(balance));

    expect(balance).to.gte(ethers.utils.parseUnits(INITIAL_AMOUNT));
  });

  it("should sendDAI to contract", async () => {
    await DAI_TokenContract.transfer(
      DeFi_Instance.address,
      ethers.utils.parseUnits(INITIAL_AMOUNT)
    );

    const balance = await DAI_TokenContract.balanceOf(DeFi_Instance.address);
    console.log("DeFi DAI balance: ", ethers.utils.formatUnits(balance));

    expect(balance).to.eql(ethers.utils.parseUnits(INITIAL_AMOUNT));
  });
  it("should make a swap", async () => {
    await DeFi_Instance.addToCompound(ethers.utils.parseUnits(INITIAL_AMOUNT));

    const balance = await cDAI_TokenContract.balanceOf(DeFi_Instance.address);
    console.log("DeFi cDAI balance: ", ethers.utils.formatUnits(balance, 8));

    expect(balance).to.gt(ethers.utils.parseUnits("0"));
  });
});
