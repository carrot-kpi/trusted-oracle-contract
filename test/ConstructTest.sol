pragma solidity 0.8.19;

import {BaseTestSetup} from "test/commons/BaseTestSetup.sol";
import {MockOracle} from "test/mocks/MockOracle.sol";

/// SPDX-License-Identifier: GPL-3.0-or-later
/// @title Trusted oracle construction test
/// @dev Tests construction in the trusted oracle template.
/// @author Federico Luzzi - <federico.luzzi@protonmail.com>
contract ConstructTest is BaseTestSetup {
    function testZeroAddressAnswerer() external {
        vm.expectRevert(abi.encodeWithSignature("ZeroAddressAnswerer()"));
        new MockOracle(address(0));
    }

    function testSuccess() external {
        MockOracle _oracle = new MockOracle(ANSWERER);
        assertEq(_oracle.answerer(), ANSWERER);
    }
}
