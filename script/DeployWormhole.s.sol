// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../wormhole/HelloWormhole.sol";

contract DeployWormhole is Script {
    function setUp() public {}

    function run() public {
        // Replace with actual Wormhole relayer address (e.g., for Sepolia)
        address wormholeRelayer = 0x0020f230c7d7db50d48f81c92665f68f2c79b4fde0;

        vm.startBroadcast();
        new HelloWormhole(wormholeRelayer);
        vm.stopBroadcast();
    }
}
