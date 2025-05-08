// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {StringUtils} from "./StringUtils.sol";

contract SimpleRegistry {
    error Unauthorized();

    using StringUtils for string; 

    mapping(address => string[]) private user;
    string[] names;

    // Events
    event NameAdded(address indexed user, string name);
    event NameRemoved(address indexed user, string name);

    function addName(string memory _name) public {
        if (msg.sender == address(0)) {
            revert Unauthorized();
        }

        string[] storage name = user[msg.sender];

        for (uint256 i = 0; i < name.length; i++) {
            if ((name[i]).compareStrings(_name)) {
                revert("Name already Exist");
            }
        }
        user[msg.sender].push(_name);
        names.push(_name);

        // Emit NameAdded event
        emit NameAdded(msg.sender, _name);
    }

    function removeName(string memory _name) public {
        if (msg.sender == address(0)) {
            revert Unauthorized();
        }

        // Remove from user's list
        string[] storage nameList = user[msg.sender];
        bool userRemoved = false;

        for (uint256 i = 0; i < nameList.length; i++) {
            if (nameList[i].compareStrings(_name)) {
                nameList[i] = nameList[nameList.length - 1];
                nameList.pop();
                userRemoved = true;
                break;
            }
        }

        if (!userRemoved) {
            revert("Name not found in user's list");
        }

        // Remove from global list
        for (uint256 i = 0; i < names.length; i++) {
            if (names[i].compareStrings(_name)) { 
                names[i] = names[names.length - 1];
                names.pop();
                break;
            }
        }

        // Emit NameRemoved event
        emit NameRemoved(msg.sender, _name);
    }

    function getAllNames() public view returns (string[] memory) {
        if (msg.sender == address(0)) {
            revert Unauthorized();
        }
        return user[msg.sender];
    }
}
