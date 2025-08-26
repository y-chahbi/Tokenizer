// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";


contract Ycbmb42 is ERC20, ReentrancyGuard {
    
    // ==================== STATE VARIABLES ====================
    address[] public owners;
    uint256 public immutable required;
    uint256 public transactionCount;
    uint256 public constant MAX_OWNERS = 50;
    uint256 public constant MIN_REQUIRED = 1;
    // ==================== STRUCTS ====================
    struct Transaction {
        address to;                 // Recipient address
        uint256 amount;            // Amount of tokens to transfer  
        bool executed;             // Execution status
        uint256 confirmations;     // Number of confirmations received
        uint256 timestamp;         // When transaction was submitted
        address submitter;         // Who submitted the transaction
        string description;        // Optional description
    }
    // ==================== MAPPINGS ====================
    /// Check if an address is an owner
    mapping(address => bool) public isOwner;

    /// Track confirmations: transactionId => owner => confirmed
    mapping(uint256 => mapping(address => bool)) public isConfirmed;
    
    /// Store all transactions
    mapping(uint256 => Transaction) public transactions;
    // ==================== EVENTS ====================
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
    
    event OwnerAdded(address indexed newOwner);
    event OwnerRemoved(address indexed removedOwner);
    
    // ==================== MODIFIERS ====================
    /// Restrict access to owners only
    modifier onlyOwner() {
        require(isOwner[msg.sender], "Ycbmb42: caller is not an owner");
        _;
    }
    
    /// Validate transaction exists
    modifier validTransaction(uint256 _txId) {
        require(_txId < transactionCount, "Ycbmb42: transaction does not exist");
        _;
    }
    
    /// Validate transaction is not executed
    modifier notExecuted(uint256 _txId) {
        require(!transactions[_txId].executed, "Ycbmb42: transaction already executed");
        _;
    }
    
    /// Validate owner has not confirmed
    modifier notConfirmed(uint256 _txId) {
        require(!isConfirmed[_txId][msg.sender], "Ycbmb42: transaction already confirmed by caller");
        _;
    }
    
    /// Validate owner has confirmed
    modifier confirmed(uint256 _txId) {
        require(isConfirmed[_txId][msg.sender], "Ycbmb42: transaction not confirmed by caller");
        _;
    }
    // ==================== CONSTRUCTOR ====================
    

    // Initialize the multi-signature wallet

    constructor(
        address[] memory _owners, 
        uint256 _required
    ) ERC20("Ycbmb42", "YCB42") {
        require(_owners.length > 0, "Ycbmb42: owners required");
        require(_owners.length <= MAX_OWNERS, "Ycbmb42: too many owners");
        require(
            _required >= MIN_REQUIRED && _required <= _owners.length, 
            "Ycbmb42: invalid required confirmations"
        );
        
        // Set required confirmations (immutable)
        required = _required;
        
        // Initialize owners
        for (uint256 i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            
            require(owner != address(0), "Ycbmb42: invalid owner address");
            require(!isOwner[owner], "Ycbmb42: duplicate owner");
            
            isOwner[owner] = true;
            owners.push(owner);
            
            emit OwnerAdded(owner);
        }
        
        // Mint initial token supply to the contract
        _mint(address(this), 1_000_000 * 10**decimals());
    }
    
    // ==================== CORE FUNCTIONS ====================
    // Submit a new transaction proposal

    function submitTransaction(
        address _to, 
        uint256 _amount, 
        string calldata _description
    ) external onlyOwner returns (uint256 txId) {
        require(_to != address(0), "Ycbmb42: invalid recipient");
        require(_amount > 0, "Ycbmb42: amount must be greater than zero");
        require(balanceOf(address(this)) >= _amount, "Ycbmb42: insufficient contract balance");
        require(bytes(_description).length <= 256, "Description too long");
        
        txId = transactionCount;
        
        transactions[txId] = Transaction({
            to: _to,
            amount: _amount,
            executed: false,
            confirmations: 1, // Auto-confirm by submitter
            timestamp: block.timestamp,
            submitter: msg.sender,
            description: _description
        });
        
        // Auto-confirm by submitter
        isConfirmed[txId][msg.sender] = true;
        
        transactionCount++;
        
        emit TransactionSubmitted(txId, msg.sender, _to, _amount, _description);
        emit TransactionConfirmed(msg.sender, txId);
        
        // Auto-execute if enough confirmations
        if (transactions[txId].confirmations >= required) {
            _executeTransaction(txId);
        }
        
        return txId;
    }
    
    // Confirm a pending transaction
    function confirmTransaction(uint256 _txId) 
        external 
        onlyOwner 
        validTransaction(_txId) 
        notExecuted(_txId) 
        notConfirmed(_txId) {
        isConfirmed[_txId][msg.sender] = true;
        transactions[_txId].confirmations++;
        
        emit TransactionConfirmed(msg.sender, _txId);
        
        // Auto-execute if threshold reached
        if (transactions[_txId].confirmations >= required) {
            _executeTransaction(_txId);
        }
    }
    
    // Revoke confirmation for a pending transaction
    function revokeConfirmation(uint256 _txId) 
        external 
        onlyOwner 
        validTransaction(_txId) 
        notExecuted(_txId) 
        confirmed(_txId) 
    {
        isConfirmed[_txId][msg.sender] = false;
        transactions[_txId].confirmations--;
        
        emit ConfirmationRevoked(msg.sender, _txId);
    }
    
    // Execute a transaction with enough confirmations
    function executeTransaction(uint256 _txId) 
        external 
        validTransaction(_txId) 
        notExecuted(_txId) 
        nonReentrant 
    {
        require(
            transactions[_txId].confirmations >= required, 
            "Ycbmb42: insufficient confirmations"
        );
        
        _executeTransaction(_txId);
    }
    
    // Internal function to execute a transaction
    function _executeTransaction(uint256 _txId) internal {
        Transaction storage txn = transactions[_txId];
        
        // Mark as executed first (CEI pattern)
        txn.executed = true;
        
        // Execute the transfer
        _transfer(address(this), txn.to, txn.amount);
        
        emit TransactionExecuted(_txId, msg.sender);
    }
    
    // ==================== VIEW FUNCTIONS ====================
    // Get transaction details

    function getTransaction(uint256 _txId) 
        external 
        view 
        validTransaction(_txId) 
        returns (Transaction memory) {
        return transactions[_txId];
    }
    
    // Get confirmation status for a transaction and owner
    function getConfirmationStatus(uint256 _txId, address _owner) 
        external 
        view 
        validTransaction(_txId) 
        returns (bool) {
        return isConfirmed[_txId][_owner];
    }
    
    // Get all owners
    function getOwners() external view returns (address[] memory) {
        return owners;
    }
    
    // Get pending transactions (not executed)
    function getPendingTransactions() external view returns (uint256[] memory) {
        uint256[] memory tempTxIds = new uint256[](transactionCount);
        uint256 count = 0;
        
        for (uint256 i = 0; i < transactionCount; i++) {
            if (!transactions[i].executed) {
                tempTxIds[count] = i;
                count++;
            }
        }
        
        // Create properly sized array
        uint256[] memory pendingTxIds = new uint256[](count);
        for (uint256 i = 0; i < count; i++) {
            pendingTxIds[i] = tempTxIds[i];
        }
        
        return pendingTxIds;
    }
    
    // Check if transaction can be executed
    function canExecuteTransaction(uint256 _txId) 
        external 
        view 
        validTransaction(_txId) 
        returns (bool) {
        Transaction memory txn = transactions[_txId];
        return !txn.executed && 
               txn.confirmations >= required && 
               balanceOf(address(this)) >= txn.amount;
    }
    
    // Get confirmation count for owners who confirmed a transaction
    function getConfirmedOwners(uint256 _txId) 
        external 
        view 
        validTransaction(_txId) 
        returns (address[] memory confirmedOwners) {
        address[] memory tempOwners = new address[](owners.length);
        uint256 count = 0;
        
        for (uint256 i = 0; i < owners.length; i++) {
            if (isConfirmed[_txId][owners[i]]) {
                tempOwners[count] = owners[i];
                count++;
            }
        }
        
        // Create properly sized array
        confirmedOwners = new address[](count);
        for (uint256 i = 0; i < count; i++) {
            confirmedOwners[i] = tempOwners[i];
        }
        
        return confirmedOwners;
    }
    
    // ==================== EMERGENCY FUNCTIONS ====================
    // Get contract token balance

    function getContractBalance() external view returns (uint256) {
        return balanceOf(address(this));
    }
}