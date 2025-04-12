// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

/*
 * @title OracleLib
 * @author Aditya Kiran Choudhary
 * @notice This library provides functions to interact with Chainlink oracles.
 * If a price is stale, the funciton will revert, and render the DSCEngine unusable - this is by design.
 * We want the DSCEngine to freeze if the prices become stable.
 * 
 * so if the chainlink network explodes and you have a lot of money locked in th eprotocol... too bad.
 */
library OracleLib {
    error Oracle__StalePrice();

    uint256 private constant TIMEOUT = 3 hours;

    function staleCheckLatestRoundData(AggregatorV3Interface priceFeed)
        public
        view
        returns (uint80, int256, uint256, uint80)
    {
        (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound) =
            priceFeed.latestRoundData();

        uint256 secondSince = block.timestamp - updatedAt;
        if (secondSince > TIMEOUT) revert Oracle__StalePrice();
        return (roundId, answer, startedAt, answeredInRound);
    }
}
