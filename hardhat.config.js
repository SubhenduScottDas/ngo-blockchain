require("@nomicfoundation/hardhat-toolbox");
/** @type import('hardhat/config').HardhatUserConfig */
const { vars } = require("hardhat/config");

const METAMASK_API_KEY = vars.get("METAMASK_API_KEY");

module.exports = {
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545",
    },
    mainnet: {
      url: `https://mainnet.infura.io/v3/${METAMASK_API_KEY}`,
      // accounts: [vars.get("METAMASK_PK")],
      
    },
  },
  solidity: "0.8.27",
};