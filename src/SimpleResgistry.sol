// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";

contract SimpleRegistry {
    error Unauthorized();

    error NameTooLong();

    error NameNotPresent();

    error NameInUse();

    using EnumerableSet for EnumerableSet.Bytes32Set;

    EnumerableSet.Bytes32Set private allNames;

    mapping(address => EnumerableSet.Bytes32Set) private userName;

    mapping(bytes32 => address) public nameToOwner;

    event NameAdded(address indexed user, string name);

    event NameReleased(address indexed user, string name);

    function _stringToBytes32(string memory _name) public pure returns (bytes32 result) {
        bytes memory name = bytes(_name);

        if (name.length >= 32) revert NameTooLong();

        assembly {
            result := mload(add(_name, 32))
        }
    }

    function _bytes32ToString(bytes32 b32) public pure returns (string memory) {
        uint8 i = 0;
        while (i < 32 && b32[i] != 0) {
            i++;
        }
        bytes memory bytesArray = new bytes(i);
        for (uint8 j = 0; j < i; j++) {
            bytesArray[j] = b32[j];
        }
        return string(bytesArray);
    }

    function addName(string calldata _name) public {
        bytes32 name = _stringToBytes32(_name);

        if (allNames.contains(name) == true) revert NameInUse();

        allNames.add(name);
        userName[msg.sender].add(name);
        nameToOwner[name] = msg.sender;

        emit NameAdded(msg.sender, _name);
    }

    function releaseName(string calldata _name) public {
        bytes32 name = _stringToBytes32(_name);

        if (allNames.contains(name) == false) revert NameNotPresent();

        allNames.remove(name);
        userName[msg.sender].remove(name);
        delete nameToOwner[name];

        emit NameReleased(msg.sender, _name);
    }

    function getTheNumberOfNameInTheRegistry() public view returns (uint256) {
        return allNames.length();
    }

    function getOwnerOfName(string calldata _name) public view returns (address) {
        bytes32 name = _stringToBytes32(_name);

        if (allNames.contains(name) == false) revert NameNotPresent();

        return nameToOwner[name];
    }

    function getUserNames(address user) external view returns (string[] memory) {
        uint256 len = userName[user].length();

        string[] memory result = new string[](len);

        for (uint256 i = 0; i < len; i++) {
            result[i] = _bytes32ToString(userName[user].at(i));
        }

        return result;
    }

    function getAllName(uint256 index) public view returns (bytes32) {
        return allNames.at(index);
    }

    function getUserNameAt(address user, uint256 index) external view returns (bytes32) {
        return userName[user].at(index);
    }
}
