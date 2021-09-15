// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "./OrbitauERC721.sol";
import "../../lib/token/ERC721/extensions/ERC721Enumerable.sol";

contract OrbitauERC721Enumerable is OrbitauERC721, ERC721Enumerable {
    /**
     * @dev Create a new OrbitauERC721Enumerable contract.
     *
     */
    constructor() OrbitauERC721() {}

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
        return
        interfaceId == type(IERC721).interfaceId ||
        interfaceId == type(IERC721Metadata).interfaceId ||
        ERC721Enumerable.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view override(ERC721, OrbitauERC721) returns (string memory) {
        return OrbitauERC721.tokenURI(tokenId);
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`.
     */
    function _baseURI() internal view override(ERC721, OrbitauERC721) returns (string memory) {
        return OrbitauERC721._baseURI();
    }

    /**
     * @dev Hook that is called before any token transfer. This includes minting
     * and burning.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
     * transferred to `to`.
     * - When `from` is zero, `tokenId` will be minted for `to`.
     * - When `to` is zero, ``from``'s `tokenId` will be burned.
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(OrbitauERC721, ERC721Enumerable) {
        OrbitauERC721._beforeTokenTransfer(from, to, tokenId);
        ERC721Enumerable._beforeTokenTransfer(from, to, tokenId);
    }
}
