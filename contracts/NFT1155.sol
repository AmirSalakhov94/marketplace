// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.15;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract NFT1155 is ERC1155 {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    mapping(uint256 => string) internal _idToUri;

    constructor() ERC1155("NFT1155") {
        _tokenIdCounter._value = 0;
    }

    function mint(address to, uint256 amount, string memory uriValue) public {
        uint256 tokenId = _tokenIdCounter.current();
        _mint(to, tokenId, amount, "");
        _idToUri[tokenId] = uriValue;
        _tokenIdCounter.increment();
    }

    function uri(uint256 tokenId) public view virtual override returns (string memory) {
        return _idToUri[tokenId];
    }
}

