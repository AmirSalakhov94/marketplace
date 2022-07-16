// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./NFT721.sol";
import "./NFT1155.sol";
import "./ERC20.sol";

contract Marketplace {

    using Counters for Counters.Counter;
    Counters.Counter private _itemMarketSimpleCounter;
    Counters.Counter private _itemMarketAuctionCounter;

    struct ItemMarketSimple {
        uint256 tokenId;
        address seller;
        address owner;
        uint256 amount;
        uint256 price;
    }

    struct ItemMarketAuction {
        uint256 tokenId;
        address seller;
        address owner;
        uint256 amount;
        uint256 minPrice;
        uint256 countBid;
        address lastBidder;
        uint256 startAuction;
    }

    mapping(uint256 => ItemMarketSimple) private _itemsMarketSimple;
    mapping(uint256 => ItemMarketAuction) private _itemsMarketAuction;
    address private _owner;
    address private _erc721;
    address private _erc1155;
    address private _erc20;

    constructor(address erc721_, address erc1155_, address erc20_) {
        _itemMarketSimpleCounter._value = 0;
        _itemMarketAuctionCounter._value = 0;
        _owner = msg.sender;
        _erc721 = erc721_;
        _erc1155 = erc1155_;
        _erc20 = erc20_;
    }

    //erc721
    function createItemErc721(address owner, string memory uri) public {
        NFT721(_erc721).mint(owner, uri);
    }

    function listItemErc721(uint256 tokenId, uint256 price) public {
        _itemsMarketSimple[_itemMarketSimpleCounter.current()] = ItemMarketSimple(
            tokenId,
            msg.sender,
            address(this),
            0,
            price);

        NFT721(_erc721).transferFrom(msg.sender, address(this), tokenId);

        _itemMarketSimpleCounter.increment();
    }

    function cancelErc721(uint256 itemId) public {
        ItemMarketSimple memory item = _itemsMarketSimple[itemId];
        require(msg.sender == item.seller, "Access denied");

        NFT721(_erc721).transferFrom(address(this), msg.sender, item.tokenId);

        delete _itemsMarketSimple[itemId];
    }

    function buyItemErc721(uint256 itemId) public {
        ItemMarketSimple memory item = _itemsMarketSimple[itemId];

        require(ERC20(_erc20).allowance(msg.sender, address(this)) >= item.price, "Marketplace dont have allowance");

        ERC20(_erc20).transferFrom(msg.sender, item.seller, item.price);

        NFT721(_erc721).transferFrom(address(this), msg.sender, item.tokenId);
        delete _itemsMarketSimple[itemId];
    }

    function listItemOnAuctionErc721ForTest(uint256 tokenId, uint256 minPrice, uint256 startAuction) public {
        _itemsMarketAuction[_itemMarketAuctionCounter.current()] = ItemMarketAuction(
            tokenId,
            msg.sender,
            address(this),
            0,
            minPrice,
            0,
            address(0x0),
            startAuction);

        NFT721(_erc721).transferFrom(msg.sender, address(this), tokenId);

        _itemMarketAuctionCounter.increment();
    }

    function listItemOnAuctionErc721(uint256 tokenId, uint256 minPrice) public {
        _itemsMarketAuction[_itemMarketAuctionCounter.current()] = ItemMarketAuction(
            tokenId,
            msg.sender,
            address(this),
            0,
            minPrice,
            0,
            address(0x0),
            block.timestamp);

        NFT721(_erc721).transferFrom(msg.sender, address(this), tokenId);

        _itemMarketAuctionCounter.increment();
    }

    function finishAuctionErc721(uint256 itemId) public {
        ItemMarketAuction memory item = _itemsMarketAuction[itemId];
        require(block.timestamp - item.startAuction > 3 days, "Auction not completed");
        if (item.countBid > 2) {
            NFT721(_erc721).transferFrom(address(this), item.lastBidder, item.tokenId);
            ERC20(_erc20).transfer(item.seller, item.minPrice);
        } else {
            NFT721(_erc721).transferFrom(address(this), item.seller, item.tokenId);
            ERC20(_erc20).transfer(item.lastBidder, item.minPrice);
        }

        delete _itemsMarketAuction[itemId];
    }

    //erc1155
    function createItemErc1155(address owner, string memory uri, uint256 amount) public {
        NFT1155(_erc1155).mint(owner, amount, uri);
    }

    function listItemErc1155(uint256 tokenId, uint256 amount, uint256 price) public {
        _itemsMarketSimple[_itemMarketSimpleCounter.current()] = ItemMarketSimple(
            tokenId,
            msg.sender,
            address(this),
            amount,
            price);

        NFT1155(_erc1155).safeTransferFrom(msg.sender, address(this), tokenId, amount, "");

        _itemMarketSimpleCounter.increment();
    }

    function cancelErc1155(uint256 itemId) public {
        ItemMarketSimple memory item = _itemsMarketSimple[itemId];
        require(msg.sender == item.seller, "Access denied");

        NFT1155(_erc1155).safeTransferFrom(address(this), msg.sender, item.tokenId, item.amount, "");

        delete _itemsMarketSimple[itemId];
    }

    function buyItemErc1155(uint256 itemId) public {
        ItemMarketSimple memory item = _itemsMarketSimple[itemId];
        require(ERC20(_erc20).allowance(msg.sender, address(this)) >= item.price, "Marketplace dont have allowance");

        ERC20(_erc20).transferFrom(msg.sender, item.seller, item.price);

        NFT1155(_erc1155).safeTransferFrom(address(this), msg.sender, item.tokenId, item.amount, "");
        delete _itemsMarketSimple[itemId];
    }

    function listItemOnAuctionErc1155(uint256 tokenId, uint256 amount, uint256 minPrice) public {
        _itemsMarketAuction[_itemMarketAuctionCounter.current()] = ItemMarketAuction(
            tokenId,
            msg.sender,
            address(this),
            amount,
            minPrice,
            0,
            address(0x0),
            block.timestamp);

        NFT1155(_erc1155).safeTransferFrom(msg.sender, address(this), tokenId, amount, "");

        _itemMarketAuctionCounter.increment();
    }

    function finishAuctionErc1155(uint256 itemId) public {
        ItemMarketAuction memory item = _itemsMarketAuction[itemId];
        require(block.timestamp - item.startAuction > 3 days, "Auction not completed");
        if (item.countBid > 2) {
            NFT1155(_erc1155).safeTransferFrom(address(this), item.lastBidder, item.tokenId, item.amount, "");
            ERC20(_erc20).transfer(item.seller, item.minPrice);
        } else {
            NFT1155(_erc1155).safeTransferFrom(address(this), item.seller, item.tokenId, item.amount, "");
            ERC20(_erc20).transfer(item.lastBidder, item.minPrice);
        }

        delete _itemsMarketAuction[itemId];
    }

    function makeBid(uint256 itemId, uint256 price) public {
        ItemMarketAuction memory item = _itemsMarketAuction[itemId];
        require(item.minPrice < price, "Price to low");
        require(ERC20(_erc20).allowance(msg.sender, address(this)) >= price, "Marketplace dont have allowance");

        if (item.countBid > 0) {
            ERC20(_erc20).transfer(item.lastBidder, item.minPrice);
        }
        ERC20(_erc20).transferFrom(msg.sender, address(this), price);
        item.minPrice = price;
        item.lastBidder = msg.sender;
        item.countBid += 1;
        _itemsMarketAuction[itemId] = item;
    }
}