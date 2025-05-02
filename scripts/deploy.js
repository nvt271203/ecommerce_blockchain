const hre = require("hardhat");
async function main() {
    const MarketplaceProducts = await hre.ethers.getContractFactory("MarketplaceProducts");
    const marketplaceProducts = MarketplaceProducts.deploy();
    await marketplaceProducts.deployed();
    console.log(
        `deploy to ${marketplaceProducts.address}`
    );
}