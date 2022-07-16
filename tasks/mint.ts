import {task} from "hardhat/config";

task("mint", "Mint")
    .addParam("tokenErc20", "Token erc20")
    .addParam("tokenNft721", "Token nft721")
    .addParam("tokenNft1155", "Token nft1155")
    .setAction(async (taskArgs, {ethers}) => {
            console.log("Started")

            const tokenFactory = await ethers.getContractFactory("NFT721")
            const token = tokenFactory.attach(taskArgs.token)

            await token.mint(taskArgs.to, taskArgs.tokenid, taskArgs.uri)

            console.log("Finished")
    })
