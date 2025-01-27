# Staking Token Project

A decentralized staking token system built with Solidity and tested using Foundry. This project demonstrates the implementation of staking, rewards distribution, early withdrawal penalties, and dynamic locking mechanisms, making it ideal for Web3 portfolios.

---

## Features

- **ERC-20 Token:** Built using OpenZeppelin's ERC-20 standard.
- **Staking:** Users can stake tokens to earn rewards over time.
- **Rewards Distribution:** Calculated based on staked amount and duration.
- **Locking Period:** Tokens are locked for a configurable period, with penalties for early withdrawal.
- **Dynamic Penalties:** A percentage penalty is applied for unstaking before the lock duration ends.
- **Testing:** Fully tested using Foundry for core functionality and edge cases.

---

## Tech Stack

- **Solidity:** Used for smart contract development.
- **Foundry:** Framework for testing and deployment.
- **OpenZeppelin:** Library for ERC-20 implementation and security best practices.

---

## Installation and Setup

### Prerequisites
1. **Foundry:** Install Foundry by following the [Foundry Installation Guide](https://book.getfoundry.sh/getting-started/installation.html).
2. **Node.js:** (Optional) Used for additional tooling if required.

### Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/staking-token-project.git
   cd staking-token-project
   ```

2. Install Foundry dependencies:
   ```bash
   forge install
   ```

3. Compile the contracts:
   ```bash
   forge build
   ```

4. Run tests:
   ```bash
   forge test
   ```

---

## Project Structure

```
staking-token-project
├── src
│   ├── Token.sol          # ERC-20 Token contract
│   ├── Staking.sol        # Staking contract
├── test
│   └── Staking.t.sol      # Foundry tests for the project
├── foundry.toml           # Foundry configuration file
├── README.md              # Project documentation
```

---

## How It Works

1. **Staking:**
   - Users can stake their tokens using the `stake()` function.
   - The contract tracks the staked amount and start time for each user.

2. **Rewards Calculation:**
   - Rewards are calculated dynamically based on the staked amount, staking duration, and the reward rate.
   - Users can claim rewards using the `claimRewards()` function.

3. **Locking Period:**
   - Tokens are locked for a specific duration (`lockDuration`).
   - Early unstaking incurs a penalty (`earlyWithdrawalPenalty`).

4. **Unstaking:**
   - Users can unstake their tokens using the `unstake()` function.
   - The penalty is deducted if unstaking occurs before the lock duration ends.

5. **Testing:**
   - Foundry tests cover staking, reward calculations, early withdrawal penalties, and edge cases.

---

## Example Contract Functions

### `stake(uint256 amount)`
- Allows users to stake tokens.
- Tokens are transferred from the user to the staking contract.

### `claimRewards()`
- Users can claim rewards based on the staked amount and duration.
- Rewards are transferred to the user's wallet.

### `unstake()`
- Allows users to withdraw staked tokens.
- Applies a penalty if unstaked before the lock duration.

### `calculateRewards(address user)`
- Calculates the rewards a user has earned based on their staked amount and duration.

---

## Future Enhancements

1. **Dynamic APY:** Introduce variable APY rates based on the total staked amount or other factors.
2. **Frontend Integration:** Build a React.js interface for interacting with the contract.
3. **Multisig Rewards Management:** Add multisig wallets for managing reward pools securely.
4. **Deploy to Testnets:** Deploy the contract on Ethereum testnets (e.g., Goerli or Sepolia) for public interaction.

---

## License
This project is licensed under the MIT License.

---

## Contact
For any questions or feedback, feel free to reach out:

- **GitHub:** [srjvastri](https://github.com/srjvastri)
- **Email:** srjvastri8@gmail.com

