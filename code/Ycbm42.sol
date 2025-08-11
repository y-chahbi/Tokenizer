// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Importing the ERC20 contract from the OpenZeppelin library
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Defining the Ycbm42 contract that inherits from the ERC20 contract
contract Ycbm42 is ERC20 {
    // Constructor to initialize the token with a name and symbol
    constructor() ERC20("Ycbm42", "YCM42") {
        // Minting 1,000,000 tokens to the deployer's address
        _mint(msg.sender, 1_000_000 * 10 ** 18);
    }
}