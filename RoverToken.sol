// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

/**
 * @title RoverToken
 * @dev Implementation of the ROVER TOKEN (ROVE) ERC-20 Token with pausability and minting provisions.
 */
contract RoverToken is ERC20, Ownable, Pausable {
    // Tokenomics parameters
    uint256 private constant totalSupplyCap = 1e8 * 10**18; // 100 million ROVE tokens cap

    // Define events
    event Minted(address indexed account, uint256 amount);
    event Burned(address indexed account, uint256 amount);

    /**
     * @dev Constructor to initialize the ROVE token.
     */
    constructor() ERC20("ROVER TOKEN", "ROVE") {
        // Mint the initial total supply to the contract owner
        _mint(msg.sender, (totalSupplyCap / 10) * 8); // 80% of total supply cap
    }

    /**
     * @dev Pause all token functionalities (onlyOwner).
     */
    function pause() external onlyOwner {
        _pause();
    }

    /**
     * @dev Unpause all token functionalities (onlyOwner).
     */
    function unpause() external onlyOwner {
        _unpause();
    }

    /**
     * @dev Mint new tokens (onlyOwner).
     * @param account The address to mint tokens to.
     * @param amount The amount of tokens to mint.
     */
    function mint(address account, uint256 amount)
        external
        onlyOwner
        whenNotPaused
    {
        require(account != address(0), "Invalid address");
        require(amount != 0, "Amount must be greater than 0");
        require(totalSupply() + amount <= totalSupplyCap, "Exceeds supply cap");

        _mint(account, amount);
        emit Minted(account, amount);
    }

    /**
     * @dev Burn tokens (onlyOwner).
     * @param account The address to burn tokens from.
     * @param amount The amount of tokens to burn.
     */
    function burn(address account, uint256 amount)
        external
        onlyOwner
        whenNotPaused
    {
        require(account != address(0), "Invalid address");
        require(amount != 0, "Amount must be greater than 0");

        _burn(account, amount);
        emit Burned(account, amount);
    }

    /**
     * @dev Override the internal function _beforeTokenTransfer from Openzeppelin’s ERC20 contract and add the whenNotPaused modifier to the function.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, amount);
    }
}
