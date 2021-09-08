const { setConfig } = require('./config.js')

const OrbitauNFT = artifacts.require("OrbitauERC721");
const OrbitauNFTEnum = artifacts.require("OrbitauERC721Enumerable");
const OrbitauNFTLazyMint = artifacts.require("OrbitauERC721LazyMint");

module.exports = async function (deployer, network) {
    if (network === 'mainnet') {
        let mainContract
        let mainContractAddress

        await deployer.deploy(OrbitauNFTLazyMint);
        mainContract = await OrbitauNFTLazyMint.deployed();
        mainContractAddress = await mainContract.address
        console.log("Main contract (lazyMint) deployed at address", mainContractAddress)
        setConfig('deployed.' + network + '.OrbitauERC721LazyMint', mainContractAddress)

    } else {
        let mainContract
        let mainContractAddress

        await deployer.deploy(OrbitauNFT);
        mainContract = await OrbitauNFT.deployed();
        mainContractAddress = await mainContract.address
        console.log("Main contract (ERC721) deployed at address", mainContractAddress)
        setConfig('deployed.' + network + '.OrbitauERC721', mainContractAddress)

        await deployer.deploy(OrbitauNFTEnum);
        mainContract = await OrbitauNFTEnum.deployed();
        mainContractAddress = await mainContract.address
        console.log("Main contract (ERC721Enumerable) deployed at address", mainContractAddress)
        setConfig('deployed.' + network + '.OrbitauERC721Enumerable', mainContractAddress)

        await deployer.deploy(OrbitauNFTLazyMint);
        mainContract = await OrbitauNFTLazyMint.deployed();
        mainContractAddress = await mainContract.address
        console.log("Main contract (ERC721LazyMint) deployed at address", mainContractAddress)
        setConfig('deployed.' + network + '.OrbitauERC721LazyMint', mainContractAddress)
    }
};