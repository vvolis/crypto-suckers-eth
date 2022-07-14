//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.10;

import "hardhat/console.sol";
import "./PublicMint.sol";


import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./Trophies.sol";

/*

   _____                  _           _____            _                 
  / ____|                | |         / ____|          | |                
 | |     _ __ _   _ _ __ | |_ ___   | (___  _   _  ___| | _____ _ __ ___ 
 | |    | '__| | | | '_ \| __/ _ \   \___ \| | | |/ __| |/ / _ \ '__/ __|
 | |____| |  | |_| | |_) | || (_) |  ____) | |_| | (__|   <  __/ |  \__ \
  \_____|_|   \__, | .__/ \__\___/  |_____/ \__,_|\___|_|\_\___|_|  |___/
               __/ | |                                                   
              |___/|_|        

*/

interface IMetadataHandler {
    function getTokenURI(uint16 id, uint16 back, uint16 body, uint16 head, uint16 mouth, uint16 eyes, uint16 hat, uint16 bloodModifier) external view returns (string memory);
}


contract CryptoSucker is PublicMint {


    mapping (uint256 => Vampire) public vampires;
    IMetadataHandler private metadaHandler;
    bytes32 internal entropySauce;
    Trophies internal trophies;
    struct Vampire { uint16 back; uint16 body; uint16 head; uint16 mouth; uint16 eyes; uint16 hat; uint16 bloodModifier; }

    /*///////////////////////////////////////////////////////////////
                    INITIALIZATION
    //////////////////////////////////////////////////////////////*/

    function initialize(string memory _name, string memory _symbol) public initializer 
    {
        __PublicMintable_init(_name, _symbol);
    }

    function setTrophies(address trophyContract) public onlyOwner 
    {
        trophies = Trophies(trophyContract);
    }

    



    /*///////////////////////////////////////////////////////////////
                    PUBLIC FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function mint(uint256 _mintAmount) public payable 
    {
        require(canMint(_mintAmount, msg.value), "Can't mint");
        
        uint256 rand = _rand();
        for (uint256 i = 1; i <= _mintAmount; i++) {
            addressMintedBalance[msg.sender]++;
            _mintVampire(rand);
        }
    }

    function mintWhitelist(uint256 _mintAmount) public payable 
    {
        require(canMint(_mintAmount, msg.value), "Can't mint");
        



        uint256 rand = _rand();
        for (uint256 i = 1; i <= _mintAmount; i++) {
            addressMintedBalance[msg.sender]++;
            trophies.burn(msg.sender, 0, 1);

            _mintVampire(rand);
        }

    } 




    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) 
    {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        Vampire memory vamp = vampires[tokenId];
        return metadaHandler.getTokenURI(uint16(tokenId), vamp.back, vamp.body, vamp.head, vamp.mouth, vamp.eyes, vamp.hat, vamp.bloodModifier);
    }

    /*///////////////////////////////////////////////////////////////
                    MINT FUNCTION
    //////////////////////////////////////////////////////////////*/

    function _mintVampire(uint256 rand) internal returns (uint256 id) {
        (uint16 back, uint16 body, uint16 head, uint16 mouth , uint16 eyes , uint16 hat) = (0,0,0,0,0,0);

        {
            // Helpers to get Percentages
            uint256 sevenOnePct   = type(uint16).max / 100 * 71;

    
            id = totalSupply() + 1;

            //Make a random number:
            uint16 randomNum = uint16(_randomize(rand, "BODY", id));
            //Scale it down to item amount:
            uint16 maxNum = 250;
            randomNum = randomNum / ( type(uint16).max / maxNum );








    
            // Getting Random traits
            /*
            //TODO::VV figure out randomisation
            uint16 randBody = uint16(_randomize(rand, "BODY", id));
                   body     = uint8(randBody > nineNinePct ? randBody % 3 + 25 : 
                              randBody > sevenOnePct  ? randBody % 12 + 13 : randBody % 13 + 1 );
    
            uint16 randHelm = uint16(_randomize(rand, "HELM", id));
                   helm     = uint8(randHelm < eightyPct ? 0 : randHelm % 4 + 5);
    
            uint16 randOffhand = uint16(_randomize(rand, "OFFHAND", id));
                   offhand     = uint8(randOffhand < eightyPct ? 0 : randOffhand % 4 + 5);
    
            uint16 randMainhand = uint16(_randomize(rand, "MAINHAND", id));
                   mainhand     = uint8(randMainhand < nineFivePct ? randMainhand % 4 + 1: randMainhand % 4 + 5);
            */
        }

        _safeMint(msg.sender, id);

        uint16 bloodModifier = _tier(back) + _tier(body) + _tier(head) + _tier(mouth) + _tier(eyes) + _tier(hat);
        vampires[uint256(id)] = Vampire({back: back, body: body, head: head, mouth: mouth, eyes: eyes, hat: hat, bloodModifier:bloodModifier});
    }




    /*///////////////////////////////////////////////////////////////
                    UTILS 
    //////////////////////////////////////////////////////////////*/

    function _rand() internal view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(msg.sender, block.timestamp, block.basefee, block.timestamp, entropySauce)));
    }

    /// @dev Create a bit more of randomness
    function _randomize(uint256 rand, string memory val, uint256 spicy) internal pure returns (uint256) {
        return uint256(keccak256(abi.encode(rand, val, spicy)));
    }

    /// @dev Convert an id to its tier
    function _tier(uint16 id) internal pure returns (uint16) {
        return 1; //1
    }

    
    /*///////////////////////////////////////////////////////////////
                    MODIFIERS 
    //////////////////////////////////////////////////////////////*/

    //TODO::VV check if this is needed at all
    modifier noCheaters() {
        uint256 size = 0;
        address acc = msg.sender;
        assembly { size := extcodesize(acc)}

        //require(auth[msg.sender] || (msg.sender == tx.origin && size == 0), "you're trying to cheat!");
        require((msg.sender == tx.origin && size == 0), "you're trying to cheat!");
        _;

        // We'll use the last caller hash to add entropy to next caller
        entropySauce = keccak256(abi.encodePacked(acc, block.coinbase));
    }

}
