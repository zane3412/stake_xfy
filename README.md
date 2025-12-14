🪙 XFY Token — CCIP Burn/Mint ERC20

A Chainlink CCIP-compatible ERC20 token with role-based mint and burn.

🔒 Audited by InterFi (Dec 10, 2025) • MIT / BUSL-1.1 • OpenZeppelin v5.5+

⚠️ Critical Configuration via Timelock

After deploying all contracts, you MUST grant the pool the required role through the governance timelock:

xfyToken.grantCcipMintBurnRole(xfyTokenPoolAddress);
This operation must follow the full governance workflow:

Propose via Multisig → TimelockController
Wait 7 days (minimum delay)
Execute via Multisig (or designated executor)
● Why? The XFYTokenPool requires the CCIP_MINT_BURN_ROLE to burn tokens during outbound CCIP transfers.

● If skipped or bypassed: Cross-chain bridging will fail completely.

💡 All mint/burn amounts — including constructor’s initialSupply, mint(), and burn() — are expressed in the smallest token unit (e.g., 100 * 10^18 for 100 tokens with 18 decimals). This ensures consistency across CCIP messaging and on-chain logic.

🔐 Governance Security Model

To mitigate centralization risks identified in the audit, all privileged operations are protected by a two-layer governance system:

Multisig Wallet (e.g., Gnosis Safe): Proposes changes (holds PROPOSER_ROLE).
XFYTImelockController.sol: Enforces a 7-day minimum delay before execution.
Target Contracts: Only accept admin calls from the timelock — no EOA has direct control.
This applies to:

Granting CCIP_MINT_BURN_ROLE or REPURCHASE_ROLE
Accepting ownership of the pool
Configuring cross-chain routes and rate limits
The design ensures:

✅ Time for public review (7-day visibility)

✅ Multi-party approval (no single point of failure)

✅ Deterministic, replay-safe execution

“At deployment, ownership of both XFYToken and XFYTokenPool is transferred to the XFYTImelockController contract.”

Long-term: migrate admin rights to community DAO.

📦 Contracts

XFYToken.sol — Main token (MIT)
XFYTokenPool.sol — CCIP bridge pool (BUSL-1.1)
XFYTImelockController.sol — Governance timelock (MIT)
ℹ️ Audit Note: All medium-severity findings from the InterFi report (e.g., inconsistent units, missing role grants, centralization) have been addressed through code standardization, explicit documentation, and the introduction of timelocked governance with a 7-day minimum delay.

