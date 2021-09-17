// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.4;

import "./OrbitauERC721Enumerable.sol";
import "../../lib/utils/cryptography/draft-EIP712.sol";

contract OrbitauERC721LazyMint is OrbitauERC721Enumerable, EIP712 {    
    mapping(address => bool) public signers;

    string private constant SIGNING_DOMAIN = "OrbitauNFT";
    string private constant SIGNATURE_VERSION = "1";

    /**
     * @dev Create a new OrbitauNFTLazyMint contract and and assign `DEFAULT_ADMIN_ROLE, MINTER_ROLE` for the creator.
     * This construction function should be called from an exchange.
     *
     */
    constructor() OrbitauERC721Enumerable() EIP712(SIGNING_DOMAIN, SIGNATURE_VERSION)
    {}

    function addSigner(address _signer) external onlyOwner {
        require(_signer != address(0), "ERR_SIGNER_IS_ZERO_ADDRESS");
        signers[_signer] = true;
    }

    function removeSigner(address _signer) external onlyOwner {
        require(_signer != address(0), "ERR_SIGNER_IS_ZERO_ADDRESS");
        signers[_signer] = false;
    }

    function equip(uint256 tokenId, bytes calldata signature)
    external
    {
        address _signer = _verify(_hash(msg.sender, tokenId), signature);
        
        require(signers[_signer], "ERR_INVALID_SIGNATURE");

        equip(tokenId);
    }

    function redeem(uint256 tokenId, bytes calldata signature)
    external
    {
        address _signer = _verify(_hash(msg.sender, tokenId), signature);
        
        require(signers[_signer], "ERR_INVALID_SIGNATURE");

        redeem(msg.sender, tokenId);
    }

    /// @notice Returns a hash of the given PendingNFT, prepared using EIP712 typed data hashing rules.
    function _hash(address redeemer, uint256 tokenId)
    internal view returns (bytes32)
    {
        return _hashTypedDataV4(keccak256(abi.encode(
                keccak256("OrbitauNFT(address redeemer, uint256 tokenId)"),
                redeemer,
                tokenId
            )));
    }

    /**
     * @dev Returns the signer for a pair of digested message and signature.
     */
    function _verify(bytes32 digest, bytes memory signature)
    internal pure returns (address)
    {
        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, digest));
        return ECDSA.recover(prefixedHash, signature);
    }
}
