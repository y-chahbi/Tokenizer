# Ycbm42 (YCM42)

## Overview
Ycbm42 is an ERC-20 token created as part of the 42 School Tokenizer project. It is deployed on the Sepolia testnet using Remix IDE and OpenZeppelin contracts.

## File Structure

tokenizer/
├── code/
│ └── Ycbm42.sol
├── deployment/
│ └── deployment-instructions.md
├── documentation/
│ └── README.md
└── README.md

## Features
- **Name**: Ycbm42  
- **Symbol**: YCM42  
- **Initial Supply**: 1,000,000 YCM42 (18 decimals)  
- **Standard**: ERC-20 compliant  
- **Security**: Uses OpenZeppelin’s audited implementation

## Deployment
- **Network**: Sepolia Testnet  
- **Contract Address**: [`0x8e848ecd36c86c9e5a5cf886472ad4f5443b7f43`](https://sepolia.etherscan.io/address/0x8e848ecd36c86c9e5a5cf886472ad4f5443b7f43)

## Project Goal
This 42 project aims to explore the fundamentals of Web3 by creating a personal token. The goal is to learn blockchain technology and the principles of decentralization.

## Web3 Introduction
Web3, or Web 3.0, is the decentralized internet built on blockchain, peer-to-peer networks, and distributed systems. Unlike Web 2.0, Web3 gives users control over their data and interactions without relying on centralized entities.

Web3 enables decentralized applications (dApps) across various domains like finance (DeFi), gaming, governance, and more.

## Implementation Choices

### Why Ethereum and ERC-20
Ethereum is the most established smart contract platform. ERC-20 is the most widely used standard for creating fungible tokens, ensuring broad compatibility with wallets and dApps.

### Why Solidity
Solidity is the primary language for writing Ethereum smart contracts. It's statically typed, supports inheritance and libraries, and targets the Ethereum Virtual Machine (EVM).

### Why Remix IDE
Remix is a beginner-friendly web-based IDE for writing, compiling, and deploying smart contracts. It’s ideal for fast prototyping and testing.

### Why OpenZeppelin
OpenZeppelin provides reusable and secure smart contract libraries. Their ERC-20 implementation is battle-tested and widely trusted in the Ethereum ecosystem.

### Why MetaMask
MetaMask is a browser extension wallet that allows easy interaction with dApps and token contracts on Ethereum testnets and the mainnet.

## Cryptographic Foundations
Modern cryptography ensures blockchain integrity through four pillars:
- **Confidentiality**: Only authorized parties can access the data.
- **Integrity**: Data can’t be tampered with unnoticed.
- **Authentication**: Participants can verify each other’s identity.
- **Non-repudiation**: Actions cannot be denied after the fact.

## Token vs Coin
- **Coins**: Native to a blockchain (e.g., ETH, BTC).
- **Tokens**: Built on existing blockchains (e.g., YCM42 on Ethereum).

## Key Technologies

### Blockchain
A blockchain is a decentralized ledger where each block contains transaction data and a cryptographic link to the previous block. Once added, blocks cannot be altered, ensuring data immutability.

### Smart Contract
A smart contract is a blockchain program that runs automatically when certain conditions are met. It enables decentralized apps (dApps) and advanced features by supporting complex operations beyond simple transactions.

### Token
A token is a digital asset created on a blockchain, often representing value or rights. ERC-20 tokens like YCM42 follow a standard, making them easy to use with wallets and dApps.

### Coin 
A coin is the native cryptocurrency of a blockchain, used primarily for transactions, paying network fees, and securing the network (e.g., ETH on Ethereum, BTC on Bitcoin). Coins operate on their own blockchain, unlike tokens which are built on top of existing blockchains.

### Wallet
A wallet is a software or hardware tool that allows users to store, send, and receive cryptocurrencies and tokens. Wallets manage private keys, enabling secure access and control over blockchain assets.

### Etherscan
Etherscan is a blockchain explorer for Ethereum networks. It allows users to view transactions, contract details, and token information, providing transparency and traceability for all on-chain activity.

### Gas
Gas is the unit that measures the computational effort required to execute operations on the Ethereum network. Users pay gas fees in ETH to incentivize miners or validators to process transactions and smart contract executions.

### Testnet
A testnet is a parallel blockchain used for testing and development. It allows developers to deploy and interact with smart contracts without risking real assets, using test tokens instead of real cryptocurrency.
