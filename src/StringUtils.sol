// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

library StringUtils {
    function compareStrings(string memory _a, string memory _b) internal pure returns (bool) {
        return keccak256(abi.encodePacked(_a)) == keccak256(abi.encodePacked(_b));
    }
}
