// SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.8.0;
// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

// contract VolcanoCoin is ERC20("Volcano Coin", "VLC"), Ownable {
contract VolcanoCoinV2 is Initializable, ERC20Upgradeable, UUPSUpgradeable, OwnableUpgradeable {

    uint256 constant public versionNumber = 2;
    uint256 constant initialSupply = 10000;
    
    struct Payment {
        uint256 amount;
        address to;
    }
    
    mapping(address => Payment[]) public payments;
    
    event TotalSupplyIncreased(uint256);
    
    // constructor() {
    //     _mint(msg.sender, initialSupply);
    // }

    function initialize() initializer public {
        __ERC20_init("Volcano Coin", "VLC");
        __Ownable_init();
        __UUPSUpgradeable_init();
        _mint(msg.sender, initialSupply);
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    function _authorizeUpgrade(address) internal override onlyOwner {}
    
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
        payments[_sender].push(Payment(_amount, _recipient));
    }
    
}