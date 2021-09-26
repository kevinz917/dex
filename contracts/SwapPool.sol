// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PoolFactory.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SwapPool {
  bool private paused;
  bool public hasInitialized;

  address public factory;
  IERC20 public token1; // 1st token
  IERC20 public token2; // 2nd token

  uint256 public exchangeRate; // store 4 decimal points. Divide by 10,000 to get real exchange rate

  constructor(address _factoryContract) {
    hasInitialized = true;
    factory = _factoryContract;
  }

  function initialize(IERC20 _token1, IERC20 _token2) public {
    require(hasInitialized == false, "Pool already initialized");
    token1 = _token1;
    token2 = _token2;
  }

  // swap

  // calculate exchange rate
  function updatePool() public unpaused {
    exchangeRate = address(this).balance * 10000;
  }

  // add multiplier to incentivize early liquidity providers

  modifier unpaused() {
    require(paused == false, "Pool is paused");
    _;
  }
}
