//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.10;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract Trophies is ERC1155Upgradeable, OwnableUpgradeable
{
    address public suckerContract;
    string public contractURI;


    function initialize() public initializer 
    {
        __ERC1155_init("https://gateway.pinata.cloud/ipfs/Qma1bk5JrUhKZfMtyR9ECuU3cSGuXmfwxmRVSow56N2DPZ/{id}.json");
        __Ownable_init();

        setContractURI("https://gateway.pinata.cloud/ipfs/Qma1bk5JrUhKZfMtyR9ECuU3cSGuXmfwxmRVSow56N2DPZ/contract.json");
    }

    function setSuckerContract(address _suckerContract) public onlyOwner
    {
        suckerContract = _suckerContract;
    }

    function sendTokens(uint256 tokenId, address[] memory addresses) public onlyOwner
    {
        for (uint256 i = 0; i < addresses.length; i++) {
             _mint(addresses[i], tokenId, 1, "");
        }
    }

    function burn(address from, uint256 id, uint256 amount) public
    {
         require(_msgSender() == suckerContract, "Burn: caller is not the main contract");
        _burn(from, id, amount);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155Upgradeable) returns (bool) 
    {
        return
            interfaceId == 0xe8a3d485 || //_INTERFACE_ID_CONTRACT_URI
            interfaceId == 0xb7799584 || //_INTERFACE_ID_FEES
            super.supportsInterface(interfaceId);
    }

    function setContractURI(string memory _contractURI) public onlyOwner 
    {
        contractURI = _contractURI;
    }

    function setURI(string memory _newuri) public onlyOwner 
    {
        _setURI(_newuri);
    }

    function getFeeRecipients(uint256) public view returns (address payable[] memory)
    {
        address payable[] memory result = new address payable[](1);
        result[0] = payable(owner());
        return result;
    }

    function getFeeBps(uint256) public pure returns (uint256[] memory)
    {
        uint256[] memory result = new uint256[](1);
        result[0] = 500; //100 = 1%
        return result;
    }

}

