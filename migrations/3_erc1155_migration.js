const { setConfig } = require('./config.js')

const OrbitauERC1155 = artifacts.require("OrbitauERC1155");
const OrbitauERC1155LazyMint = artifacts.require("OrbitauERC1155LazyMint");

module.exports = async function (deployer, network) {
    if (network === "mainnet") {
        let mainContract
        let mainContractAddress

        await deployer.deploy(OrbitauERC1155LazyMint, "");
        mainContract = await OrbitauERC1155LazyMint.deployed();
        mainContractAddress = await mainContract.address
        console.log("Main contract (ERC1155LazyMint) deployed at address", mainContractAddress)
        setConfig('deployed.' + network + '.OrbitauERC1155LazyMint', mainContractAddress)
    } else {
        let mainContract
        let mainContractAddress
        await deployer.deploy(OrbitauERC1155, "");
        mainContract = await OrbitauERC1155.deployed();
        mainContractAddress = await mainContract.address
        console.log("Main contract (ERC1155) deployed at address", mainContractAddress)
        setConfig('deployed.' + network + '.OrbitauERC1155', mainContractAddress)

        await deployer.deploy(OrbitauERC1155LazyMint, "");
        mainContract = await OrbitauERC1155LazyMint.deployed();
        mainContractAddress = await mainContract.address
        console.log("Main contract (ERC1155LazyMint) deployed at address", mainContractAddress)
        setConfig('deployed.' + network + '.OrbitauERC1155LazyMint', mainContractAddress)
    }
};