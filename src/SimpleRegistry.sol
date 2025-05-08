// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract  SimpleRegistry {
    mapping (address => string[]) private user;
    string[] names;

    function addName (string memory _name) public {
        string[] memory name = user[msg.sender];
        for (uint i = 0; i < name.length; i++) {
           if (keccak256(bytes(name[i])) == keccak256(bytes(_name))){
                revert("Name already Exist");
           }

           
        }
        user[msg.sender].push(_name);
        
        }

    function removeName () public {}

    function getAllNames () public {}


    
}