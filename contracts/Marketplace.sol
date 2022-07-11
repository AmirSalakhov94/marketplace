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
        uint256 price;
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

    function listItem(uint256 tokenId, uint256 amount, uint256 price) public {
        items[_itemCounter.current()] = Item(
            tokenId,
            msg.sender,
            address(this),
            amount,
            price);

        U1155(_erc1155).safeTransferFrom(msg.sender, address(this), tokenId, amount, 0x00);

        _itemCounter.increment();
    }

    function cancel(uint256 itemId) public {
        require(msg.sender == items[itemId].seller, "Access denied");

        U1155(_erc1155).safeTransferFrom(address(this), msg.sender, tokenId, amount, 0x00);

        delete items[itemId];
    }

    function buyItem(uint256 itemId) public {
        Item item = items[itemId];
        require(ERC20(_erc20).allowance(msg.sender, address(this)) >= item.price, "Marketplace dont have allowance");

        ERC20(_erc20).transferFrom(msg.sender, item.seller, item.price);

        U1155(_erc1155).safeTransferFrom(address(this), msg.sender, item.tokenId, item.amount, 0x00);
        delete items[itemId];
    }
}
