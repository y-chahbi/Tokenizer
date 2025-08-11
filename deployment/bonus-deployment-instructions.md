# Deploying Ycbmb42 Multi-Signature ERC-20 Token Contract

## Overview
Ycbmb42 is an ERC-20 token contract with built-in multi-signature transaction functionality.  
Multiple owners can submit, confirm, revoke, and execute token transfer transactions collectively, requiring a minimum number of confirmations to execute.

---

## Prerequisites
- MetaMask wallet connected to the **Sepolia Testnet** (or your preferred testnet)
- Test ETH for gas fees (obtain from a Sepolia faucet like [sepoliafaucet.com](https://sepoliafaucet.com/))
- Access to [Remix IDE](https://remix.ethereum.org/) or another Solidity development environment

---

## Deployment Instructions

1. Open Remix IDE and create a new Solidity file named `Ycbmb42.sol`.
2. Paste the full contract code into the file.
3. Set the Solidity compiler version to **^0.8.0**.
4. Compile the contract.
5. In the **Deploy & Run Transactions** panel, select `Injected Provider - MetaMask` as the environment.
6. Deploy the contract by calling the constructor with the following parameters:
    - `_owners` (address[]): List of wallet addresses that will be owners of the multisig contract.
    - `_required` (uint): Number of confirmations required to execute a transaction.
   
   Example:
```["0xOwnerAddress1", "0xOwnerAddress2", "0xOwnerAddress3"], 2```

7. Confirm the deployment transaction in MetaMask and wait for confirmation.

---

## Post-Deployment

- The contract mints **1,000,000 YCB42 tokens** to itself (`address(this)`).
- Owners can submit transfer requests which require multiple confirmations before execution.

---

## Interacting with the Contract

### Submit a Transaction
- Call `submitTransaction(address _to, uint256 _amount)` as an owner.
- This creates a new transaction requesting to transfer `_amount` tokens to `_to`.
- The submitter automatically confirms the transaction.

### Confirm a Transaction
- Other owners can call `confirmTransaction(uint _txIndex)` to approve a pending transaction.

### Revoke Confirmation
- Owners who previously confirmed can call `revokeConfirmation(uint _txIndex)` to withdraw their approval.

### Execute Transaction
- Once the required number of confirmations is reached, the transaction executes automatically.
- Alternatively, anyone can call `executeTransaction(uint _txIndex)` to trigger execution if conditions are met.

---

## Events

- `SubmitTransaction(uint indexed txIndex, address indexed to, uint amount)` — emitted when a transaction is submitted.
- `ConfirmTransaction(address indexed owner, uint indexed txIndex)` — emitted when an owner confirms a transaction.
- `RevokeConfirmation(address indexed owner, uint indexed txIndex)` — emitted when an owner revokes confirmation.
- `ExecuteTransaction(uint indexed txIndex)` — emitted when a transaction is executed.

---

## Notes

- The contract enforces multi-signature security by requiring multiple owner approvals.
- Tokens are held by the contract itself until transactions are executed.
- The number of owners and confirmations required is set at deployment and cannot be changed afterward.

---

## Example Constructor Parameters

| Parameter  | Description                                  | Example                                |
|------------|----------------------------------------------|----------------------------------------|
| `_owners`  | Array of multisig owners' Ethereum addresses | `["0x123...", "0x456...", "0x789..."]` |
| `_required`| Minimum number of confirmations needed       | `2`                                    |

---

## Summary

| Feature                 | Details                          |
|-------------------------|---------------------------------|
| Token Name              | Ycbmb42                        |
| Token Symbol            | YCB42                          |
| Initial Supply          | 1,000,000 tokens               |
| Decimals                | 18 (default ERC-20)            |
| Multi-Signature Owners  | Configurable at deployment     |
| Confirmations Required  | Configurable at deployment     |
| Blockchain Network      | Sepolia Testnet (recommended)  |

---