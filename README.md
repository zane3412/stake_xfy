🪙 XFY Token — CCIP Burn/Mint ERC20
A Chainlink CCIP-compatible ERC20 token with role-based mint and burn.

🔒 Audited • MIT / BUSL-1.1 • OpenZeppelin v5.5+

⚠️ Critical Deployment Step

After deploying both contracts, you MUST run:

```solidity
xfyToken.grantCcipRole(xfyTokenPoolAddress);
```
- Why? The XFYTokenPool needs this role to burn tokens during outbound CCIP transfers.
- If skipped: Cross-chain bridging will fail completely.

💡 All mint/burn amounts are in smallest unit (e.g., 100 * 10^18 for 100 tokens with 18 decimals).

📦 Contracts

- XFYToken.sol — Main token (MIT)
- XFYTokenPool.sol — CCIP pool (BUSL-1.1)