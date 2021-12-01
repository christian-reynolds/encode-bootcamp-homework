// SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VolcanoCoin is ERC20, Ownable {
    
    struct Payment {
        uint256 amount;
        address to;
    }
    
    mapping(address => Payment[]) public _payments;
    
    event TotalSupplyIncreased(uint256);
    
    constructor() ERC20("Volcano", "VOL") {
        _mint(msg.sender, 10000);
    }
    
    function changeTokenSupply() public onlyOwner {
        _mint(msg.sender, 1000);
        emit TotalSupplyIncreased(1000);
    }
    
    function getPayments(address addr) public view returns (Payment[] memory) {
        return _payments[addr];
    }
    
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        recordPayment(msg.sender, recipient, amount);
        return true;
    }
    
    function recordPayment(address sender, address recipient, uint256 amount) internal {
        _payments[sender].push(Payment(amount, recipient));
    }
    
}