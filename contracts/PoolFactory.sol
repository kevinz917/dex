// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./InitializedProxy.sol";
import "./SwapPool.sol";

contract PoolFactory is Ownable {
  mapping(address => address) public pools; // mapping from token address to pool contract address
  uint256 public poolCount; // count of all swap pool

  address public pool; // address of base pool contract

  event PoolCreated(IERC20 token1, IERC20 token2, address pool);

  // how do you track token pool pairs

  constructor() {
    transferOwnership(msg.sender);
    pool = address(new SwapPool());
  }

  // create a swap pool betweeb any token and
  function createPool(IERC20 token1, IERC20 token2) external {
    require(token1 != token2, "Same tokens");
    bytes memory _initializationCalldata = abi.encodeWithSignature("initialize(IERC20,IERC20)", msg.sender, token1, token2);
    address newPoolAddress = address(new InitializedProxy(pool, _initializationCalldata));
    emit PoolCreated(token1, token2, newPoolAddress);

    pools[tokenAddress] = newPoolAddress;
  }
}
