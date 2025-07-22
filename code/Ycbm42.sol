// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract Ycbm42 is ERC20 {
    constructor() ERC20("Ycbm42", "YCM42") {
        _mint(msg.sender, 1_000_000 * 10 ** 18);
    }
}