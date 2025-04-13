// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/HelloWormhole.sol";

contract HelloWormholeTest is Test {
    HelloWormhole public hello;
    address mockRelayer = address(0xBEEF);

    function setUp() public {
        hello = new HelloWormhole(mockRelayer);
    }

    function testReceiveWormholeMessage() public {
        string memory testMessage = "Hello from Wormhole!";
        bytes memory payload = abi.encode(testMessage);
        bytes[] memory additionalMessages;
        bytes32 sourceAddress = bytes32(uint256(uint160(address(0x1234))));
        uint16 sourceChain = 2;
        bytes32 deliveryHash = keccak256("mock hash");

        vm.expectEmit(true, true, false, true);
        emit MessageReceived(testMessage, address(0x1234));

        vm.prank(mockRelayer);
        hello.receiveWormholeMessages(
            payload,
            additionalMessages,
            sourceAddress,
            sourceChain,
            deliveryHash
        );
    }

    event MessageReceived(string message, address sender);
}

