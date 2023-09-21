// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

/**
 * @title RoverToken
 * @dev Implementation of the ROVER TOKEN (ROVE) ERC-20 Token with pausability and minting provisions.
 */
contract RoverToken is ERC20, Ownable, Pausable {
    // Tokenomics parameters
    uint256 public constant totalSupplyCap = 100000000 * 10**18; // 100 million ROVE tokens cap

    /**
     * @dev Constructor to initialize the ROVE token.
     */
    constructor() ERC20("ROVER TOKEN", "ROVE") {
        // Mint the initial total supply to the contract owner
        _mint(msg.sender, totalSupplyCap);
    }

    /**
     * @dev Pause all token functionalities (onlyOwner).
     */
    function pause() public onlyOwner {
        _pause();
    }

    /**
     * @dev Unpause all token functionalities (onlyOwner).
     */
    function unpause() public onlyOwner {
        _unpause();
    }

    /**
     * @dev Mint new tokens (onlyOwner).
     * @param account The address to mint tokens to.
     * @param amount The amount of tokens to mint.
     */
    function mint(address account, uint256 amount) public onlyOwner {
        require(account != address(0), "Invalid address");
        require(amount > 0, "Amount must be greater than 0");
        require(totalSupply() + amount <= totalSupplyCap, "Exceeds supply cap");

        _mint(account, amount);
    }
}
