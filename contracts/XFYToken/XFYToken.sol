// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.5.0
/// @notice This token is designed to work with Chainlink CCIP.
///         ALL amounts — including constructor's `initialSupply`, and all `mint`/`burn` calls —
///         are expected in the **smallest unit** (i.e., scaled by 10^decimals).
///         Example: for 100 tokens with 18 decimals, use 100 * 10^18.
///
/// @dev IMPORTANT: The XFYTokenPool contract must be granted the CCIP_MINT_BURN_ROLE
///      after deployment, otherwise cross-chain bridging will revert.
pragma solidity ^0.8.27;

import {
    AccessControlEnumerable
} from "@openzeppelin/contracts/access/extensions/AccessControlEnumerable.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {
    ERC20Permit
} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

/// @custom:security-contact zane3412x@gmail.com
contract XFYToken is ERC20, AccessControlEnumerable, ERC20Permit {
    bytes32 public constant CCIP_MINT_BURN_ROLE =
        keccak256("CCIP_MINT_BURN_ROLE");

    bytes32 public constant REPURCHASE_ROLE = keccak256("REPURCHASE_ROLE");

    // === CCIP 操作事件 ===
    event CcipMint(
        address indexed operator,
        address indexed to,
        uint256 amount
    );
    event CcipBurn(
        address indexed operator,
        address indexed from,
        uint256 amount
    );

<<<<<<< HEAD
    event RepurchaseBurn(
        address indexed operator,
        address indexed from,
        uint256 amount
    );

    /// @notice Deploys the XFYToken with an initial supply.
    /// @dev The `initialSupply` must be provided in the **smallest token unit**
    ///      (i.e., already scaled by 10^decimals). For example, to create 1 million tokens
    ///      with 18 decimals, pass `1_000_000 * 10**18`.
    /// @param recipient Address to receive the initial supply.
    /// @param defaultAdmin Admin who can grant roles.
    /// @param initialSupply Total supply in smallest unit (not human-readable!).
    /// @param name_ Token name.
    /// @param symbol_ Token symbol.
=======
    event RepurchaseBurn(address indexed operator, address indexed from, uint256 amount);

>>>>>>> aed9974c21187eeca9011071469326c205c4bc4a
    constructor(
        address recipient,
        address defaultAdmin,
        uint256 initialSupply,
        string memory name_,
        string memory symbol_
    ) ERC20(name_, symbol_) ERC20Permit(name_) {
        if (initialSupply > 0) {
            _mint(recipient, initialSupply);
        }
        _grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);
    }

    function getCCIPAdmin() external view returns (address) {
        return getRoleMember(DEFAULT_ADMIN_ROLE, 0);
    }

<<<<<<< HEAD
    function repurchaseBurn(uint256 amount) external onlyRole(REPURCHASE_ROLE) {
        _burn(msg.sender, amount);
        emit RepurchaseBurn(msg.sender, msg.sender, amount);
=======

    function repurchaseBurn(uint256 amount) external onlyRole(REPURCHASE_ROLE){
        _burn(msg.sender, amount);
        emit RepurchaseBurn(msg.sender, msg.sender, amount);
    }


    function burn(uint256 amount) external onlyRole(CCIP_MINT_BURN_ROLE) {
        _burn(msg.sender, amount);
        emit CcipBurn(msg.sender, msg.sender, amount);
>>>>>>> aed9974c21187eeca9011071469326c205c4bc4a
    }

    function burn(uint256 amount) external onlyRole(CCIP_MINT_BURN_ROLE) {
        _burn(msg.sender, amount);
        emit CcipBurn(msg.sender, msg.sender, amount);
    }

    /// @notice Mints tokens for CCIP inbound messages.
    /// @param to Recipient address.
    /// @param amount Amount in **smallest unit** (e.g., wei for 18-decimal token).
    /// @dev Only callable by accounts with CCIP_MINT_BURN_ROLE (typically the TokenPool).
    function mint(
        address to,
        uint256 amount
    ) external onlyRole(CCIP_MINT_BURN_ROLE) {
        _mint(to, amount);
        emit CcipMint(msg.sender, to, amount);
    }

    function burn(
        address from,
        uint256 amount
    ) external onlyRole(CCIP_MINT_BURN_ROLE) {
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

    function grantCcipRole(
        address account
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(CCIP_MINT_BURN_ROLE, account);
    }
}
