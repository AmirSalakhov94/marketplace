import {ethers} from "hardhat";

async function main() {
  const tokenFactoryNft721 = await ethers.getContractFactory("NFT721");
  const tokenNft721 = await tokenFactoryNft721.deploy();
  console.log("Token NFT721 address:", tokenNft721.address);

  const tokenFactoryNft1155 = await ethers.getContractFactory("NFT1155");
  const tokenNft1155 = await tokenFactoryNft1155.deploy();
  console.log("Token NFT1155 address:", tokenNft1155.address);

  const tokenFactoryErc20 = await ethers.getContractFactory("ERC20");
  const tokenErc20 = await tokenFactoryErc20.deploy();
  console.log("Token ERC20 address:", tokenErc20.address);

  const tokenFactoryMarketplace = await ethers.getContractFactory("Marketplace");
  const tokenMarketplace = await tokenFactoryMarketplace.deploy(tokenNft721.address, tokenNft1155.address, tokenErc20.address);
  console.log("Token marketpalce address:", tokenMarketplace.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
