// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {SimpleRegistry} from "../src/SimpleResgistry.sol";

contract SimpleRegisterScript is Script {
    SimpleRegistry public simpleRegistry;

    function run() external {
        vm.startBroadcast();

        simpleRegistry = new SimpleRegistry();

        vm.stopBroadcast();
    }
}
