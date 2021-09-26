// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SwapPool {
  bool public hasInitialized;
  IERC20 public token1; // 1st token
  IERC20 public token2; // 2nd token

  uint256 public exchangeRate; // store 4 decimal points. Divide by 10,000 to get real exchange rate

  event Deposit(address sender, uint256 tokenAmount1, uint256 tokenAmount2);

  constructor() {
    hasInitialized = true;
  }

  function initialize(IERC20 _token1, IERC20 _token2) public {
    require(hasInitialized == false, "Pool already initialized");
    token1 = _token1;
    token2 = _token2;
  }

  // user sends equal amount of eth and token
  function deposit(uint256 _tokenAmount1, uint256 _tokenAmount2) public payable {
    updatePool();
    require(token1.balanceOf(msg.sender) > exchangeRate * msg.value); // calculate exchange rate, make sure user has address
    token1.transferFrom(msg.sender, address(this), _tokenAmount1);
    token2.transferFrom(msg.sender, address(this), _tokenAmount2);
    // add LP reward
    emit Deposit(msg.sender, _tokenAmount1, _tokenAmount2);
  }

  // calculate exchange rate
  function updatePool() public {
    exchangeRate = address(this).balance * 10000;
  }

  // add multiplier to incentivize early liquidity providers
}