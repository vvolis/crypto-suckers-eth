// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/* Signature Verification

How to Sign and Verify
# Signing
1. Create message to sign
2. Hash the message
3. Sign the hash (off chain, keep your private key secret)

# Verify
1. Recreate hash from the original message
2. Recover signer from signature and hash
3. Compare recovered signer to claimed signer
*/

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

  
contract Crypto {
    using ECDSA for bytes32; 

    function verifyMessage(string memory message, bytes memory signature) public pure returns(address, bool) {
        //hash the plain text message
        bytes32 messagehash =  keccak256(bytes(message));
       
        address signeraddress = messagehash.toEthSignedMessageHash().recover(signature);
              
        if (address(0x2dE6c0dEa73D00759a5100353964E12a3893100E) == signeraddress) {
            //The message is authentic
            return (signeraddress, true);
        } else {
            //msg.sender didnt sign this message.
            return (signeraddress, false);
        }
    }
}