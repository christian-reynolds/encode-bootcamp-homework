// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "./AggregatorV3Interface.sol";

interface Erc20 {
    function approve(address, uint256) external returns (bool);
    function transfer(address, uint256) external returns (bool);
}

interface CErc20 {
    function mint(uint256) external returns (uint256);
    function exchangeRateCurrent() external returns (uint256);
    function supplyRatePerBlock() external returns (uint256);
    function redeem(uint) external returns (uint);
    function redeemUnderlying(uint) external returns (uint);
}

contract DeFi {
    address public constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public constant CDAI = 0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643;
    address public constant ETHPriceContract = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;
    Erc20 daiContract;
    CErc20 cDAIContract;
    AggregatorV3Interface ethAggregator;

    constructor() {
        daiContract = Erc20(DAI);
        cDAIContract = CErc20(CDAI);
        ethAggregator = AggregatorV3Interface(ETHPriceContract);
    }

    function addToCompound(uint256 amount) public {
        daiContract.approve(CDAI, amount);
        cDAIContract.mint(amount);
    }

    function getEthUsdPrice() public view returns(int256 price) {        
        (,price,,,) = ethAggregator.latestRoundData();
        return price;
    }
}
