// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.15;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "hardhat/console.sol";

contract NFT721 is ERC721 {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    mapping(uint256 => string) internal _idToUri;

    constructor() ERC721("NFT721", "NFTT") {
        _tokenIdCounter._value = 0;
    }

    function mint(address to, string memory uri) public {
        uint256 tokenId = _tokenIdCounter.current();
        _safeMint(to, tokenId);
        _idToUri[tokenId] = uri;
        _tokenIdCounter.increment();
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        return _idToUri[tokenId];
    }
}

