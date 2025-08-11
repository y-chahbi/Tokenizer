// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import ERC20 token standard implementation from OpenZeppelin
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Multi-signature wallet contract that extends ERC20 token
contract Ycbmb42 is ERC20 {
    // List of owner addresses who can confirm transactions
    address[] public owners;
    
    // Number of required confirmations to execute a transaction
    uint public required;

    // Struct to represent a transaction request
    struct Transaction {
        address to;           // Recipient address
        uint256 amount;       // Amount of tokens to transfer
        bool executed;        // Whether the transaction has been executed
        uint confirmations;   // Number of confirmations received
    }

    // Mapping to quickly check if an address is an owner
    mapping(address => bool) public isOwner;

    // Mapping to track whether a specific owner has confirmed a given transaction
    // isConfirmed[transactionIndex][ownerAddress] = true/false
    mapping(uint => mapping(address => bool)) public isConfirmed;

    // Array to store all submitted transactions
    Transaction[] public transactions;

    // Events to emit on key contract actions for off-chain tracking
    event SubmitTransaction(uint indexed txIndex, address indexed to, uint amount);
    event ConfirmTransaction(address indexed owner, uint indexed txIndex);
    event RevokeConfirmation(address indexed owner, uint indexed txIndex);
    event ExecuteTransaction(uint indexed txIndex);

    // Modifier to restrict function calls only to owners
    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not owner");
        _;
    }

    // Modifier to check if a transaction exists in the transactions array
    modifier txExists(uint _txIndex) {
        require(_txIndex < transactions.length, "Invalid transaction");
        _;
    }

    // Constructor to initialize the contract with owners and required confirmations
    // Also mints 1,000,000 tokens to the contract itself
    constructor(address[] memory _owners, uint _required) ERC20("Ycbmb42", "YCB42") {
        // Validate owners and required number of confirmations
        require(_owners.length >= _required && _required > 0, "Invalid owners/required");
        
        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "Invalid owner");        // Owner cannot be zero address
            require(!isOwner[owner], "Owner not unique");          // Owner addresses must be unique
            
            isOwner[owner] = true;
            owners.push(owner);
        }
        
        required = _required;
        // Mint tokens to the contract address itself for future transfers
        _mint(address(this), 1_000_000 * 10**18);
    }

    // Submit a new transaction proposal (transfer tokens from contract to another address)
    // Only callable by an owner
    function submitTransaction(address _to, uint256 _amount) external onlyOwner {
        require(_to != address(0), "Invalid recipient");           // Recipient cannot be zero address
        require(_amount > 0, "Amount must be >0");                  // Amount must be positive
        require(balanceOf(address(this)) >= _amount, "Insufficient balance");  // Contract must have enough tokens

        uint txIndex = transactions.length;                         // Index of the new transaction
        transactions.push(Transaction(_to, _amount, false, 0));     // Add new transaction to the list

        // Automatically confirm the transaction by the submitting owner
        isConfirmed[txIndex][msg.sender] = true;
        transactions[txIndex].confirmations = 1;

        // Emit events for the new transaction and confirmation
        emit SubmitTransaction(txIndex, _to, _amount);
        emit ConfirmTransaction(msg.sender, txIndex);

        // If enough confirmations received, execute the transaction immediately
        if (transactions[txIndex].confirmations >= required) {
            _executeTransaction(txIndex);
        }
    }

    // Confirm a pending transaction by an owner
    function confirmTransaction(uint _txIndex) external onlyOwner txExists(_txIndex) {
        Transaction storage transaction = transactions[_txIndex];
        require(!transaction.executed, "Already executed");             // Cannot confirm executed tx
        require(!isConfirmed[_txIndex][msg.sender], "Already confirmed"); // Owner can't confirm twice

        isConfirmed[_txIndex][msg.sender] = true;
        transaction.confirmations++;
        emit ConfirmTransaction(msg.sender, _txIndex);
        
        // Execute if confirmation threshold is met
        if (transaction.confirmations >= required) {
            _executeTransaction(_txIndex);
        }
    }

    // Internal function to execute a transaction once enough confirmations are gathered
    function _executeTransaction(uint _txIndex) internal {
        Transaction storage transaction = transactions[_txIndex];
        require(!transaction.executed, "Already executed");              // Prevent double execution
        require(transaction.confirmations >= required, "Insufficient confirmations"); // Check confirmations
        
        transaction.executed = true;                                      // Mark as executed
        _transfer(address(this), transaction.to, transaction.amount);     // Transfer tokens from contract to recipient
        emit ExecuteTransaction(_txIndex);
    }

    // Public function to execute a transaction manually (if confirmations are already enough)
    function executeTransaction(uint _txIndex) external txExists(_txIndex) {
        _executeTransaction(_txIndex);
    }

    // Revoke an owner’s confirmation for a pending transaction
    function revokeConfirmation(uint _txIndex) external onlyOwner txExists(_txIndex) {
        Transaction storage transaction = transactions[_txIndex];
        require(!transaction.executed, "Already executed");              // Cannot revoke if executed
        require(isConfirmed[_txIndex][msg.sender], "Not confirmed");     // Owner must have confirmed previously

        isConfirmed[_txIndex][msg.sender] = false;                        // Remove confirmation
        transaction.confirmations--;
        emit RevokeConfirmation(msg.sender, _txIndex);
    }
}
