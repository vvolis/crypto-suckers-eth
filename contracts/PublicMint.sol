//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.10;

import "hardhat/console.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";

contract PublicMint is Initializable, ERC721EnumerableUpgradeable, OwnableUpgradeable  {


    uint256 public cost;
    uint256 public maxSupply;
    uint256 public maxMintAmount;
    uint256 public nftPerAddressLimit;
    bool public paused;
    bool public revealed;
    bool public onlyWhitelisted;
    address[] public whitelistedAddresses;
    mapping(address => uint256) public addressMintedBalance;


    function __PublicMintable_init(
                        string memory _name,
                        string memory _symbol
    ) internal initializer {
        __ERC721_init(_name, _symbol);
        __Ownable_init();
        
        setCost(1 ether);
        maxSupply = 10000;
        setmaxMintAmount(20);
        setNftPerAddressLimit(3);
        pause(false);
        revealed = false;
        setOnlyWhitelisted(true);
    }

    function canMint(uint256 _mintAmount, uint256 ethValue) public view returns (bool) {
        require(!paused, "the contract is paused");
        uint256 supply = totalSupply();
        require(_mintAmount > 0, "need to mint at least 1 NFT");
        require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
        require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
        if (msg.sender != owner()) {
            if(onlyWhitelisted == true) {
                require(isWhitelisted(msg.sender), "user is not whitelisted");
                uint256 ownerMintedCount = addressMintedBalance[msg.sender];
                require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
            }
            require(ethValue >= cost * _mintAmount, "insufficient funds");
        }

        return true;
    }
    
    function isWhitelisted(address _user) public view returns (bool) {
        for (uint i = 0; i < whitelistedAddresses.length; i++) {
            if (whitelistedAddresses[i] == _user) {
                return true;
            }
        }
        return false;
    }

    function walletOfOwner(address _owner) public view returns (uint256[] memory)
    {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokenIds;
    }
    
    function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
        nftPerAddressLimit = _limit;
    }
    
    function setCost(uint256 _newCost) public onlyOwner {
        cost = _newCost;
    }

    function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
        maxMintAmount = _newmaxMintAmount;
    }

    function pause(bool _state) public onlyOwner {
        paused = _state;
    }
    
    function setOnlyWhitelisted(bool _state) public onlyOwner {
        onlyWhitelisted = _state;
    }
    
    function whitelistUsers(address[] calldata _users) public onlyOwner {
        delete whitelistedAddresses;
        whitelistedAddresses = _users;
    }
    
    function withdraw() public payable onlyOwner {
        (bool os, ) = payable(owner()).call{value: address(this).balance}("");
        require(os);
    }
}
