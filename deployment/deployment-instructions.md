# Deploying Ycbm42 Token

## Prerequisites
- **MetaMask** wallet configured for the Sepolia Testnet  
- Test ETH for gas fees from [Sepolia Faucet](https://sepoliafaucet.com/) or [Google Cloud Faucet](https://cloud.google.com/application/web3/faucet/ethereum)  
- Access to the [Remix IDE](https://remix.ethereum.org/)  

## Deployment Steps
1. Open **Remix IDE** and create a new file named `Ycbm42.sol`.
2. Paste the Ycbm42 smart contract code into the file.
3. Set the Solidity compiler version to **^0.8.0**.
4. Compile the contract without errors.
5. In the **Deploy & Run Transactions** panel, select `Injected Provider - MetaMask` as the environment.
6. Click **Deploy**, then approve the transaction in MetaMask.
7. Wait for the confirmation — your token is now live on the Sepolia Testnet.

## Contract Details
- **Deployed Address**: [`0x8e848ecd36c86c9e5a5cf886472ad4f5443b7f43`](https://sepolia.etherscan.io/address/0x8e848ecd36c86c9e5a5cf886472ad4f5443b7f43)  
- **Network**: Sepolia Testnet
