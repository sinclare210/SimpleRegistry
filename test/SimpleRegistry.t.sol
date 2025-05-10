// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {SimpleRegistry} from "../src/SimpleResgistry.sol";

import "forge-std/Test.sol";

contract SimpleRegistryTest is Test {
    SimpleRegistry public simpleRegistry;

    event NameAdded(address indexed user, string name);

    event NameReleased(address indexed user, string name);

    function setUp() external {
        simpleRegistry = new SimpleRegistry();
    }

    function testIfAddNameRevertOnAddingTheSameName() public {
        simpleRegistry.addName("Sinclair");
        vm.expectRevert(SimpleRegistry.NameInUse.selector);
        simpleRegistry.addName("Sinclair");
    }

    function testIfAddNameAdded() public {
        simpleRegistry.addName("Sinclair");

        simpleRegistry.addName("sinclair");
        bytes32 name = simpleRegistry._stringToBytes32("sinclair");

        assertEq(simpleRegistry.getAllName(1), name);
        assertEq(simpleRegistry.getAllName(1), name);
    }

    function testIfTheUserNameIsCorrect() public {
        address sinc = address(0x1);

        vm.prank(sinc);
        simpleRegistry.addName("Sinclair");
        vm.prank(sinc);
        simpleRegistry.addName("sinclair");

        bytes32 name = simpleRegistry._stringToBytes32("Sinclair");
        bytes32 name1 = simpleRegistry._stringToBytes32("sinclair");

        assertEq(simpleRegistry.getUserNameAt(sinc, 0), name);
        assertEq(simpleRegistry.getUserNameAt(sinc, 1), name1);
    }

    function testIfNameToOwnerWork() public {
        address sinc = address(0x1);

        vm.prank(sinc);
        simpleRegistry.addName("Sinclair");
        vm.prank(sinc);
        simpleRegistry.addName("sinclair");

        bytes32 name = simpleRegistry._stringToBytes32("Sinclair");

        assertEq(simpleRegistry.nameToOwner(name), sinc);
        assertEq(simpleRegistry.getOwnerOfName("sinclair"), sinc);
    }

    // function testGetTheNumberOfNameInTheRegistry () public {

    // }

    function testAddNameEmitsEvent() public {
        address sinc = address(0x1);
        string memory name = "sinclair";

        vm.expectEmit(true, false, false, true);
        emit NameAdded(sinc, name);

        vm.prank(sinc);
        simpleRegistry.addName(name);
    }

    function testReleaseNameEmitSuccessful() public {
        address sinc = address(0x1);
        string memory name = "sinclair";

        vm.prank(sinc);
        simpleRegistry.addName(name);

        vm.expectEmit(true, false, false, true);
        emit NameReleased(sinc, name);

        vm.prank(sinc);
        simpleRegistry.releaseName(name);
    }

    function testReleaseNameRevertnUsingNameYouDontHave() public {
        address sinc = address(0x1);
        string memory name = "sinclair";

        vm.prank(sinc);
        simpleRegistry.addName(name);

        vm.prank(sinc);
        vm.expectRevert(SimpleRegistry.NameNotPresent.selector);
        simpleRegistry.releaseName("Sinclair");
    }

    function testGetOwnerOfName() public {
        address sinc = address(0x1);
        string memory name = "sinclair";
        string memory name1 = "sinc";

        bytes32 nameConv = simpleRegistry._stringToBytes32("sinclair");

        vm.prank(sinc);
        simpleRegistry.addName(name);

        //revert if the user does not have the name
        vm.prank(sinc);
        vm.expectRevert(SimpleRegistry.NameNotPresent.selector);
        simpleRegistry.getOwnerOfName(name1);

        assertEq(simpleRegistry.nameToOwner(nameConv), sinc);
    }

    function testIfStringToBytesRevrtOnMoreThan32() public {
        string memory name =
            "sinclairrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr";

        vm.expectRevert(SimpleRegistry.NameTooLong.selector);
        simpleRegistry._stringToBytes32(name);
    }

    function testGetTheNumberOfNameInTheRegistry() public {
        address sinc = address(0x1);
        address sincs = address(0x2);

        vm.prank(sinc);
        simpleRegistry.addName("Samuel");

        vm.prank(sincs);
        simpleRegistry.addName("Neymar");

        assertEq(simpleRegistry.getTheNumberOfNameInTheRegistry(), 2);
    }

    function testReusingReleasedName() public {
        address sinc = address(0x1);
        string memory name = "sinclair";

        vm.prank(sinc);
        simpleRegistry.addName(name);

        vm.prank(sinc);
        simpleRegistry.releaseName(name);

        // Re-adding after release should succeed
        vm.prank(sinc);
        simpleRegistry.addName(name);

        assertEq(simpleRegistry.getTheNumberOfNameInTheRegistry(), 1);
    }

    function testStringToBytes32ExactLength() public {
        string memory name = "abcdefghijklmnopqrstuvwxyzabcde"; // 31 characters
        bytes32 b32 = simpleRegistry._stringToBytes32(name);
        string memory converted = simpleRegistry._bytes32ToString(b32);
        assertEq(converted, name);
    }

    function testReleaseNameCleansUp() public {
        address sinc = address(0x1);
        string memory name = "sinclair";
        bytes32 nameBytes = simpleRegistry._stringToBytes32(name);

        vm.prank(sinc);
        simpleRegistry.addName(name);

        vm.prank(sinc);
        simpleRegistry.releaseName(name);

        // All should be cleaned
        assertEq(simpleRegistry.getTheNumberOfNameInTheRegistry(), 0);
        assertEq(simpleRegistry.nameToOwner(nameBytes), address(0));
    }

    function testBytes32ToStringWorks() public {
        string memory name = "sinclair";
        bytes32 b32 = simpleRegistry._stringToBytes32(name);
        string memory convertedBack = simpleRegistry._bytes32ToString(b32);

        assertEq(convertedBack, name);
    }

    function testGetUserNames() public {
        address sinc = address(0x1);

        vm.prank(sinc);
        simpleRegistry.addName("Sinclair");

        vm.prank(sinc);
        simpleRegistry.addName("Neymar");

        vm.prank(sinc);
        string[] memory names = simpleRegistry.getUserNames(sinc);

        assertEq(names.length, 2);
        assertEq(names[0], "Sinclair");
        assertEq(names[1], "Neymar");
    }
}
