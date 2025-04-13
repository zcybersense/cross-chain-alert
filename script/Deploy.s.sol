// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/HelloWormhole.sol";

contract Deploy is Script {
    function setUp() public {}

    function run() public {
        // Relayer address (example: Ethereum Sepolia)
        address wormholeRelayer =0x20F230c7D7dB50D48F81C92665f68f2C79B4fDE0;

        // Start broadcast to deploy
        vm.startBroadcast();
        new HelloWormhole(wormholeRelayer);
        vm.stopBroadcast();
    }
}
