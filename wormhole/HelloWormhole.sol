// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";
import "wormhole-solidity-sdk/interfaces/IWormholeRelayer.sol";
import "wormhole-solidity-sdk/interfaces/IWormholeReceiver.sol";

contract HelloWormhole is IWormholeReceiver {
    address public owner;
    IWormholeRelayer public wormholeRelayer;

    event MessageSent(uint16 targetChain, string message);
    event MessageReceived(uint16 sourceChain, string message);

    constructor(address _wormholeRelayer) {
        owner = msg.sender;
        wormholeRelayer = IWormholeRelayer(_wormholeRelayer);
    }

    // Sends message to another chain (gasless for sender via relayer)
    function sendCrossChainMessage(
        uint16 targetChain,
        address targetContract,
        string calldata message
    ) external payable {
        require(msg.sender == owner, "Only owner can send");

        bytes memory payload = abi.encode(message);

        wormholeRelayer.sendPayloadToEvm{value: msg.value}(
            targetChain,
            targetContract,
            payload,
            0, // receiver value (ETH to deliver)
            200000 // gas limit for receiving function
        );

        emit MessageSent(targetChain, message);
    }

    // Called automatically by the Wormhole relayer on the destination chain
    function receiveWormholeMessages(
        bytes memory payload,
        bytes[] memory, // additional VAAs (unused)
        bytes32,        // sourceAddress (unused)
        uint16 sourceChain,
        bytes32         // deliveryHash (unused)
    ) public payable override {
        require(msg.sender == address(wormholeRelayer), "Unauthorized caller");

        string memory receivedMessage = abi.decode(payload, (string));
        emit MessageReceived(sourceChain, receivedMessage);
    }
}

