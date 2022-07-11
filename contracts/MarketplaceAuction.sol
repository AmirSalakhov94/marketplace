// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./U1155.sol";
import "./ERC20.sol";

contract Marketplace {

    using Counters for Counters.Counter;
    Counters.Counter private _itemCounter;

    struct Item {
        uint256 tokenId;
        address seller;
        address owner;
        uint256 amount;
        uint256 minPrice;
        uint256 countBid;
        address lastBidder;
        uint256 startAuction;
    }

    mapping(uint256 => Item) private items;
    address private _owner;
    address private _erc1155;
    address private _erc20;

    constructor(address erc1155_, address erc20_) {
        _itemCounter = 0;
        _owner = msg.sender;
        _erc1155 = erc1155_;
        _erc20 = erc20_;
    }

    function createItem(address owner, string memory uri, uint256 amount) public {
        U1155(_erc1155).mint(owner, amount, uri);
    }

    function listItemOnAuction(uint256 tokenId, uint256 amount, uint256 minPrice) public {
        items[_itemCounter.current()] = Item(
            tokenId,
            msg.sender,
            address(this),
            amount,
            minPrice,
            0,
            0x0,
            block.timestamp);

        U1155(_erc1155).safeTransferFrom(msg.sender, address(this), tokenId, amount, 0x00);

        _itemCounter.increment();
    }

    function finishAuction(uint256 itemId) public {
        Item item = items[itemId];
        require(msg.sender == item.seller, "Access denied");
        require(block.timestamp - item.startAuction > 3 days, "Auction not completed");
        if (item.countBid > 2) {
            U1155(_erc1155).safeTransferFrom(address(this), item.lastBidder, item.tokenId, item.amount, 0x00);
            ERC20(_erc20).transfer(item.seller, item.price);
        } else {
            U1155(_erc1155).safeTransferFrom(address(this), item.seller, item.tokenId, item.amount, 0x00);
            ERC20(_erc20).transfer(item.lastBidder, item.price);
        }
        delete items[itemId];
    }

    function makeBid(uint256 itemId, uint256 price) public {
        Item item = items[itemId];
        require(item.minPrice < price, "Price to low");
        require(ERC20(_erc20).allowance(msg.sender, address(this)) >= price, "Marketplace dont have allowance");

        if (item.countBid > 0) {
            ERC20(_erc20).transfer(item.lastBidder, item.minPrice);
        }
        ERC20(_erc20).transferFrom(msg.sender, address(this), price);
        item.minPrice = price;
        item.lastBidder = msg.sender;
        item.countBid += 1;
        items[itemId] = item;
    }
}
