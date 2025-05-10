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
}
