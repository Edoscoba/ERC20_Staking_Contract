// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ERC20Staking {
   

    IERC20 public stakingToken;
    mapping(address => Stake) public userStake;

    struct Stake {
        uint stakingAmount;
        uint stakeDuration;
        uint stakingtimeStart;
        bool isStake;
    }

    constructor(IERC20 _stakingToken) {
        stakingToken = _stakingToken;
    }

    function userStakeDeposit(uint _stakingAmount, uint _stakeDuration) external {
        require(msg.sender != address(0), "Zero address detected");
        require(_stakingAmount > 0, "Can't deposit zero");
        uint256 _userTokenBalance = stakingToken.balanceOf(msg.sender);
        require(_userTokenBalance >= _stakingAmount, "Insufficient balance");
        Stake memory _staker = userStake[msg.sender];
        require(!_staker.isStake, "User already staked");
        uint _stakingtimeStart = block.timestamp;
        uint _stakeDurationPeriod = _stakeDuration * 30 days;
        stakingToken.safeTransferFrom(msg.sender, address(this), _stakingAmount);
        userStake[msg.sender] = Stake(_stakingAmount, _stakeDurationPeriod, _stakingtimeStart, true);
    }

    function calculateReward(address _staker) public view returns (uint) {
        Stake memory stake = userStake[_staker];
        require(stake.isStake, "No active stake");
        if (block.timestamp >= stake.stakingtimeStart + stake.stakeDuration) {
            uint reward = (stake.stakingAmount * 20) / 100;
            return stake.stakingAmount + reward;
        } else {
            return stake.stakingAmount;
        }
    }

    function withdrawStake() external  {
        Stake memory stake = userStake[msg.sender];
        require(stake.isStake, "No active stake");
        require(block.timestamp >= stake.stakingtimeStart + stake.stakeDuration, "Staking period not yet over");
        uint reward = (stake.stakingAmount * 20) / 100;
        uint totalAmount = stake.stakingAmount + reward;
        delete userStake[msg.sender];
        stakingToken.safeTransfer(msg.sender, totalAmount);
    }

    function checkBalance() external view returns (uint) {
        return calculateReward(msg.sender);
    }

    function extendStakeDuration(uint _newDuration) external {
        Stake memory stake = userStake[msg.sender];
        require(stake.isStake, "No active stake");
        uint newStakeDuration = stake.stakeDuration + _newDuration * 30 days;
        userStake[msg.sender].stakeDuration = newStakeDuration;
    }
}
