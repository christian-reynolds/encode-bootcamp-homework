// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;
import "@openzeppelin/contracts/access/AccessControl.sol";


contract GasContract is AccessControl {
    
    // Create a new role identifier for the minter role
    bytes32 private constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    uint public totalSupply; // cannot be updated
    uint paymentCounter;
    address[5] public administrators;
    enum PaymentType { Unknown, BasicPayment, Refund, Dividend, GroupPayment }

    mapping(address => uint256) balances;
    mapping(address => Payment[]) payments;

    struct Payment {
      uint paymentID;
      uint amount;
      PaymentType paymentType;
      address recipient;
      string recipientName;  // max 8 characters
      bool adminUpdated;
      address admin;    // administrators address      
    }

    event supplyChanged(address indexed, uint256 indexed);
    event Transfer(address recipient, uint256 amount);
    event PaymentUpdated(address  admin, uint256  ID, uint256  amount, string  recipient);


   constructor(address[] memory _admins, uint256 _totalSupply) {
        totalSupply = _totalSupply;
      
        for (uint256 ii = 0;ii<administrators.length ;ii++){
            if(_admins[ii] != address(0)){ 
                administrators[ii] = _admins[ii];
                _setupRole(ADMIN_ROLE, _admins[ii]);
            }
        }

        balances[msg.sender] = totalSupply;
        emit supplyChanged(msg.sender, totalSupply);
   }

   function transfer(address _recipient, uint _amount, string calldata _name) external {
        require(balances[msg.sender] >= _amount,"Insufficient Balance");
        require(bytes(_name).length < 9,"Name is too long, max of 8");
        
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        emit Transfer(_recipient, _amount);

        Payment memory payment;
        payment.paymentType = PaymentType.BasicPayment;
        payment.recipient = _recipient;
        payment.amount = _amount;
        payment.recipientName = _name;
        payment.paymentID = ++paymentCounter;
        payments[msg.sender].push(payment);
    }

    function updatePayment(address _user, uint _ID, uint _amount, PaymentType _type) external onlyRole(ADMIN_ROLE) {
        require(_ID > 0,"ID must be > 0");
        require(_amount > 0,"Amount must be > 0");
        require(_user != address(0) ,"Must have a valid address");

        for (uint256 ii=0;ii<payments[_user].length;ii++){
            if(payments[_user][ii].paymentID==_ID){
                payments[_user][ii].adminUpdated = true; 
                payments[_user][ii].admin = _user;
                payments[_user][ii].paymentType = _type;
                payments[_user][ii].amount = _amount;
                emit PaymentUpdated(msg.sender, _ID, _amount, payments[_user][ii].recipientName);
                break;
            }
        }
    }
   
    function balanceOf(address _user) external view returns (uint balance_){
        uint balance = balances[_user];
        return balance; 
    }

   function getPayments(address _user) external view returns (Payment[] memory payments_) {
        require(_user != address(0) ,"Must have a valid address");
        return payments[_user];
    }

    function getTradingMode() external view returns (bool mode_){
         return true;
     }    

}