# Ycbmb42 Multi-Signature Wallet Documentation

## Overview

The **Ycbmb42** contract is a sophisticated multi-signature wallet that also functions as an ERC20 token. It allows multiple owners to collectively manage token transfers through a consensus mechanism, requiring a minimum number of confirmations before executing any transaction.

## Table of Contents

- [Features](#features)
- [Contract Architecture](#contract-architecture)
- [Deployment Guide (Remix)](#deployment-guide-remix)
- [Core Functions](#core-functions)
- [View Functions](#view-functions)
- [Events](#events)
- [Security Features](#security-features)
- [Usage Examples](#usage-examples)
- [Testing Guide](#testing-guide)
- [Best Practices](#best-practices)

## Features

### 🔐 Multi-Signature Security
- Multiple owners must approve transactions
- Configurable confirmation threshold
- Protection against single points of failure

### 🪙 ERC20 Token Integration
- Built-in ERC20 token functionality
- Initial supply: 1,000,000 tokens (YCB42)
- Token transfers managed through multi-sig approval

### 🛡️ Security Enhancements
- Reentrancy protection
- CEI (Checks-Effects-Interactions) pattern
- Comprehensive input validation

### 📊 Advanced Features
- Transaction descriptions
- Timestamp tracking
- Pending transaction management
- Detailed confirmation tracking

## Contract Architecture

### State Variables

| Variable | Type | Description |
|----------|------|-------------|
| `owners` | `address[]` | Array of wallet owners |
| `required` | `uint256` | Required confirmations (immutable) |
| `transactionCount` | `uint256` | Total submitted transactions |
| `MAX_OWNERS` | `uint256` | Maximum owners limit (50) |
| `MIN_REQUIRED` | `uint256` | Minimum required confirmations (1) |

### Transaction Structure

```solidity
struct Transaction {
    address to;           // Recipient address
    uint256 amount;       // Token amount
    bool executed;        // Execution status
    uint256 confirmations;// Confirmation count
    uint256 timestamp;    // Submission time
    address submitter;    // Transaction submitter
    string description;   // Optional description
}
```

### Key Mappings

- `isOwner[address]` → `bool`: Owner validation
- `isConfirmed[txId][owner]` → `bool`: Confirmation tracking
- `transactions[txId]` → `Transaction`: Transaction storage

## Deployment Guide (Remix)

### Prerequisites

1. **MetaMask** wallet installed and configured
2. **Remix IDE** open in browser
3. **Test ETH** for deployment (Sepolia/Goerli testnet recommended)

### Step-by-Step Deployment

#### 1. Setup Remix Environment

1. Open [Remix IDE](https://remix.ethereum.org/)
2. Create a new file: `Ycbmb42.sol`
3. Copy and paste the contract code

#### 2. Install Dependencies

In Remix, the OpenZeppelin imports will be automatically resolved:
```solidity
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
```

#### 3. Compile Contract

1. Go to **Solidity Compiler** tab
2. Select compiler version: `0.8.19` or higher
3. Enable optimization (200 runs recommended)
4. Click **Compile Ycbmb42.sol**

#### 4. Prepare Deployment Parameters

```javascript
// Example deployment parameters
const owners = [
    "0x1234567890123456789012345678901234567890",  // Owner 1
    "0x0987654321098765432109876543210987654321",  // Owner 2
    "0xabcdefabcdefabcdefabcdefabcdefabcdefabcd"   // Owner 3
];
const required = 2; // Require 2 out of 3 confirmations
```

#### 5. Deploy Contract

1. Go to **Deploy & Run Transactions** tab
2. Select environment (Injected Provider - MetaMask)
3. Select account with sufficient ETH
4. Choose `Ycbmb42` contract
5. Enter constructor parameters:
   - `_owners`: `["0x...", "0x...", "0x..."]`
   - `_required`: `2`
6. Click **Deploy**
7. Confirm transaction in MetaMask

#### 6. Verify Deployment

After deployment, verify:
- Contract address is generated
- Initial token supply is minted
- Owners are correctly set
- Required confirmations match input

## Core Functions

### Transaction Management

#### `submitTransaction(address _to, uint256 _amount, string _description)`
**Purpose**: Submit a new transaction proposal

**Parameters**:
- `_to`: Recipient address
- `_amount`: Token amount (in wei units)
- `_description`: Optional transaction description

**Returns**: `uint256 txId` - Transaction ID

**Example**:
```javascript
// Submit transaction for 1000 tokens
await contract.submitTransaction(
    "0x742d35Cc7672C4d8C5b4c8e3d8925d7C6C5Bb4a7",
    ethers.utils.parseUnits("1000", 18),
    "Monthly payment to contractor"
);
```

#### `confirmTransaction(uint256 _txId)`
**Purpose**: Confirm a pending transaction

**Requirements**:
- Caller must be an owner
- Transaction must exist and not be executed
- Owner must not have already confirmed

**Example**:
```javascript
// Confirm transaction ID 0
await contract.confirmTransaction(0);
```

#### `revokeConfirmation(uint256 _txId)`
**Purpose**: Revoke a previous confirmation

**Requirements**:
- Transaction must not be executed
- Owner must have previously confirmed

**Example**:
```javascript
// Revoke confirmation for transaction ID 0
await contract.revokeConfirmation(0);
```

#### `executeTransaction(uint256 _txId)`
**Purpose**: Manually execute a transaction with sufficient confirmations

**Requirements**:
- Transaction must have enough confirmations
- Transaction must not be already executed

## View Functions

### Information Retrieval

#### `getTransaction(uint256 _txId)`
**Returns**: Complete transaction details

```javascript
const tx = await contract.getTransaction(0);
console.log({
    to: tx.to,
    amount: tx.amount.toString(),
    executed: tx.executed,
    confirmations: tx.confirmations.toString(),
    timestamp: tx.timestamp.toString(),
    submitter: tx.submitter,
    description: tx.description
});
```

#### `getConfirmationStatus(uint256 _txId, address _owner)`
**Returns**: Boolean confirmation status for specific owner

```javascript
const isConfirmed = await contract.getConfirmationStatus(0, ownerAddress);
console.log(`Transaction 0 confirmed by ${ownerAddress}: ${isConfirmed}`);
```

#### `getPendingTransactions()`
**Returns**: Array of unexecuted transaction IDs

```javascript
const pendingTxs = await contract.getPendingTransactions();
console.log("Pending transactions:", pendingTxs);
```

#### `getConfirmedOwners(uint256 _txId)`
**Returns**: Array of owners who confirmed the transaction

```javascript
const confirmedOwners = await contract.getConfirmedOwners(0);
console.log("Owners who confirmed:", confirmedOwners);
```

#### `canExecuteTransaction(uint256 _txId)`
**Returns**: Boolean indicating if transaction can be executed

```javascript
const canExecute = await contract.canExecuteTransaction(0);
if (canExecute) {
    await contract.executeTransaction(0);
}
```

## Events

### Transaction Events

```solidity
event TransactionSubmitted(
    uint256 indexed txId, 
    address indexed submitter,
    address indexed to, 
    uint256 amount, 
    string description
);

event TransactionConfirmed(
    address indexed owner, 
    uint256 indexed txId
);

event ConfirmationRevoked(
    address indexed owner, 
    uint256 indexed txId
);

event TransactionExecuted(
    uint256 indexed txId, 
    address indexed executor
);
```

### Owner Management Events

```solidity
event OwnerAdded(address indexed newOwner);
event OwnerRemoved(address indexed removedOwner);
```

## Security Features

### 🛡️ Protection Mechanisms

1. **Reentrancy Guard**: Prevents reentrancy attacks
2. **CEI Pattern**: Checks-Effects-Interactions for safe execution
3. **Input Validation**: Comprehensive parameter validation
4. **Owner Limits**: Maximum 50 owners to prevent DoS
5. **Immutable Required**: Confirmation threshold cannot be changed

### 🔍 Access Control

- **onlyOwner**: Restricts functions to wallet owners
- **Validation Modifiers**: Ensure transaction validity
- **Confirmation Tracking**: Prevents double confirmations

## Usage Examples

### Complete Transaction Flow

```javascript
// 1. Submit transaction
const txId = await contract.submitTransaction(
    recipientAddress,
    ethers.utils.parseUnits("500", 18),
    "Payment for services"
);

// 2. Other owners confirm
await contract.connect(owner2).confirmTransaction(txId);
await contract.connect(owner3).confirmTransaction(txId);

// 3. Check if executable
const canExecute = await contract.canExecuteTransaction(txId);

// 4. Execute if ready (auto-executed if threshold reached)
if (canExecute) {
    await contract.executeTransaction(txId);
}
```

### Monitoring Events

```javascript
// Listen for new transactions
contract.on("TransactionSubmitted", (txId, submitter, to, amount, description) => {
    console.log(`New transaction ${txId}: ${amount} tokens to ${to}`);
    console.log(`Description: ${description}`);
});

// Listen for confirmations
contract.on("TransactionConfirmed", (owner, txId) => {
    console.log(`Transaction ${txId} confirmed by ${owner}`);
});

// Listen for executions
contract.on("TransactionExecuted", (txId, executor) => {
    console.log(`Transaction ${txId} executed by ${executor}`);
});
```

## Testing Guide

### Using Remix Testing

#### 1. Basic Deployment Test

```javascript
// Test deployment parameters
const owners = ["0x...", "0x...", "0x..."];
const required = 2;

// Deploy and verify
assert.equal(await contract.required(), required);
assert.equal((await contract.getOwners()).length, owners.length);
```

#### 2. Transaction Flow Test

```javascript
// Submit transaction
const txId = await contract.submitTransaction(
    testAddress,
    ethers.utils.parseUnits("100", 18),
    "Test transaction"
);

// Verify transaction
const tx = await contract.getTransaction(txId);
assert.equal(tx.to, testAddress);
assert.equal(tx.confirmations.toString(), "1");

// Confirm by another owner
await contract.connect(owner2).confirmTransaction(txId);

// Check execution (if required = 2)
const txAfterConfirm = await contract.getTransaction(txId);
assert.equal(txAfterConfirm.executed, true);
```

### Test Scenarios

1. **Happy Path**: Submit → Confirm → Execute
2. **Insufficient Confirmations**: Verify execution fails
3. **Revoke Confirmation**: Test confirmation revocation
4. **Invalid Parameters**: Test error handling
5. **Access Control**: Test non-owner restrictions

## Best Practices

### 🔐 Security Considerations

1. **Owner Selection**: Choose trusted, active owners
2. **Required Threshold**: Balance security vs usability (typically 60-70% of owners)
3. **Regular Monitoring**: Monitor pending transactions
4. **Emergency Planning**: Have procedures for compromised owners

### ⚡ Gas Optimization

1. **Batch Operations**: Group multiple confirmations
2. **Efficient Queries**: Use view functions for data retrieval
3. **Avoid Large Arrays**: Use pagination for large datasets

### 🔧 Operational Tips

1. **Transaction Descriptions**: Always provide clear descriptions
2. **Confirmation Tracking**: Monitor who has confirmed transactions
3. **Regular Cleanup**: Execute or cancel stale transactions
4. **Event Monitoring**: Set up event listeners for real-time updates

### 📱 Frontend Integration

```javascript
// Example React hook for transaction management
function useMultiSigWallet(contractAddress, signer) {
    const contract = new ethers.Contract(contractAddress, ABI, signer);
    
    const submitTransaction = async (to, amount, description) => {
        return await contract.submitTransaction(to, amount, description);
    };
    
    const getPendingTransactions = async () => {
        const pendingIds = await contract.getPendingTransactions();
        return Promise.all(
            pendingIds.map(id => contract.getTransaction(id))
        );
    };
    
    return { submitTransaction, getPendingTransactions };
}
```

## Troubleshooting

### Common Issues

**Issue**: "Transaction already confirmed by caller"
**Solution**: Check if the owner already confirmed using `getConfirmationStatus()`

**Issue**: "Insufficient confirmations"
**Solution**: Ensure enough owners have confirmed before execution

**Issue**: "Invalid recipient"
**Solution**: Verify recipient address is not zero address

**Issue**: "Insufficient contract balance"
**Solution**: Check contract token balance with `getContractBalance()`

### Debug Functions

```javascript
// Check confirmation status
const status = await contract.getConfirmationStatus(txId, ownerAddress);

// Get confirmed owners
const confirmedOwners = await contract.getConfirmedOwners(txId);

// Check transaction details
const transaction = await contract.getTransaction(txId);

// Check if executable
const canExecute = await contract.canExecuteTransaction(txId);
```

---

## License

This contract is licensed under the MIT License.

## Support

For issues or questions:
1. Check the troubleshooting section
2. Review transaction events for debugging
3. Verify owner permissions and confirmations
4. Test on testnet before mainnet deployment