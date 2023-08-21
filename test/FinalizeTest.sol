pragma solidity 0.8.19;

import {BaseTestSetup} from "test/commons/BaseTestSetup.sol";
import {MockOracle} from "test/mocks/MockOracle.sol";
import {ClonesUpgradeable} from "oz-upgradeable/proxy/ClonesUpgradeable.sol";
import {Template} from "carrot/interfaces/IBaseTemplatesManager.sol";
import {InitializeOracleParams} from "carrot/commons/Types.sol";

/// SPDX-License-Identifier: GPL-3.0-or-later
/// @title Trusted oracle construction test
/// @dev Tests construction in the trusted oracle template.
/// @author Federico Luzzi - <federico.luzzi@protonmail.com>
contract InitializeTest is BaseTestSetup {
    function testAlreadyFinalized() external {
        MockOracle oracleInstance = MockOracle(ClonesUpgradeable.clone(address(mockOracle)));
        Template memory _template = oraclesManager.template(1);
        address kpiToken = address(1);
        vm.prank(address(oraclesManager));
        oracleInstance.initialize(
            InitializeOracleParams({
                creator: address(this),
                kpiToken: kpiToken,
                templateId: _template.id,
                templateVersion: _template.version,
                data: abi.encode()
            })
        );

        vm.mockCall(kpiToken, abi.encodeWithSignature("finalize(uint256)", uint256(0)), abi.encode());

        vm.prank(ANSWERER);
        oracleInstance.finalize(0);
        assertTrue(oracleInstance.finalized());

        vm.prank(ANSWERER);
        vm.expectRevert(abi.encodeWithSignature("Forbidden()"));
        oracleInstance.finalize(0);

        vm.clearMockedCalls();
    }

    function testNotAnswerer() external {
        MockOracle oracleInstance = MockOracle(ClonesUpgradeable.clone(address(mockOracle)));
        Template memory _template = oraclesManager.template(1);
        address kpiToken = address(1);
        vm.prank(address(oraclesManager));
        oracleInstance.initialize(
            InitializeOracleParams({
                creator: address(this),
                kpiToken: kpiToken,
                templateId: _template.id,
                templateVersion: _template.version,
                data: abi.encode()
            })
        );

        vm.prank(address(1));
        vm.expectRevert(abi.encodeWithSignature("Forbidden()"));
        oracleInstance.finalize(0);

        vm.clearMockedCalls();
    }

    function testSuccess() external {
        MockOracle oracleInstance = MockOracle(ClonesUpgradeable.clone(address(mockOracle)));
        Template memory _template = oraclesManager.template(1);
        address kpiToken = address(1);
        vm.prank(address(oraclesManager));
        oracleInstance.initialize(
            InitializeOracleParams({
                creator: address(this),
                kpiToken: kpiToken,
                templateId: _template.id,
                templateVersion: _template.version,
                data: abi.encode()
            })
        );

        vm.mockCall(kpiToken, abi.encodeWithSignature("finalize(uint256)", uint256(0)), abi.encode());

        vm.prank(ANSWERER);
        oracleInstance.finalize(0);

        assertTrue(oracleInstance.finalized());

        vm.clearMockedCalls();
    }
}
