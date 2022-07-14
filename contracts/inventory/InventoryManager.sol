// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.10;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract InventoryManager is OwnableUpgradeable {

    enum Part { back, body, head, mouth, eye, hat }

    mapping(uint16 => address) public backs;
    mapping(uint16 => address) public bodies;
    mapping(uint16 => address) public heads;
    mapping(uint16 => address) public mouths;
    mapping(uint16 => address) public eyes;
    mapping(uint16 => address) public hats;


    function initialize() public initializer {
        __Ownable_init();
    }

    function getTokenURI(uint16 id, uint16 back, uint16 body, uint16 head, uint16 mouth, uint16 eye, uint16 hat, uint16 bloodModifier) public view returns (string memory) {

        return
            string(
                abi.encodePacked(
                    'data:application/json;base64,',
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"Crypto Sucker #',toString(id),'", "description":"Hide your kids. Hide your blood.", "image": "',
                                getAttributes(back, body, head, mouth, eye, hat, bloodModifier),
                                '}'
                            )
                        )
                    )
                )
            );
    }
    
    /*///////////////////////////////////////////////////////////////
                    INVENTORY MANAGEMENT
    //////////////////////////////////////////////////////////////*/

    function setBacks(uint8[] calldata ids, address source) external onlyOwner {
        for (uint256 index = 0; index < ids.length; index++) {
            backs[ids[index]] = source; 
        }
    }

    function setBodies(uint8[] calldata ids, address source) external onlyOwner {
        for (uint256 index = 0; index < ids.length; index++) {
            bodies[ids[index]] = source; 
        }
    }

    function setHeads(uint8[] calldata ids, address source) external onlyOwner {
        for (uint256 index = 0; index < ids.length; index++) {
            heads[ids[index]] = source; 
        }
    }
     
    function setMouths(uint8[] calldata ids, address source) external onlyOwner {
        for (uint256 index = 0; index < ids.length; index++) {
            mouths[ids[index]] = source; 
        }
    }

    function setEyes(uint8[] calldata ids, address source) external onlyOwner {
        for (uint256 index = 0; index < ids.length; index++) {
            eyes[ids[index]] = source; 
        }
    }

    function setHats(uint8[] calldata ids, address source) external onlyOwner {
        for (uint256 index = 0; index < ids.length; index++) {
            hats[ids[index]] = source; 
        }
    }

    /*///////////////////////////////////////////////////////////////
                    INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function call(address source, bytes memory sig) internal view returns (string memory svg) {
        (bool succ, bytes memory ret)  = source.staticcall(sig);
        require(succ, "failed to get data");
        svg = abi.decode(ret, (string));
    }

    function get(Part part, uint16 id) internal view returns (string memory data_) {
        address source = 
            part == Part.back     ? backs[id] :
            part == Part.body     ? bodies[id] :
            part == Part.head     ? heads[id] :
            part == Part.mouth    ? mouths[id] :
            part == Part.eye      ? eyes[id] : hats[id];

        data_ = wrapTag(call(source, getData(part, id)));
    }
    
    function wrapTag(string memory uri) internal pure returns (string memory) {
        return string(abi.encodePacked('<image x="1" y="1" width="500" height="500" image-rendering="pixelated" preserveAspectRatio="xMidYMid" xlink:href="data:image/png;base64,', uri, '"/>'));
    }

    function getData(Part part, uint16 id) internal pure returns (bytes memory data) {
        string memory s = string(abi.encodePacked(
            part == Part.back     ? "back" :
            part == Part.body     ? "body" :
            part == Part.head     ? "head" :
            part == Part.mouth    ? "mouth" :
            part == Part.eye      ? "eye" : "hats",
            toString(id),
            "()"
        ));

        return abi.encodeWithSignature(s, "");
    }

    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    function toString(Part part) internal pure returns (string memory) {
        string memory s = string(abi.encodePacked(
            part == Part.back     ? "Back" :
            part == Part.body     ? "Body" :
            part == Part.head     ? "Head" :
            part == Part.mouth    ? "Mouth" :
            part == Part.eye      ? "Eye" : "Hats"
        ));

        return s;
    }

    function getAttributes(uint16 back, uint16 body, uint16 head, uint16 mouth, uint16 eye, uint16 hat, uint16 bloodModifier) internal pure returns (string memory) {
       return string(abi.encodePacked(
           '"attributes": [',
            getPartAttributes(Part.back, back),         ',',
            getPartAttributes(Part.body, body),         ',',
            getPartAttributes(Part.head, head),         ',',
            getPartAttributes(Part.mouth, mouth),         ',',
            getPartAttributes(Part.eye, eye),         ',',
            getPartAttributes(Part.hat, hat),         ',',
            '},{"display_type": "boost_number","trait_type": "zug bonus", "value":', 
            toString(bloodModifier),'}]'));
    }

    function getPartAttributes(Part part, uint16 id) internal pure returns(string memory) {
        return string(abi.encodePacked('{"trait_type":"', toString(part) , '","value":"', getName(part, id),'"}'));
    }

    function getTier(uint16 id) internal pure returns (uint16) {
        if (id > 40) return 100;
        if (id == 0) return 0;
        return ((id - 1) / 4 );
    }

    function getName(Part part, uint16 id) public pure returns (string memory) 
    {
        if (part == Part.eye) {
             if (id < 20) {
                return "Mazais";
            } else {
                return "Lielais";
            }
        } else {
            return "NavAcs";
        }
    }
}

/// @title Base64
/// @author Brecht Devos - <brecht@loopring.org>
/// @notice Provides a function for encoding some bytes in base64
/// @notice NOT BUILT BY ETHERORCS TEAM. Thanks Bretch Devos!
library Base64 {
    string internal constant TABLE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

    function encode(bytes memory data) internal pure returns (string memory) {
        if (data.length == 0) return '';
        
        // load the table into memory
        string memory table = TABLE;

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((data.length + 2) / 3);

        // add some extra buffer at the end required for the writing
        string memory result = new string(encodedLen + 32);

        assembly {
            // set the actual output length
            mstore(result, encodedLen)
            
            // prepare the lookup table
            let tablePtr := add(table, 1)
            
            // input ptr
            let dataPtr := data
            let endPtr := add(dataPtr, mload(data))
            
            // result ptr, jump over length
            let resultPtr := add(result, 32)
            
            // run over the input, 3 bytes at a time
            for {} lt(dataPtr, endPtr) {}
            {
               dataPtr := add(dataPtr, 3)
               
               // read 3 bytes
               let input := mload(dataPtr)
               
               // write 4 characters
               mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(18, input), 0x3F)))))
               resultPtr := add(resultPtr, 1)
               mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(12, input), 0x3F)))))
               resultPtr := add(resultPtr, 1)
               mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr( 6, input), 0x3F)))))
               resultPtr := add(resultPtr, 1)
               mstore(resultPtr, shl(248, mload(add(tablePtr, and(        input,  0x3F)))))
               resultPtr := add(resultPtr, 1)
            }
            
            // padding with '='
            switch mod(mload(data), 3)
            case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
            case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
        }
        
        return result;
    }
}