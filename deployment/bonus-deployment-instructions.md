# Ycbmb42 Multi-Signature Wallet Deployment Guide
## Remix IDE & Sepolia Testnet

This guide provides step-by-step instructions for deploying the Ycbmb42 multi-signature wallet contract using Remix IDE on the Sepolia Ethereum testnet.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Environment Setup](#environment-setup)
3. [Contract Preparation](#contract-preparation)
4. [Deployment Process](#deployment-process)
5. [Contract Verification](#contract-verification)
6. [Testing & Interaction](#testing--interaction)
7. [Common Issues & Troubleshooting](#common-issues--troubleshooting)
8. [Post-Deployment Checklist](#post-deployment-checklist)

---

## Prerequisites

### Required Tools & Accounts

- **Remix IDE**: Access to [remix.ethereum.org](https://remix.ethereum.org)
- **MetaMask Wallet**: Browser extension installed and configured
- **Sepolia ETH**: Test Ether for gas fees
- **Test Accounts**: At least 2-3 Ethereum addresses for multi-sig owners

### Getting Sepolia Test ETH

1. **Sepolia Faucets** (Choose one):
   - [Sepolia Faucet by Alchemy](https://sepoliafaucet.com/)
   - [Chainlink Sepolia Faucet](https://faucets.chain.link/sepolia)
   - [Infura Sepolia Faucet](https://www.infura.io/faucet/sepolia)

2. **Steps to Get Test ETH**:
   - Connect your MetaMask wallet
   - Enter your wallet address
   - Request test ETH (usually 0.5-1 ETH per request)
   - Wait for confirmation

---

## Environment Setup

### 1. MetaMask Configuration

#### Add Sepolia Network to MetaMask

If Sepolia isn't in your MetaMask networks:

1. Open MetaMask
2. Click the network dropdown (usually shows "Ethereum Mainnet")
3. Click "Add Network" → "Add a network manually"
4. Enter the following details:

```
Network Name: Sepolia Test Network
New RPC URL: https://sepolia.infura.io/v3/YOUR_PROJECT_ID
Chain ID: 11155111
Currency Symbol: SepoliaETH
Block Explorer URL: https://sepolia.etherscan.io
```

**Alternative RPC URLs**:
- Alchemy: `https://eth-sepolia.g.alchemy.com/v2/YOUR_API_KEY`
- Chainstack: `https://ethereum-sepolia.blockpi.network/v1/rpc/public`
- Public: `https://rpc.sepolia.org`

#### Switch to Sepolia Network

1. Click the network dropdown in MetaMask
2. Select "Sepolia Test Network"
3. Ensure you have test ETH in your balance

### 2. Remix IDE Setup

1. Open [Remix IDE](https://remix.ethereum.org)
2. Create a new workspace or use the default
3. Ensure you have the following plugins enabled:
   - **Solidity Compiler**
   - **Deploy & Run Transactions**
   - **File Manager**

---

## Contract Preparation

### 1. Create Contract Files

#### Step 1: Create the main contract file

1. In Remix, right-click on the `contracts` folder
2. Select "New File"
3. Name it `Ycbmb42.sol`
4. Copy and paste your contract code:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Ycbmb42 is ERC20, ReentrancyGuard {
    // [Your complete contract code here]
}
```

### 2. Prepare Constructor Parameters

Before deployment, prepare your constructor parameters:

#### Example Configuration:

```javascript
// Owner addresses (use your test accounts)
const owners = [
    "0x1234567890123456789012345678901234567890", // Owner 1
    "0x2345678901234567890123456789012345678901", // Owner 2
    "0x3456789012345678901234567890123456789012"  // Owner 3
];

// Required confirmations (2 out of 3 in this example)
const required = 2;
```

**⚠️ Important**: Use actual Ethereum addresses you control on Sepolia testnet.

---

## Deployment Process

### Step 1: Compile the Contract

1. **Select Compiler Tab**: Click on the Solidity Compiler tab (📄 icon)

2. **Configure Compiler Settings**:
   - **Compiler Version**: Select `0.8.19` or higher
   - **Language**: Solidity
   - **EVM Version**: London (recommended)
   - **Optimization**: Enable with 200 runs

3. **Compile Contract**:
   - Select `Ycbmb42.sol` in the file explorer
   - Click "Compile Ycbmb42.sol"
   - Check for compilation errors in the terminal

4. **Verify Compilation**:
   ```
   ✅ Compilation successful
   ✅ No errors or warnings
   ✅ Contract artifacts generated
   ```

### Step 2: Configure Deployment Environment

1. **Open Deploy Tab**: Click on "Deploy & Run Transactions" tab (🚀 icon)

2. **Environment Settings**:
   - **Environment**: Select "Injected Provider - MetaMask"
   - **Account**: Ensure correct account is selected
   - **Gas Limit**: 3000000 (or leave default)
   - **Value**: 0 (we're not sending ETH)

3. **Contract Selection**:
   - **Contract**: Select "Ycbmb42" from dropdown
   - Verify contract is properly loaded

### Step 3: Set Constructor Parameters

In the deployment section, you'll see input fields for constructor parameters:

#### Format for Input Fields:

1. **_owners** (address[] memory):
   ```
   ["0x1234567890123456789012345678901234567890","0x2345678901234567890123456789012345678901","0x3456789012345678901234567890123456789012"]
   ```

2. **_required** (uint256):
   ```
   2
   ```

#### Example Real Addresses for Testing:

```json
{
  "owners": [
    "0x742d35Cc6464C1Da8B7d7736b4c8a6C2F5a3F9D1",
    "0x8ba1f109551bD432803012645Hac136c6c9a1B1A",
    "0x95222290DD7278Aa3Ddd389Cc1E1d165CC4BAfe5"
  ],
  "required": 2
}
```

### Step 4: Deploy Contract

1. **Review Parameters**: Double-check all input parameters

2. **Estimate Gas**: Click "Transact" to see gas estimation

3. **Deploy**:
   - Click the orange "transact" button
   - MetaMask will pop up asking for confirmation
   - Review gas fee and confirm transaction

4. **Wait for Confirmation**:
   - Monitor the Remix terminal for deployment status
   - Check MetaMask for transaction confirmation
   - Note the contract address once deployed

### Step 5: Deployment Confirmation

#### Successful Deployment Output:

```
✅ Transaction confirmed
📍 Contract Address: 0x...
⛽ Gas Used: 2,847,291
💰 Transaction Hash: 0x...
```

**Save Important Information**:
- Contract Address
- Transaction Hash
- Deployment Block Number
- Gas Used

---

## Contract Verification

### 1. Verify on Sepolia Etherscan

1. **Visit Sepolia Etherscan**: [sepolia.etherscan.io](https://sepolia.etherscan.io)

2. **Find Your Contract**:
   - Search for your contract address
   - You should see the contract creation transaction

3. **Verify Contract** (Optional but recommended):
   - Go to the "Contract" tab
   - Click "Verify and Publish"
   - Select "Solidity (Single File)"
   - Upload your contract source code
   - Set compiler version to match Remix

### 2. Verify Deployment in Remix

#### Check Contract Instance:

1. In the Deploy tab, you should see your deployed contract instance
2. Expand the contract to see available functions
3. Test some view functions:

```solidity
// Test these functions:
✅ getOwners() - Should return your owner addresses
✅ required() - Should return your required confirmations
✅ getContractBalance() - Should return 1,000,000 * 10^18
✅ transactionCount() - Should return 0
```

---

## Testing & Interaction

### 1. Basic Contract Testing

#### Test Owner Functions:

```solidity
// 1. Check if addresses are owners
isOwner("YOUR_ADDRESS") // Should return true for owner addresses

// 2. Check contract balance
getContractBalance() // Should return 1000000000000000000000000

// 3. Get all owners
getOwners() // Should return array of owner addresses
```

#### Test Transaction Submission:

1. **Submit a Test Transaction**:
   - Function: `submitTransaction`
   - Parameters:
     - `_to`: A test address (can be one of your addresses)
     - `_amount`: `1000000000000000000` (1 token with 18 decimals)
     - `_description`: `"Test transaction"`

2. **Expected Result**:
   - Transaction ID returned (should be 0 for first transaction)
   - Transaction auto-confirmed by submitter
   - If required confirmations = 1, transaction executes immediately

### 2. Multi-Signature Testing

#### Test Confirmation Flow:

1. **Switch MetaMask Account**: Change to different owner address

2. **Confirm Transaction**:
   ```solidity
   confirmTransaction(0) // Confirm transaction ID 0
   ```

3. **Check Status**:
   ```solidity
   getConfirmationStatus(0, "OWNER_ADDRESS") // Should return true
   getTransaction(0) // Check confirmations count
   ```

### 3. Advanced Testing

#### Test All Functions:

```solidity
// View Functions
✅ getTransaction(0)
✅ getPendingTransactions()
✅ canExecuteTransaction(0)
✅ getConfirmedOwners(0)

// State-Changing Functions (test with different owners)
✅ confirmTransaction(0)
✅ revokeConfirmation(0)
✅ executeTransaction(0) // If not auto-executed
```

---

## Common Issues & Troubleshooting

### 1. Compilation Errors

#### Issue: Import not found
```
Error: File import callback not supported
```

**Solution**:
- Ensure you're using Remix IDE online version
- Check that OpenZeppelin contracts are being imported correctly
- Try compiling with auto-import enabled

#### Issue: Compiler version mismatch
```
Error: Source file requires different compiler version
```

**Solution**:
- Change compiler version in Remix to 0.8.19 or higher
- Ensure pragma statement matches compiler version

### 2. Deployment Issues

#### Issue: Transaction failed - Out of gas
```
Error: Transaction ran out of gas
```

**Solution**:
- Increase gas limit to 3,000,000 or higher
- Check Sepolia network isn't congested
- Ensure you have enough test ETH

#### Issue: Invalid constructor parameters
```
Error: Invalid number of parameters for "constructor"
```

**Solution**:
- Check array format: `["0x...","0x..."]`
- Ensure addresses are valid Ethereum addresses
- Verify required number is not greater than owners length

#### Issue: MetaMask connection issues
```
Error: MetaMask not connected
```

**Solution**:
- Refresh Remix page
- Reconnect MetaMask
- Switch to Sepolia network in MetaMask
- Check MetaMask is unlocked

### 3. Testing Issues

#### Issue: Function calls failing
```
Error: Execution reverted
```

**Solution**:
- Check you're calling from owner address
- Verify transaction exists before confirming
- Ensure sufficient contract balance for transfers
- Check transaction isn't already executed

#### Issue: Balance showing 0
```
getContractBalance() returns 0
```

**Solution**:
- Contract should mint 1M tokens on deployment
- Check deployment was successful
- Verify contract address is correct

---

## Post-Deployment Checklist

### ✅ Immediate Verification

- [ ] Contract deployed successfully on Sepolia
- [ ] Contract address noted and saved
- [ ] All owner addresses configured correctly
- [ ] Required confirmations set as intended
- [ ] Initial token supply (1M tokens) minted to contract
- [ ] Basic view functions working correctly

### ✅ Security Verification

- [ ] Only intended addresses are owners
- [ ] Required confirmations appropriate (not too low/high)
- [ ] Contract balance matches expected amount
- [ ] No unexpected functions or permissions
- [ ] All constructor parameters verified

### ✅ Functional Testing

- [ ] Transaction submission working
- [ ] Confirmation mechanism working
- [ ] Auto-execution working (if required confirmations met)
- [ ] Revocation functionality working
- [ ] All view functions returning expected data

### ✅ Documentation & Backup

- [ ] Contract address documented
- [ ] Owner private keys secured
- [ ] Deployment parameters recorded
- [ ] Transaction hash saved
- [ ] Contact information for all owners established

---

## Next Steps

After successful deployment:

1. **Share Contract Details**: Provide contract address and ABI to all owners
2. **Set Up Monitoring**: Create alerts for contract transactions
3. **Prepare Management Interface**: Consider building a web interface for easier interaction
4. **Regular Testing**: Perform periodic tests with small amounts
5. **Security Review**: Consider professional audit before mainnet deployment

## Support Resources

- **Remix Documentation**: [remix-ide.readthedocs.io](https://remix-ide.readthedocs.io)
- **Sepolia Testnet Info**: [sepolia.dev](https://sepolia.dev)
- **MetaMask Support**: [metamask.io/support](https://metamask.io/support)
- **OpenZeppelin Docs**: [docs.openzeppelin.com](https://docs.openzeppelin.com)
- **Etherscan Sepolia**: [sepolia.etherscan.io](https://sepolia.etherscan.io)

---

## Conclusion

You have now successfully deployed the Ycbmb42 multi-signature wallet on Sepolia testnet using Remix IDE. The contract is ready for testing and can serve as a foundation for mainnet deployment once thoroughly tested and audited.

Remember to keep all deployment information secure and maintain communication with all wallet owners for effective multi-signature operations.