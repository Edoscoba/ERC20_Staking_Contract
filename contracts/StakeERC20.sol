// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";



 contract StakeERC20{ 

address owner;
address tokenAddress;

constructor(address _tokenAddress){
  owner = msg.sender;
  tokenAddress = _tokenAddress;
}

mapping(address => User) userStaking;

    struct User {
        address userAddress;
        uint timeStart;
        uint duration;
        uint ERC20Staked;
        uint rewardsEarned;
    }

    function addStake(uint _stakedAmount, uint duration)external{
      require(msg.sender != address(0), "address zero detected");
      uint _userbalance = IERC20(tokenAddress).balanceOf(msg.sender);

      require(_userbalance >= _stakedAmount,"You dont have enough token to stake" );

      IERC20(tokenAddress).transferFrom(msg.sender, address(this), _stakedAmount);
       balances[msg.sender] += _amount;


    }

    function CheckReward() external {}

    function checkEndTime() external {}

    function withdraw() external{
      
      
    }
}
