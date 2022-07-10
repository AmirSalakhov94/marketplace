// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./U1155.sol";

contract Marketplace {

    using Counters for Counters.Counter;
    Counters.Counter private _itemCounter;

    struct Item {
        uint256 itemId;
        address nftAddress;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
    }

    address[] private createdTokens;
    mapping(uint256 => Item) private items;
    address private _owner;

    constructor() {
        _itemCounter = 0;
        _owner = msg.sender;
    }

    function createItem(address _owner, string memory _uri, uint256 _amount) public {
        const token1155 = new U1155(_owner, _uri, _amount);
        createdTokens.push(token1155);
    }

    function listItem(address _nftAddress, uint256 _tokenId, uint256 _amount, uint256 _price) public payable {
        items[_itemCounter.current()] = Item(
            _itemCounter.current(),
            _nftAddress,
            _tokenId,
            payable(msg.sender),
            payable(address(this)),
            _price);

        U1155(_nftAddress).safeTransferFrom(msg.sender, address(this), _tokenId, _amount, 0x00);

        _itemCounter.increment();
    }

    function buyItem(uint256 _tokenId) public payable {
        items[_tokenId]
        items[_tokenId].owner = payable(msg.sender);

        U1155(items[_tokenId].nftAddress).safeTransferFrom(address(this), msg.sender, )
    }
}
