# Ycbmb42 Multi-Signature ERC-20 Token Contract Documentation

## Overview

The **Ycbmb42** contract extends the ERC-20 token standard with a multi-signature wallet mechanism. It combines token functionality with multisig transaction approval, enabling multiple owners to collectively manage token transfers securely.

This contract allows:
- A group of owners to propose, confirm, revoke, and execute token transfer transactions.
- Token minting to the contract itself, which holds tokens until released via multisig approval.
- A configurable number of required confirmations before executing any transfer.

---

## Code

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Ycbmb42 is ERC20 {
    address[] public owners;
    uint public required;

    struct Transaction {
        address to;
        uint256 amount;
        bool executed;
        uint confirmations;
    }

    mapping(address => bool) public isOwner;
    mapping(uint => mapping(address => bool)) public isConfirmed;
    Transaction[] public transactions;

    event SubmitTransaction(uint indexed txIndex, address indexed to, uint amount);
    event ConfirmTransaction(address indexed owner, uint indexed txIndex);
    event RevokeConfirmation(address indexed owner, uint indexed txIndex);
    event ExecuteTransaction(uint indexed txIndex);

    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not owner");
        _;
    }

    modifier txExists(uint _txIndex) {
        require(_txIndex < transactions.length, "Invalid transaction");
        _;
    }

    constructor(address[] memory _owners, uint _required) ERC20("Ycbmb42", "YCB42") {
        require(_owners.length >= _required && _required > 0, "Invalid owners/required");
        
        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "Invalid owner");
            require(!isOwner[owner], "Owner not unique");
            
            isOwner[owner] = true;
            owners.push(owner);
        }
        
        required = _required;
        _mint(address(this), 1_000_000 * 10**18);
    }

    function submitTransaction(address _to, uint256 _amount) external onlyOwner {
        require(_to != address(0), "Invalid recipient");
        require(_amount > 0, "Amount must be >0");
        require(balanceOf(address(this)) >= _amount, "Insufficient balance");

        uint txIndex = transactions.length;
        transactions.push(Transaction(_to, _amount, false, 0));

        isConfirmed[txIndex][msg.sender] = true;
        transactions[txIndex].confirmations = 1;

        emit SubmitTransaction(txIndex, _to, _amount);
        emit ConfirmTransaction(msg.sender, txIndex);

        if (transactions[txIndex].confirmations >= required) {
            _executeTransaction(txIndex);
        }
    }


    function confirmTransaction(uint _txIndex) external onlyOwner txExists(_txIndex) {
        Transaction storage transaction = transactions[_txIndex];
        require(!transaction.executed, "Already executed");
        require(!isConfirmed[_txIndex][msg.sender], "Already confirmed");

        isConfirmed[_txIndex][msg.sender] = true;
        transaction.confirmations++;
        emit ConfirmTransaction(msg.sender, _txIndex);
        
        if (transaction.confirmations >= required) {
            _executeTransaction(_txIndex);
        }
    }

    function _executeTransaction(uint _txIndex) internal {
        Transaction storage transaction = transactions[_txIndex];
        require(!transaction.executed, "Already executed");
        require(transaction.confirmations >= required, "Insufficient confirmations");
        
        transaction.executed = true;
        _transfer(address(this), transaction.to, transaction.amount);
        emit ExecuteTransaction(_txIndex);
    }

    function executeTransaction(uint _txIndex) external txExists(_txIndex) {
        _executeTransaction(_txIndex);
    }

    function revokeConfirmation(uint _txIndex) external onlyOwner txExists(_txIndex) {
        Transaction storage transaction = transactions[_txIndex];
        require(!transaction.executed, "Already executed");
        require(isConfirmed[_txIndex][msg.sender], "Not confirmed");

        isConfirmed[_txIndex][msg.sender] = false;
        transaction.confirmations--;
        emit RevokeConfirmation(msg.sender, _txIndex);
    }
}
```

## Key Components

### Owners & Required Confirmations
- **owners**: List of addresses authorized to manage token transfers.  
- **required**: Number of confirmations needed for a transaction to execute.

### Transaction Struct
- Holds details of each proposed token transfer: recipient, amount, execution status, and confirmation count.

### Mappings
- **isOwner**: Tracks which addresses are owners.  
- **isConfirmed**: Records which owners have confirmed specific transactions.

### Events
- **SubmitTransaction**: Emitted when a new transaction is proposed.  
- **ConfirmTransaction**: Emitted when an owner confirms a transaction.  
- **RevokeConfirmation**: Emitted when an owner revokes their confirmation.  
- **ExecuteTransaction**: Emitted when a transaction is executed.

---

## How It Works

### Deployment:
- The contract is deployed with a list of owners and a required confirmation count.  
- 1,000,000 tokens are minted directly to the contract’s address.

### Submitting a Transaction:
- An owner proposes a transfer by calling `submitTransaction`.  
- The transaction is added to the queue and auto-confirmed by the submitter.

### Confirming a Transaction:
- Other owners can confirm the transaction using `confirmTransaction`.  
- Once the number of confirmations reaches `required`, the transaction executes automatically.

### Executing a Transaction:
- Internal `_executeTransaction` transfers tokens from the contract to the recipient.  
- The transaction is marked executed to prevent re-execution.

### Revoking Confirmation:
- Owners may revoke their confirmation before execution using `revokeConfirmation`.

---

## Usage Notes
- Only owners can submit, confirm, revoke, or execute transactions.  
- The contract itself holds the tokens until released via approved transactions.  
- Multiple owners provide a security layer by requiring collective approval.  
- Token transfers are atomic and event-logged for transparency.

---

## Events for Frontend/Monitoring

Listen to these events to track contract activity:

| Event                | Description                          |
|----------------------|--------------------------------------|
| SubmitTransaction    | New transaction proposal             |
| ConfirmTransaction   | Confirmation by an owner             |
| RevokeConfirmation   | Revocation of a prior confirmation   |
| ExecuteTransaction   | Successful execution of a transaction|

---

## Security Considerations
- Owners should be trusted parties as they control token releases.  
- `required` should be set to a safe threshold (e.g., majority of owners).  
- Confirmations and revocations ensure decisions are collective.  
- The contract prevents double execution or unauthorized confirmations.

---

## Potential Extensions
- Adding a function to add/remove owners with multi-signature approval.  
- Support for token burning or minting with multisig controls.  
- Integration with off-chain frontend apps using events for UI updates.

---

## Summary

| Feature                | Description                       |
|------------------------|-----------------------------------|
| Token Name             | Ycbmb42                           |
| Symbol                 | YCB42                             |
| Total Supply           | 1,000,000 tokens                  |
| Token Type             | ERC-20 with multisig transfers    |
| Owners                 | Multiple addresses                |
| Confirmations Required | Configurable at deployment        |
| Token Holding          | Contract holds tokens             |
| Transfer Approval      | Requires multiple owners’ consent |
