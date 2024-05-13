// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNFT is ERC721 {
    uint256 private s_tokenCounter;
    string private s_happySVGImageURI;
    string private s_sadSVGImageURI;

    enum Mood {
        Happy,
        Sad
    }

    mapping(uint256 => Mood) private s_tokenIdToMood;

    error MoodNFT__CantFlipMoodIfNotOwner();

    constructor(string memory happySVGImageURI, string memory sadSVGImageURI) ERC721("Mood NFT", "MN") {
        s_tokenCounter = 0;
        s_happySVGImageURI = happySVGImageURI;
        s_sadSVGImageURI = sadSVGImageURI;
    }

    function mintNFT() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.Happy;
        s_tokenCounter++;
    }

    function flipMood(uint256 tokenId) public {
        if (!_isAuthorized(_ownerOf(tokenId), msg.sender, tokenId)) {
            revert MoodNFT__CantFlipMoodIfNotOwner();
        }
        s_tokenIdToMood[tokenId] = s_tokenIdToMood[tokenId] == Mood.Happy ? Mood.Sad : Mood.Happy;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        string memory imageURI;

        if (s_tokenIdToMood[_tokenId] == Mood.Happy) {
            imageURI = s_happySVGImageURI;
        } else {
            imageURI = s_sadSVGImageURI;
        }

        bytes memory tokenMetadata = abi.encodePacked(
            '{"name": "',
            name(),
            '", "description": "An NFT that reflects the owner\'s mood", "attributes": [{"trait_type": "moodiness", "value": 100}], "image": "',
            imageURI,
            '"}'
        );

        return string(abi.encodePacked(_baseURI(), Base64.encode(tokenMetadata)));
    }
}
