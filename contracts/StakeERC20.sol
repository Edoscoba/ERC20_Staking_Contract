// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ERC20Staking {

    IERC20 public stakingToken;

    mapping(address => Stake) public userStake;

    struct Stake {
        uint stakingAmount;
        uint stakeDuration;
        uint stakingTimeStart;
        bool isStake;
    }

    constructor(address _stakingToken) {
        stakingToken = IERC20(_stakingToken);
    }

    function userStakeDeposit(uint _stakingAmount, uint _stakeDuration) external {
        require(msg.sender != address(0), "Zero address detected");


        require(_stakingAmount > 0, "Can't deposit zero");

        uint256 _userTokenBalance = stakingToken.balanceOf(msg.sender);

        require(_userTokenBalance >= _stakingAmount, "Insufficient balance");

        Stake memory _staker = userStake[msg.sender];

        require(!_staker.isStake, "User already staked");

        uint _stakingTimeStart = block.timestamp;

        uint _stakeDurationPeriod = _stakeDuration * 30 days;

        stakingToken.transferFrom(msg.sender, address(this), _stakingAmount);

        userStake[msg.sender] = Stake(_stakingAmount, _stakeDurationPeriod, _stakingTimeStart, true);
    }

    function calculateReward() public view returns (uint) {

        Stake memory stake = userStake[msg.sender];

        require(stake.isStake, "No active stake");

        if (block.timestamp >= stake.stakingTimeStart + stake.stakeDuration) {

            uint reward = (stake.stakingAmount * 20) / 100;
            
            return stake.stakingAmount + reward;
        } else {
            return stake.stakingAmount;
        }
    }

    function withdrawStake() external {

        Stake memory stake = userStake[msg.sender];

        require(stake.isStake, "No active stake");

        require(block.timestamp >= stake.stakingTimeStart + stake.stakeDuration, "Staking period not yet over");

        uint reward = (stake.stakingAmount * 20) / 100;

        uint totalAmount = stake.stakingAmount + reward;

        delete userStake[msg.sender];

        stakingToken.transfer(msg.sender, totalAmount);
    }

    function checkBalance() external view returns (uint) {
      
        return calculateReward(msg.sender);
    }
}

