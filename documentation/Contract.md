# Ycbm42 ERC-20 Token — Smart Contract Documentation

## Overview

This Solidity contract defines an ERC-20 token named **Ycbm42** with the symbol **YCM42**. It leverages the trusted OpenZeppelin library to ensure security and standards compliance.

Key features include:  
- Importing OpenZeppelin’s ERC-20 implementation  
- Defining the `Ycbm42` token with symbol `YCM42`  
- Minting an initial supply of 1,000,000 tokens to the deployer

---

## Code

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Ycbm42 is ERC20 {
    constructor() ERC20("Ycbm42", "YCM42") {
        _mint(msg.sender, 1_000_000 * 10 ** 18);
    }
}
```

---

## Detailed Explanation

### `// SPDX-License-Identifier: MIT`

- Specifies the open-source license for this contract.  
- MIT license allows use, modification, and distribution with minimal restrictions.

### `pragma solidity ^0.8.0;`

- Defines the Solidity compiler versions compatible with this contract.  
- Compatible with any version from 0.8.0 up to (but not including) 0.9.0.

### `import "@openzeppelin/contracts/token/ERC20/ERC20.sol";`

- Imports OpenZeppelin's implementation of the ERC-20 standard.  
- OpenZeppelin contracts are widely audited and considered secure.  
- Provides all core ERC-20 functionality such as transfer and approval mechanisms.

### `contract Ycbm42 is ERC20 {`

- Declares the smart contract named **Ycbm42**.  
- Inherits from OpenZeppelin’s `ERC20` contract to include all standard ERC-20 features.

### `constructor() ERC20("Ycbm42", "YCM42") {`

- Contract constructor executed upon deployment.  
- Calls the parent `ERC20` constructor with the token name and symbol.  
- These identify the token in wallets and block explorers.

### `_mint(msg.sender, 1000 * 10 ** 18);`

- Mints 1000 tokens (with 18 decimal places) to the deployer’s address (`msg.sender`).  
- ERC-20 tokens typically use 18 decimals, enabling fractional units.

---

## Why 18 Decimals?

The ERC-20 standard uses 18 decimals by default, mirroring Ethereum’s native currency (ETH).  
This allows for precise, fractional transactions suitable for a wide variety of applications.

---

## Deployment Workflow

- When deployed, the contract’s constructor:  
  1. Sets the token’s name and symbol.  
  2. Mints the initial supply to the deployer’s wallet.

---

## Available ERC-20 Functions

This contract supports all standard ERC-20 functions, including:

| Function                  | Description                                    |
|---------------------------|------------------------------------------------|
| `balanceOf(address)`      | Returns the token balance of the specified address |
| `transfer(address, uint)` | Sends tokens to another address                |
| `approve(address, uint)`  | Approves a spender to spend tokens on your behalf |
| `transferFrom`            | Transfers tokens from one account using allowance |
| `totalSupply()`           | Returns total tokens minted                     |
| `allowance(owner, spender)` | Returns remaining tokens allowed to spender  |

---

## Security Notes

- The contract uses OpenZeppelin’s audited ERC-20 codebase, which minimizes common vulnerabilities.  
- Minting is restricted to the constructor to prevent unauthorized inflation.  
- For advanced use cases, consider adding features like token burning, pausing, or access controls.

---

## Testing the Contract

You can verify and interact with the contract via [Remix IDE](https://remix.ethereum.org/):

1. Paste the contract code into a new Solidity file.  
2. Make sure the OpenZeppelin library is accessible (via Remix imports).  
3. Compile with Solidity version ^0.8.0.  
4. Deploy the contract using the JavaScript VM or a connected wallet.  
5. Call `balanceOf` on the deployer’s address to confirm the minted tokens.

---

## Summary

| Property       | Value          |
|----------------|----------------|
| Token Name     | Ycbm42         |
| Token Symbol   | YCM42          |
| Total Supply   | 1,000,000 YCM42 |
| Decimals       | 18             |
| Token Standard | ERC-20         |
| Library Used   | OpenZeppelin   |

---

## Adding the Token to MetaMask

1. Switch MetaMask to the Sepolia test network.  
2. Select “Import Tokens.”  
3. Enter the contract address.  
4. Token symbol: `YCM42`  
5. Decimals: `18`

## Token Interaction Possibilities

- Transfer tokens between accounts.  
- Use compatible decentralized applications (dApps).  
- Monitor balances and transactions on Etherscan.