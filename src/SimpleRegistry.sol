// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {StringUtils} from "./StringUtils.sol";

contract SimpleRegistry {
    error Unauthorized();

    using StringUtils for string;

    mapping(address => string[]) private user;

    string[] names;

    function addName(string memory _name) public {
        if (msg.sender == address(0)) {
            revert Unauthorized();
        }

        string[] storage name = user[msg.sender];

        for (uint256 i = 0; i < name.length; i++) {
            if ((name[i]).compareStrings(_name) == true) {
                revert("Name already Exist");
            }
        }
        user[msg.sender].push(_name);
        names.push(_name);
    }

    function removeName(string memory _name) public {
        if (msg.sender == address(0)) {
            revert Unauthorized();
        }

        // Remove from user's list
        string[] storage nameList = user[msg.sender];
        bool userRemoved = false;

        for (uint256 i = 0; i < nameList.length; i++) {
            if (StringUtils.compareStrings(nameList[i], _name)) {
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
            if (StringUtils.compareStrings(names[i], _name)) {
                names[i] = names[names.length - 1];
                names.pop();
                break;
            }
        }
    }

    function getAllNames() public view returns (string[] memory name) {
        if (msg.sender == address(0)) {
            revert Unauthorized();
        }
        return name;
    }
}
