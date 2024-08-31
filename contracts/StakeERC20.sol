// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

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

    function addStake(uint)external{
      require();
    }

    function CheckReward() external {}

    function checkEndTime() external {}

    function withdraw() external{
      
    }
}
