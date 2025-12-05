// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.5.0
pragma solidity ^0.8.27;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {
    ERC20Permit
} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";


/// @custom:security-contact zane3412x@gmail.com
contract XFYToken is ERC20, AccessControl, ERC20Permit {

    bytes32 public constant CCIP_MINT_BURN_ROLE =
        keccak256("CCIP_ADMIN");
    
    bytes32 public constant REPURCHASE_ROLE =
        keccak256("REPURCHASE_ROLE");

    address CCIP_ADMIN;

     // === CCIP 操作事件 ===
    event CcipMint(address indexed operator, address indexed to, uint256 amount);
    event CcipBurn(address indexed operator, address indexed from, uint256 amount);

    constructor(
        address recipient,
        address defaultAdmin,
        uint256 initialSupply,
        string memory name_, 
        string memory symbol_
    ) ERC20(name_, symbol_) ERC20Permit(name_) {
        if (initialSupply > 0) {
            _mint(recipient, initialSupply * 10 ** decimals());
        }
        CCIP_ADMIN = defaultAdmin;
        _grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
    }

    function getCCIPAdmin() external view returns (address) {
        return CCIP_ADMIN;
    }

    function burn(uint256 amount) external onlyRole(CCIP_MINT_BURN_ROLE) onlyRole(REPURCHASE_ROLE) {
        _burn(msg.sender, amount);
    }

    function mint(address to, uint256 amount) external onlyRole(CCIP_MINT_BURN_ROLE){
        _mint(to, amount);
         emit CcipMint(msg.sender, to, amount);
    }

    function burn(address from, uint256 amount) external onlyRole(CCIP_MINT_BURN_ROLE){
        _burn(from, amount);
        emit CcipBurn(msg.sender, from, amount);
    }

    function burnFrom(
        address from,
        uint256 amount
    ) external onlyRole(CCIP_MINT_BURN_ROLE) {
        _spendAllowance(from, msg.sender, amount);
        _burn(from, amount);
        emit CcipBurn(msg.sender, from, amount);
    }


    function grantCcipRole(address account) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(CCIP_MINT_BURN_ROLE, account);
    }

}
