// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {SimpleRegistry} from "../src/SimpleResgistry.sol";

import "forge-std/Test.sol";

contract SimpleRegistryTest is Test{

    SimpleRegistry public simpleRegistry;

    function setUp () external {

        simpleRegistry = new SimpleRegistry();

    }

    function testIfAddNameRevertOnAddingTheSameName () public {

        simpleRegistry.addName("Sinclair");
        vm.expectRevert();
        simpleRegistry.addName("Sinclair");

    }

    

    
}