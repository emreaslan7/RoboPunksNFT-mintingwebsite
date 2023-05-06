// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract RoboPunksNFT is ERC721, Ownable {
    uint256 public mintPrice;
    uint256 public totalSupply;
    uint256 public maxSupply;
    uint8 public maxPerWallet;
    bool public isPublicMintEnabled;
    string internal baseTokenUri;
    address payable public withdrawWallet;
    mapping (address => uint8) public walletMints;

    constructor() payable ERC721('RoboPunksNFT', 'RB'){
        mintPrice = 0.02 ether;
        totalSupply = 0;
        maxSupply = 1000;
        maxPerWallet = 3;
        withdrawWallet = '0x467D460F57D31716eeDed25c5e2f121720108aF8';
    }

    function setIsPublicMintEnabled(bool isPublicMintEnabled_) external onlyOwner{
        isPublicMintEnabled = isPublicMintEnabled_;
    }

    function setBaseTokenUri(string calldata baseTokenUri_) external onlyOwner{
        baseTokenUri = baseTokenUri_;
    }
    
    function tokenURI(uint256 tokenId_) public view override returns(string memory){
        require(_exists(tokenId_),  "Token ID is not available");
        return string(abi.encodePacked(baseTokenUri, Strings.toString(tokenId_),".json"));
    }

    function withdraw() external onlyOwner {
        (bool success, ) = withdrawWallet.call{value : address(this).balance}('');
        require(success, "withdraw is failed")
    }

    function mint(uint256 quantity_) public payable {
        require(isPublicMintEnabled, "Minting is not enabled");
        require(msg.value == quantity_ * mintPrice, "Not enough money to mint");
        require(totalSupply + quantity_ <= maxSupply, "Sold out");
        require(walletMints[msg.sender] + quantity_ <= maxPerWallet, "you can't mint more than 3");


        for(uint256 i = 0; i < quantity_; i++) {
            uint256 newTokenId = totalSupply + 1;
            totalSupply++;
            _safeMint(msg.sender, newTokenId);
        }
    }
}
