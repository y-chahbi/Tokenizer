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
        
        transactions.push(Transaction(_to, _amount, false, 0));
        emit SubmitTransaction(transactions.length - 1, _to, _amount);
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