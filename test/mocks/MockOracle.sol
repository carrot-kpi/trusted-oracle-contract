pragma solidity 0.8.19;

import {TrustedOracle} from "src/TrustedOracle.sol";
import {InitializeOracleParams} from "carrot/commons/Types.sol";

/// SPDX-License-Identifier: GPL-3.0-or-later
/// @title A mock oracle.
/// @dev A mock oracle that extends the trusted oracle mocking the missing logic.
/// @author Federico Luzzi - <federico.luzzi@protonmail.com>
contract MockOracle is TrustedOracle {
    constructor(address _answerer) TrustedOracle(_answerer) {}

    function _initialize(
        InitializeOracleParams memory _params
    ) internal override {
        // do nothing
    }

    function data() external view virtual override returns (bytes memory) {
        return abi.encode(answerer);
    }
}
