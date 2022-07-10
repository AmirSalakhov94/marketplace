// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.15;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract U1155 is ERC1155 {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(uint256 => string) internal idToUri;

    constructor(address _owner, string memory _uri, uint256 _amount) ERC1155("") {
        _tokenIds = 0;
        mint(msg.sender, _tokenIds.current(), _amount, _uri);
    }

    function mint(address _to, uint256 _amount, string memory _uri) public view virtual returns  {
        _tokenIds.increment();
        _mint(_to, _tokenIds.current(), _amount, "");
        idToUri[_id] = _uri;
    }

    function uri(uint256 _id) public view virtual override returns (string memory) {
        return idToUri[_id];
    }
}

