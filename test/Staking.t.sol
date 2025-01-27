// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Token.sol";
import "../src/Staking.sol";

contract StakingTest is Test {
    StakingToken private token;
    Staking private staking;

    address private user = address(1);


    function setUp() public {
        token = new StakingToken(1_000_000 ether); // Deploy token with 1M supply
        staking = new Staking(address(token), 1e18, 1 weeks, 10); // Reward rate = 1 token/sec, lock = 1 week, penalty = 10%

        // Mint tokens for the user and staking contract
        token.transfer(user, 1_000 ether); // Fund user
        token.transfer(address(staking), 100_000 ether); // Fund staking contract

        // Approve staking contract to use user's tokens
        vm.prank(user);
        token.approve(address(staking), 1_000 ether);
    }

    function testStake() public {
        vm.prank(user);
        staking.stake(100 ether);

        assertEq(token.balanceOf(user), 900 ether, "User balance should decrease");
        assertEq(token.balanceOf(address(staking)), 100 ether, "Contract balance should increase");
    }

    function testUnstakeWithPenalty() public {
        vm.prank(user);
        staking.stake(100 ether);

        // Advance time to 3 days (before lock duration)
        vm.warp(block.timestamp + 3 days);

        vm.prank(user);
        staking.unstake();

        uint256 expectedAmount = 100 ether - (100 ether * 10) / 100; // Apply 10% penalty
        assertEq(token.balanceOf(user), 900 ether + expectedAmount, "User should receive remaining tokens after penalty");
    }

    function testClaimRewards() public {
        vm.prank(user);
        staking.stake(100 ether);

        // Advance time to 10 seconds
        vm.warp(block.timestamp + 10);

        vm.prank(user);
        staking.claimRewards();

        uint256 expectedRewards = 100 ether * 10; // Reward rate = 1 token/sec
        assertEq(token.balanceOf(user), 900 ether + expectedRewards, "User should receive rewards");
    }
}
