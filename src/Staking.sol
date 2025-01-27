// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract Staking {
    IERC20 public stakingToken;

    uint256 public rewardRate; // Reward rate per second
    uint256 public lockDuration; // Lock period in seconds
    uint256 public earlyWithdrawalPenalty; // Penalty percentage (e.g., 10)

    struct Stake {
        uint256 amount; // Staked amount
        uint256 startTime; // Staking start time
    }

    mapping(address => Stake) public stakes;
    mapping(address => uint256) public rewardDebt;

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event RewardsClaimed(address indexed user, uint256 amount);

    constructor(
        address _stakingToken,
        uint256 _rewardRate,
        uint256 _lockDuration,
        uint256 _earlyWithdrawalPenalty
    ) {
        stakingToken = IERC20(_stakingToken);
        rewardRate = _rewardRate;
        lockDuration = _lockDuration;
        earlyWithdrawalPenalty = _earlyWithdrawalPenalty;
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Cannot stake 0 tokens");

        // Transfer tokens to the staking contract
        stakingToken.transferFrom(msg.sender, address(this), amount);

        // Update user stake
        Stake storage userStake = stakes[msg.sender];
        userStake.amount += amount;
        userStake.startTime = block.timestamp;

        emit Staked(msg.sender, amount);
    }

    function calculateRewards(address user) public view returns (uint256) {
        Stake storage userStake = stakes[user];
        uint256 stakingDuration = block.timestamp - userStake.startTime;
        return (userStake.amount * stakingDuration * rewardRate) / 1e18;
    }

    function claimRewards() external {
        uint256 rewards = calculateRewards(msg.sender);
        require(rewards > 0, "No rewards available");

        // Update reward debt
        rewardDebt[msg.sender] += rewards;

        // Transfer rewards (mint or transfer from a reward pool)
        stakingToken.transfer(msg.sender, rewards);

        emit RewardsClaimed(msg.sender, rewards);
    }

    function unstake() external {
        Stake storage userStake = stakes[msg.sender];
        require(userStake.amount > 0, "No tokens staked");

        uint256 stakingDuration = block.timestamp - userStake.startTime;
        uint256 amount = userStake.amount;
        uint256 penalty = 0;

        // Apply penalty if unstaking before lock duration
        if (stakingDuration < lockDuration) {
            penalty = (amount * earlyWithdrawalPenalty) / 100;
            amount -= penalty;
        }

        // Reset user stake
        delete stakes[msg.sender];

        // Transfer tokens back to user
        stakingToken.transfer(msg.sender, amount);

        emit Unstaked(msg.sender, amount);
    }
}
