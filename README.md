# Ycbm42 (YCM42)

## Overview
**Ycbm42** is a custom ERC-20 token developed as part of the **42 School Tokenizer** project.  
It’s deployed on the **Sepolia testnet** using the Remix IDE and built on top of OpenZeppelin’s secure, community-trusted contracts.

## File Structure

```tokenizer/
├── code/
│ ├── Ycbm42.sol
│ └── Ycbmb42.sol
├── deployment/
│ ├── deployment-instructions.md
│ └── bonus-deployment-instructions.md
├── documentation/
│ ├── Contract.md
│ └── MultiSignContract.md
└── README.md```

## Features
- **Token Name**: Ycbm42  
- **Symbol**: YCM42  
- **Initial Supply**: 1,000,000 YCM42 (with 18 decimal places)  
- **Standard**: Fully ERC-20 compatible  
- **Security**: Built using OpenZeppelin’s audited implementation for maximum reliability

## Deployment
- **Blockchain Network**: Sepolia Testnet  
- **Smart Contract Address**: [`0x8e848ecd36c86c9e5a5cf886472ad4f5443b7f43`](https://sepolia.etherscan.io/address/0x8e848ecd36c86c9e5a5cf886472ad4f5443b7f43)

## Bonus Deployment Instructions
In addition to the main deployment steps found in `deployment/deployment-instructions.md`, the bonus instructions include:  
- Deploying the multisignature variant `Ycbmb42.sol` located in the `code/` directory.  
- Setting up multiple owners and the required confirmation count for secure transaction approvals.  
- Using the multi-owner wallet features to manage token transfers collaboratively.  
- Monitoring and interacting with multisig transactions via emitted events detailed in `documentation/MultiSignContract.md`.

For detailed bonus deployment steps, please refer to `deployment/bonus-deployment-instructions.md`.

## Project Purpose
This project is part of an educational journey to understand **Web3 fundamentals**, token creation, and blockchain development.  
The end goal is to gain hands-on experience with smart contracts, token standards, and decentralized ecosystems.

## Web3 in Brief
Web3 represents the next generation of the internet — decentralized, trustless, and user-owned.  
Unlike Web 2.0, where data and control are centralized, Web3 leverages **blockchain technology** to give power back to the users through smart contracts and peer-to-peer networks.

It opens the door to:
- Decentralized finance (**DeFi**)
- On-chain governance
- Blockchain gaming
- Digital ownership and NFTs

## Implementation Decisions

### Ethereum + ERC-20
Ethereum offers the most mature ecosystem for smart contracts.  
The ERC-20 standard guarantees that Ycbm42 works seamlessly with wallets, exchanges, and other dApps.

### Solidity
Chosen because it’s the native language for Ethereum smart contracts — supporting inheritance, libraries, and strong typing.

### Remix IDE
Perfect for rapid prototyping and deployment directly from the browser without complicated setup.

### OpenZeppelin
Trusted, reusable, and secure — the de facto standard for production-ready smart contract components.

### MetaMask
The go-to wallet for interacting with Ethereum networks, making testing and deployment straightforward.

## Blockchain Security Pillars
Ycbm42’s foundation rests on these cryptographic principles:
- **Confidentiality** – Only intended parties can view sensitive data.
- **Integrity** – Data on-chain is immutable once recorded.
- **Authentication** – Verifies identities of participants.
- **Non-repudiation** – Prevents denial of transactions after execution.

## Token vs. Coin
- **Coins**: Native to their own blockchain (e.g., ETH, BTC).  
- **Tokens**: Built on top of an existing blockchain (e.g., YCM42 on Ethereum).

## Key Concepts

### Blockchain
A distributed ledger where transactions are stored in linked blocks, secured by cryptography.

### Smart Contracts
Self-executing programs on the blockchain that follow predefined rules.

### Token
A blockchain-based asset representing value, access rights, or both.  
YCM42 follows the ERC-20 standard for interoperability.

### Coin
The primary currency of a blockchain, used for network fees and security.

### Wallet
A tool for securely storing and managing blockchain assets and private keys.

### Etherscan
An explorer for Ethereum where you can view transactions, contract code, and token details.

### Gas
A fee paid in ETH to execute transactions or run smart contracts on the Ethereum network.

### Testnet
A sandbox version of the blockchain for experimentation without using real funds.
