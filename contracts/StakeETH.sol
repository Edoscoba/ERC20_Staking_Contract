// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract StakingETH {

    address owner;

    constructor() {
        owner = msg.sender;
    }

    mapping(address => User) userStaking;

    struct User {
        address userAddress;
        uint timeStart;
        uint duration;
        uint amountStaked;
        uint rewardsEarned;
    }


    function addStaking(uint _duration, uint _amountStaked) external payable {
        require(msg.sender != address(0), "address zero detected");
        require(_amountStaked > 0, "can't stake zero amount");
        require(msg.value == _amountStaked, "amount sent does not match _amountStaked");
        uint _timeStart = block.timestamp;
        uint _durationStaking = _duration * 1 days; 
        userStaking[msg.sender] = User(msg.sender, _timeStart, _durationStaking, _amountStaked, 0);
    }

    function userStakingTimeStart() external view returns (uint) {
        return userStaking[msg.sender].timeStart;
    }

    function userStakingTimeEnd() external view returns (uint) {
        return userStaking[msg.sender].timeStart + userStaking[msg.sender].duration;
    }

    function userStakingBalance() external view returns (uint) {
        return userStaking[msg.sender].amountStaked;
    }

    function userStakingReward() external view returns (uint) {
        uint _timeEnd = userStaking[msg.sender].timeStart + userStaking[msg.sender].duration;
        uint _timeStart = userStaking[msg.sender].timeStart;
        uint _durationStaking = userStaking[msg.sender].duration;
        uint _amountStaked = userStaking[msg.sender].amountStaked;
        uint _rewardAmountStaked = (_amountStaked * (_timeEnd - _timeStart)) / _durationStaking;
        return _rewardAmountStaked;
    }

    function withdraw() external {
        require(msg.sender != address(0), "address zero detected");
        require(block.timestamp >= userStaking[msg.sender].timeStart + userStaking[msg.sender].duration, "staking period not ended");
        uint amountToWithdraw = userStaking[msg.sender].amountStaked + userStaking[msg.sender].rewardsEarned;
        userStaking[msg.sender].amountStaked = 0;
        userStaking[msg.sender].rewardsEarned = 0;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "transaction failed");
    }
}

