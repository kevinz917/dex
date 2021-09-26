// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IPoolFactory.sol";

contract Router {
  address public factory;

  constructor(address _factory) {
    factory = _factory;
  }

  event Deposit(address sender, address _token1, address _token2, uint256 tokenAmount1, uint256 tokenAmount2);

  // user sends equal amount of each token
  function deposit(
    address _token1,
    address _token2,
    uint256 _tokenAmount1,
    uint256 _tokenAmount2
  ) public payable {
    require(IPoolFactory(factory).pools(_token1, _token2) != address(0), "Pool doesn't exist");
    // how to get exchange rate
    // require(token1.balanceOf(msg.sender) > exchangeRate * msg.value); // calculate exchange rate, make sure user has address
    IERC20(_token1).transferFrom(msg.sender, address(this), _tokenAmount1);
    IERC20(_token2).transferFrom(msg.sender, address(this), _tokenAmount2);
    // add LP reward
    emit Deposit(msg.sender, _token1, _token2, _tokenAmount1, _tokenAmount2);
  }
}
