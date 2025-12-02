// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.5.0
pragma solidity ^0.8.27;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

/// @custom:security-contact zane3412x@gmail.com
contract XFY is ERC20, AccessControl, ERC20Permit {

    bytes32 public constant CCIP_MINT_BURN_ROLE = keccak256("CCIP_MINT_BURN_ROLE");

    address CCIP_ADMIN;

    event Minted(address indexed operator, address indexed to, uint256 amount);
    event Burned(address indexed operator, address indexed from, uint256 amount);

    constructor(address recipient, address defaultAdmin)
        ERC20("XFY", "XFY")
        ERC20Permit("XFY")
    {
        _mint(recipient, 1000000000 * 10 ** decimals());
        CCIP_ADMIN = defaultAdmin;
        _grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
    }

    function getCCIPAdmin() external view returns (address) {
        return CCIP_ADMIN;
    }

    function mint(address to, uint256 amount) external onlyRole(CCIP_MINT_BURN_ROLE) { 
        _mint(to, amount);
        emit Minted(msg.sender, to, amount);
    }

    function burn(address from, uint256 amount) external onlyRole(CCIP_MINT_BURN_ROLE){
        _burn(from, amount);
        emit Burned(msg.sender, from, amount);
    }

}
