pragma solidity 0.6.0;
import './Level_3_Global_Functions.sol';

contract Level_3_Global_Functions_Answer {
    Level_3_Global_Functions public gfContract;

    constructor(address _gfContractAddress) public {
        gfContract = Level_3_Global_Functions(_gfContractAddress);
    }

    function guess() public {
        gfContract.guessTheFutureHash('');
    }

    function levelComplete() public {
        gfContract.completeLevel();
    }

}