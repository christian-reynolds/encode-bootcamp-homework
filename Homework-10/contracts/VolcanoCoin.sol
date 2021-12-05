// SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract VolcanoCoin is ERC20("Volcano Coin", "VLC"), Ownable {

    uint256 constant initialSupply = 10000;
    using Counters for Counters.Counter;
    Counters.Counter private _paymentIds;
    enum PaymentType { UNKNOWN, BASIC, REFUND, DIVIDEND, GROUP }
    uint8 private paymentTypeEnumCount = 4;
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
        _paymentIds.increment();

        _transfer(msg.sender, _recipient, _amount);
        recordPayment(msg.sender, _recipient, _amount);
        return true;
    }
    
    function recordPayment(address _sender, address _recipient, uint256 _amount) internal {
        payments[_sender].push(Payment(_paymentIds.current(), _amount, _recipient, defaultPaymentType, "", block.timestamp));
    }

    function updatePaymentDetails(uint256 _paymentId, uint8 _paymentType, string memory _comment) public {
        require(_paymentType <= paymentTypeEnumCount, "VolcanoCoin: PaymentType is not a valid value");
        Payment[] storage addressPayments = payments[msg.sender];
        require(addressPayments.length > 0, "VolcanoCoin: No payments found for this address");
        bool paymentFound = false;

        for (uint i=0; i< addressPayments.length; i++) {
             Payment memory payment = addressPayments[i];

             if (_paymentId == payment.paymentId) {
                paymentFound = true;
                payment.paymentType = PaymentType(_paymentType);
                payment.comment = _comment;
                addressPayments[i] = payment;
                 break;
             }
        }

        require(paymentFound, "VolcanoCoin: Payment not found");

        payments[msg.sender] = addressPayments;
    }
    
}