pragma solidity ^0.4.24;

import "../openzeppelin-solidity/contracts/math/Math.sol";
import "../openzeppelin-solidity/contracts/math/SafeMath.sol";
import "../openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "../openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";


contract RationallyPricedCrowdsale is Ownable {
  using SafeMath for uint256;

  IERC20 public token;
  uint256 public baseRate; // How many tokens per ether?
  uint256 public baseAvailability;

  /**
  * Event for token purchase logging
  * @param purchaser who paid for the tokens
  * @param beneficiary who got the tokens
  * @param value weis paid for purchase
  * @param amount amount of tokens purchased
  */
  event TokensPurchased(
    address indexed purchaser,
    address indexed beneficiary,
    uint256 value,
    uint256 amount
  );

  
  /**
  * @dev Constructor
  * @param _token The address of the token to be sold
  * @param _baseRate How many tokens for 1 ether? The `currentRate` will go down as tokens are being sold.
  * @param _baseAvailability The amount of tokens that should be considered "100%" availability.
  */
  constructor(IERC20 _token, uint256 _baseRate, uint256 _baseAvailability) public {
    token = _token;
    baseRate = _baseRate;
    baseAvailability = _baseAvailability;
  }

  /**
  * @dev Returns the current Rate.
  */
  function currentRate() public view returns (uint256) {
    return (baseRate.mul(token.balanceOf(address(this)))).div(baseAvailability);
  }
  
  function() public payable {
    purchaseTokens();
  }

  function purchaseTokens() public payable {
    require(token.balanceOf(address(this)) > 0, "no tokens remaining");

    uint256 amount = msg.value.mul(currentRate()).div(1 ether);
    token.transfer(msg.sender, amount);
    owner().transfer(msg.value);
    emit TokensPurchased(msg.sender, msg.sender, msg.value, amount);
  }

  function takeRemainingTokens() public onlyOwner {
    token.transfer(msg.sender, token.balanceOf(address(this)));
  }

}
