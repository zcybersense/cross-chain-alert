// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IWormholeRelayer {
    function sendPayloadToEvm(
        uint16 targetChain,
        address targetAddress,
        bytes memory payload,
        uint256 receiverValue,
        uint256 gasLimit
    ) external payable returns (uint64 sequence);

    function quoteEVMDeliveryPrice(
        uint16 targetChain,
        uint256 receiverValue,
        uint256 gasLimit
    ) external view returns (
        uint256 nativePriceQuote,
        uint256 targetChainRefundPerGasUnused
    );
}

contract HelloWormhole {
    IWormholeRelayer public wormholeRelayer;
    uint256 constant GAS_LIMIT = 50_000;

    event MessageReceived(string message, address sender);

    constructor(address _wormholeRelayer) {
        wormholeRelayer = IWormholeRelayer(_wormholeRelayer);
    }

    function sendMsg(
        uint16 targetChain,
        address targetAddress,
        bytes memory payload,
        uint256 receiverValue,
        uint256 gasLimit
    ) public payable {

        (uint256 cost, ) = wormholeRelayer.quoteEVMDeliveryPrice(
            targetChain,
            0,
            GAS_LIMIT
        );

        require(msg.value >= cost, "Insufficient relayer fee");

        wormholeRelayer.sendPayloadToEvm{value: cost}(
            targetChain,
            targetAddress,
            payload,
            receiverValue,
            gasLimit
        );
        
        emit MessageReceived(string(payload), msg.sender);



    }

    function receiveWormholeMessages(
        bytes memory payload,
        bytes[] memory additionalMessages,
        bytes32 sourceAddress,
        uint16 sourceChain,
        bytes32 deliveryHash
    ) external payable {

        string memory message = abi.decode(payload, (string));
        emit MessageReceived(message, address(uint160(uint256(sourceAddress))));
    }
}

