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
    function testZeroAddressKpiToken() external {
        MockOracle mockOracleInstance = MockOracle(ClonesUpgradeable.clone(address(mockOracle)));
        Template memory _template = oraclesManager.template(1);
        vm.expectRevert(abi.encodeWithSignature("ZeroAddressKpiToken()"));
        vm.prank(address(oraclesManager));
        mockOracleInstance.initialize(
            InitializeOracleParams({
                creator: address(this),
                kpiToken: address(0),
                templateId: _template.id,
                templateVersion: _template.version,
                data: abi.encode(uint256(1))
            })
        );
    }

    function testSuccess() external {
        MockOracle mockOracleInstance = MockOracle(ClonesUpgradeable.clone(address(mockOracle)));
        Template memory _template = oraclesManager.template(1);
        address kpiToken = address(1);
        vm.prank(address(oraclesManager));
        mockOracleInstance.initialize(
            InitializeOracleParams({
                creator: address(this),
                kpiToken: kpiToken,
                templateId: _template.id,
                templateVersion: _template.version,
                data: abi.encode("")
            })
        );

        assertEq(mockOracleInstance.finalized(), false);
        assertEq(mockOracleInstance.kpiToken(), kpiToken);
        assertEq(mockOracleInstance.template().id, _template.id);
        assertEq(mockOracleInstance.template().version, _template.version);

        vm.clearMockedCalls();
    }
}
