// SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VolcanoCoin is ERC20("Volcano Coin", "VLC"), Ownable {

    uint256 constant initialSupply = 10000;
    enum PaymentType { UNKNOWN, BASIC, REFUND, DIVIDEND, GROUP }
    PaymentType constant defaultPaymentType = PaymentType.UNKNOWN;
    
    struct Payment {
        uint256 paymentId;
        uint256 amount;
        address to;
        PaymentType paymentType;
        string comment;
        uint256 timestamp;
    }
    
    mapping(address => Payment[]) public payments;
    
    event TotalSupplyIncreased(uint256);
    
    constructor() {
        _mint(msg.sender, initialSupply);
    }
    
    function addToTotalSupply(uint256 _quantity) public onlyOwner {
        _mint(msg.sender, _quantity);
        emit TotalSupplyIncreased(_quantity);
    }
    
    function getPayments(address _addr) public view returns (Payment[] memory) {
        return payments[_addr];
    }
    
    function transfer(address _recipient, uint256 _amount) public virtual override returns (bool) {
        _transfer(msg.sender, _recipient, _amount);
        recordPayment(msg.sender, _recipient, _amount);
        return true;
    }
    
    function recordPayment(address _sender, address _recipient, uint256 _amount) internal {
        //TODO: replace the hardcoded paymentId of 1
        payments[_sender].push(Payment(1, _amount, _recipient, defaultPaymentType, "", block.timestamp));
    }
    
}