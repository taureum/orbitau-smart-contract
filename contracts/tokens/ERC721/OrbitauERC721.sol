// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.4;

import "../../lib/token/ERC721/ERC721.sol";
import "../../lib/access/Ownable.sol";
import "../../lib/security/Pausable.sol";
import "../../lib/token/ERC721/extensions/ERC721Pausable.sol";
import "../../lib/utils/Strings.sol";
contract OrbitauERC721 is ERC721Pausable, Ownable {
    using Strings for uint256;
    
    mapping(uint256 => bool) private _idFreeze;

    /**
     * @dev The base URI for all NFT.
     */
    string private __baseURI;
    
    /**
     * @dev Emitted when a pending token is redeemed in the lazy-minting protocol.
     */
    event Redeem(address indexed owner, uint256 tokenId);
    event Equip(address indexed owner, uint256 tokenId); 
    
    function _transferable(uint256 tokenId) internal view virtual returns (bool) {
        return !_idFreeze[tokenId];
    }

    /**
     * @dev Create a new OrbitauERC721 contract.
     *
     */
    constructor() ERC721("Orbitau ERC721", "Orbitau") Ownable() Pausable() {
        __baseURI = "https://metadata.orbitau.io/";
    }

    /**
     * @dev Pause the contract in case of bugs/attacks.
     * @notice Only the owner can call this method.
     */
    function pause() public onlyOwner {
        _pause();
    }

    /**
     * @dev Resume the contract after being paused.
     * @notice Only the owner can call this method.
     */
    function unPause() public onlyOwner {
        _unpause();
    }

    function equip(uint256 tokenId) internal virtual {
        require(ownerOf(tokenId) == msg.sender, "OrbitauERC721: equip caller is not owner nor approved");
        require(!_idFreeze[tokenId], "OrbitauERC721: nft equipped");
        _idFreeze[tokenId] = true;
        emit Equip(msg.sender, tokenId);
    }
    
    function redeem(address redeemer, uint256 tokenId) internal virtual returns (uint256) {
        if(_exists(tokenId)){
            require(ownerOf(tokenId) == msg.sender, "OrbitauERC721: redeemer caller is not owner nor approved");
            require(_idFreeze[tokenId], "OrbitauERC721: nft redeemed");
            _idFreeze[tokenId] = false;
        }else{
            safeMint(redeemer, tokenId);
        }
        emit Redeem(redeemer, tokenId);
        return tokenId;
    }

    function safeMint(
        address to,
        uint256 tokenId)
    internal virtual
    returns (uint256)
    {
        _safeMint(to, tokenId);
        return tokenId;
    }

    function mint(address to, uint256 tokenId)
    internal virtual
    returns (uint256)
    {
        _mint(to, tokenId);
        return tokenId;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        //return string(abi.encodePacked(__baseURI, _idToType[tokenId], tokenId));
        return string(abi.encodePacked(__baseURI, tokenId.toString()));
    }
    
    /**
     * @dev Sets new value for the `__baseURI`. This operation can only been done by the owner of this contract.
     */
    function setBaseURI(string memory newBaseURI) external onlyOwner whenNotPaused {
        __baseURI = newBaseURI;
    }

    /**
     * @dev Returns `__baseURI`.
     */
    function baseURI() external view returns(string memory) {
        return __baseURI;
    }
    
    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`.
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return __baseURI;
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override (ERC721Pausable) {
        ERC721Pausable._beforeTokenTransfer(from, to, tokenId);
        require(_transferable(tokenId), "OrbitauERC721: token transfer while equipped");
    }
}
