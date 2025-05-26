# Car Market - NFT Registry

A decentralized application (dApp) for registering vehicles as NFTs, tracking their services, and logging insurance incidents — all securely verifiable on the Ethereum blockchain.

---

## Table of Contents

- [Features](#features)  
- [Prerequisites](#prerequisites)  
- [Compile & Deploy on Remix](#1-compile--deploy-on-remix)  
- [Clone & Install Locally](#2-clone--install-locally)  
- [Configure the Frontend](#3-configure-the-frontend)  
- [Usage](#usage)  
- [Project Structure](#project-structure)  
- [Dependencies](#dependencies)  
- [Troubleshooting](#troubleshooting)  
- [Contributors](#contributors)  
- [License](#license)

---

## Features

- Register and mint a car as an NFT
- Log service history and insurance incidents immutably
- Verify full vehicle history transparently on-chain
- Interact with MetaMask for Web3 authentication
- Frontend integrated with a deployed smart contract

---

## Prerequisites

Before starting, make sure you have:

- A browser with [MetaMask](https://metamask.io/) installed  
- [Node.js & npm](https://nodejs.org/)  
- (Optional) Visual Studio Code or any IDE with an integrated terminal

---

## 1. Compile & Deploy on Remix

1. **Clone or download** this repository to your machine.  
2. Open [Remix IDE](https://remix.ethereum.org/)  
3. In the **File Explorer**, click the ➕ icon and **Open Folder**  
   - Select the cloned repo’s folder
4. Go to the **Solidity Compiler** tab:  
   - Select `VehicleTrackingSystems.sol`  
   - Set compiler version to `^0.8.0` or as specified in the contract  
   - Click **Compile**
5. Navigate to the **Deploy & Run Transactions** tab:  
   - Select **Cars** contract from the dropdown  
   - Click **Deploy** and confirm in MetaMask  
6. Copy the **deployed contract address** from the Remix terminal

---

## 2. Clone & Install Locally

In your terminal or IDE:

```bash
git clone https://github.com/OptimusNib/IFB452.git
cd your-repo
npm install
npm start
```

---

## 3. Configure the Frontend

1. Open `abi.js` in the project root  
2. Replace the placeholder contract address with your deployed address:
   ```js
   const carsAddress = "0xYourNewlyDeployedAddressHere";
   ```

---

## Usage

- Connect your MetaMask wallet to the frontend
- Register new vehicles using the dApp interface
- Log service or insurance entries under each vehicle
- View full ownership and maintenance history on-chain

---

## Project Structure

```
.
├── .deps/
├── .git/
├── .states/
├── Frontend/
│   ├── abi.js
│   ├── index.html
│   ├── package.json
│   ├── styles.css
│   └── My front end for registering car and logging details...
├── OpenZeppelin ERC721 - 5/
│   ├── .deps/
│   └── .states/
├── contracts/
│   ├── artifacts/
│   └── VehicleTrackingSystems.sol
├── scripts/
├── tests/
├── .prettierrc.json
└── README.md

```

---

## Dependencies

- `web3.js`  
- `react`  
- node.js


Run the following to install dependencies:

```bash
npm install
```

---

## Troubleshooting

- **Contract not detected?**  
  Make sure MetaMask is connected to the correct network and the contract address is correct in `abi.js`.

- **Compiler errors in Remix?**  
  Verify you’re using the correct Solidity version (`^0.8.0`) and have selected the right contract file.

- **Frontend not loading data?**  
  Confirm MetaMask is unlocked and the ABI is correctly defined in `abi.js`.

---

## Contributors

- Sullivan Beare
- Tan Phu Truong
- Jithin Cyriac

---
