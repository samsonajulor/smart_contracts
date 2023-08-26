// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StringBytesConversion {
    function stringToBytes(string memory _text) public pure returns (bytes memory) {
        bytes memory b = bytes(_text);
        return b;
    }
    
    function bytesToString(bytes memory _bytes) public pure returns (string memory) {
        string memory s = string(_bytes);
        return s;
    }
    
    function getStringLength(string memory _text) public pure returns (uint) {
        return bytes(_text).length;
    }
    
    function getBytesLength(bytes memory _bytes) public pure returns (uint) {
        return _bytes.length;
    }
}
