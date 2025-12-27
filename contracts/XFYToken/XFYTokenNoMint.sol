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
contract XFYTokenNoMint is ERC20, AccessControlEnumerable, ERC20Permit {
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

    event RepurchaseBurn(
        address indexed operator,
        address indexed from,
        uint256 amount
    );

    event CcipMintBurnRoleGranted(
        address indexed account,
        address indexed granter
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

    /// @notice Returns the admin address expected by Chainlink CCIP's registration flow.
    /// @dev This function is required for compatibility with 
    ///      `RegistryModuleOwnerCustom.registerAdminViaGetCCIPAdmin()`.
    ///      It returns the first account granted DEFAULT_ADMIN_ROLE.
    ///      ⚠️ Important: 
    ///        - This is NOT a CCIP-specific role; it's the standard OpenZeppelin DEFAULT_ADMIN.
    ///        - If multiple admins exist, only the first (index 0) is returned.
    ///        - The returned address has full control over roles (e.g., can grant mint/burn rights).
    /// @return The default admin address used for CCIP token registration.
    function getCCIPAdmin() external view returns (address) {
        // Reverts if no admin exists, but constructor ensures one is set.
        return getRoleMember(DEFAULT_ADMIN_ROLE, 0);
    }

    function repurchaseBurn(uint256 amount) external onlyRole(REPURCHASE_ROLE) {
        _burn(msg.sender, amount);
        emit RepurchaseBurn(msg.sender, msg.sender, amount);
    }

    /// @notice Burns caller's tokens.
    /// @param amount Amount in smallest unit (scaled by 10^decimals).
    function burn(uint256 amount) external onlyRole(CCIP_MINT_BURN_ROLE) {
        _burn(msg.sender, amount);
        emit CcipBurn(msg.sender, msg.sender, amount);
    }

    function grantCcipMintBurnRole(
        address account
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(CCIP_MINT_BURN_ROLE, account);
        emit CcipMintBurnRoleGranted(account, msg.sender);
    }
}
