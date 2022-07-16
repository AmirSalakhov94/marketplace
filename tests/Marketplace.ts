import {ethers} from "hardhat";
import {expect} from "chai";

describe("Token contract", function () {
    it('Create item erc 721', async () => {
        const [owner] = await ethers.getSigners();

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
        console.log("Token marketplace address:", tokenMarketplace.address);

        let testUri = "Test uri";
        await tokenMarketplace.createItemErc721(owner.address, testUri);
        const balance = await tokenNft721.balanceOf(owner.address)
        console.log("Balance owner:", balance);
        expect(1).to.equal(balance);
        let uri = await tokenNft721.tokenURI(0);
        expect(testUri).to.equal(uri);
    });

    it('List item erc 721', async () => {
        const [owner] = await ethers.getSigners();

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
        console.log("Token marketplace address:", tokenMarketplace.address);

        let testUri = "Test uri";
        await tokenMarketplace.createItemErc721(owner.address, testUri);
        const balance = await tokenNft721.balanceOf(owner.address)
        console.log("Balance owner:", balance);
        expect(1).to.equal(balance);
        let uri = await tokenNft721.tokenURI(0);
        expect(testUri).to.equal(uri);

        let balanceMarketplace = await tokenNft721.balanceOf(tokenMarketplace.address)
        expect(balanceMarketplace).to.equal(0);
        await tokenNft721.approve(tokenMarketplace.address, 0);
        await tokenMarketplace.listItemErc721(0, 111);
        balanceMarketplace = await tokenNft721.balanceOf(tokenMarketplace.address)
        expect(balanceMarketplace).to.equal(1);

    });

    it('Cancel item erc 721', async () => {
        const [owner] = await ethers.getSigners();

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
        console.log("Token marketplace address:", tokenMarketplace.address);

        let testUri = "Test uri";
        await tokenMarketplace.createItemErc721(owner.address, testUri);
        let balanceOwner = await tokenNft721.balanceOf(owner.address)
        expect(1).to.equal(balanceOwner);
        let uri = await tokenNft721.tokenURI(0);
        expect(testUri).to.equal(uri);

        //transfer token for marketplace
        let balanceMarketplace = await tokenNft721.balanceOf(tokenMarketplace.address)
        expect(balanceMarketplace).to.equal(0);
        await tokenNft721.approve(tokenMarketplace.address, 0);
        await tokenMarketplace.listItemErc721(0, 111);
        balanceMarketplace = await tokenNft721.balanceOf(tokenMarketplace.address)
        expect(balanceMarketplace).to.equal(1);

        //cancel transfer token for marketplace
        await tokenMarketplace.cancelErc721(0);
        balanceMarketplace = await tokenNft721.balanceOf(tokenMarketplace.address)
        expect(balanceMarketplace).to.equal(0);

        //check return token owner
        balanceOwner = await tokenNft721.balanceOf(owner.address)
        expect(balanceOwner).to.equal(1);
    });

    it('Buy item erc 721', async () => {
        const [owner, addr1] = await ethers.getSigners();

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
        console.log("Token marketplace address:", tokenMarketplace.address);

        let testUri = "Test uri";
        await tokenMarketplace.createItemErc721(owner.address, testUri);
        let balanceOwner = await tokenNft721.balanceOf(owner.address)
        expect(1).to.equal(balanceOwner);
        let uri = await tokenNft721.tokenURI(0);
        expect(testUri).to.equal(uri);

        //transfer token for marketplace
        let balanceMarketplace = await tokenNft721.balanceOf(tokenMarketplace.address)
        expect(balanceMarketplace).to.equal(0);
        await tokenNft721.approve(tokenMarketplace.address, 0);
        await tokenMarketplace.listItemErc721(0, 111);
        balanceMarketplace = await tokenNft721.balanceOf(tokenMarketplace.address)
        expect(balanceMarketplace).to.equal(1);

        //addr1 buy token from marketplace
        await tokenErc20.transfer(addr1.address, 1000);
        await tokenErc20.connect(addr1).approve(tokenMarketplace.address, 1000);
        await tokenMarketplace.connect(addr1).buyItemErc721(0);
        expect(balanceMarketplace).to.equal(1);
    });

    it('Auction item erc 721', async () => {
        const [owner, addr1] = await ethers.getSigners();

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
        console.log("Token marketplace address:", tokenMarketplace.address);

        let testUri = "Test uri";
        await tokenMarketplace.createItemErc721(owner.address, testUri);
        let balanceOwner = await tokenNft721.balanceOf(owner.address)
        expect(1).to.equal(balanceOwner);
        let uri = await tokenNft721.tokenURI(0);
        expect(testUri).to.equal(uri);

        //transfer token for marketplace
        let balanceMarketplace = await tokenNft721.balanceOf(tokenMarketplace.address)
        expect(balanceMarketplace).to.equal(0);
        await tokenNft721.approve(tokenMarketplace.address, 0);
        await tokenMarketplace.listItemOnAuctionErc721ForTest(0, 25, 1657703537);
        balanceMarketplace = await tokenNft721.balanceOf(tokenMarketplace.address)
        expect(balanceMarketplace).to.equal(1);

        //if bid < 2
        //addr1 make bid
        await tokenErc20.transfer(addr1.address, 1000);
        let balanceAddr1 = await tokenErc20.balanceOf(addr1.address)
        expect(balanceAddr1).to.equal(1000);
        console.log("balanceAddr1:", balanceAddr1);
        await tokenErc20.connect(addr1).approve(tokenMarketplace.address, 1000);
        await tokenMarketplace.connect(addr1).makeBid(0, 50);
        balanceMarketplace = await tokenNft721.balanceOf(tokenMarketplace.address)
        console.log("balanceMarketplace:",balanceMarketplace);

        balanceAddr1 = await tokenErc20.balanceOf(addr1.address)
        expect(balanceAddr1).to.equal(950);
        console.log("balanceAddr1:", balanceAddr1);

        //addr1 finished auction
        await tokenMarketplace.finishAuctionErc721(0);
        balanceMarketplace = await tokenNft721.balanceOf(tokenMarketplace.address)
        console.log("balanceMarketplace:",balanceMarketplace);

        balanceAddr1 = await tokenErc20.balanceOf(addr1.address)
        console.log("balanceAddr1:", balanceAddr1);
        expect(balanceAddr1).to.equal(1000);
    });
});
