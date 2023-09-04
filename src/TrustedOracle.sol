pragma solidity 0.8.19;

import {Initializable} from "oz-upgradeable/proxy/utils/Initializable.sol";
import {IOracle} from "carrot/interfaces/oracles/IOracle.sol";
import {IKPIToken} from "carrot/interfaces/kpi-tokens/IKPIToken.sol";
import {InitializeOracleParams} from "carrot/commons/Types.sol";
import {IBaseTemplatesManager, Template} from "carrot/interfaces/IBaseTemplatesManager.sol";

/// SPDX-License-Identifier: GPL-3.0-or-later
/// @title Trusted oracle
/// @dev A base oracle template implementation that allows an external predefined answerer to
/// finalize the oracle when it decides the time has come. This is intended to be a base contract
/// from which to start building more refined finalization strategies based on an external trusted
/// oracle, and as such some functions are not implemented (this can't be used standalone).
/// @author Federico Luzzi - <federico.luzzi@protonmail.com>
abstract contract TrustedOracle is IOracle, Initializable {
    address public immutable answerer;

    bool public finalized;
    address public kpiToken;
    address internal oraclesManager;
    uint128 internal templateVersion;
    uint256 internal templateId;

    error Forbidden();
    error ZeroAddressAnswerer();
    error ZeroAddressKpiToken();

    event Initialize(address indexed kpiToken, uint256 indexed templateId);
    event Finalize(uint256 result);

    /// @dev Sets the trusted answerer.
    /// @param _answerer The address of the account that will be allowed to finalize
    /// the oracle (should be chosen with care as it's immutable).
    constructor(address _answerer) {
        if (_answerer == address(0)) revert ZeroAddressAnswerer();
        answerer = _answerer;
    }

    /// @dev Initializes the template through the passed in data. This sets up some
    /// necessary internal state but leaves the definition of the internal logic completely
    /// up to the user by overriding the _initialize function. Please note that the internal
    /// state is set up only AFTER the custom user-defined logic has run, so accessing state
    /// variables in the custom logic must be avoided.
    function initialize(InitializeOracleParams memory _params) external payable override initializer {
        if (_params.kpiToken == address(0)) revert ZeroAddressKpiToken();

        _initialize(_params);

        oraclesManager = msg.sender;
        templateVersion = _params.templateVersion;
        templateId = _params.templateId;
        kpiToken = _params.kpiToken;

        emit Initialize(_params.kpiToken, _params.templateId);
    }

    function _initialize(InitializeOracleParams memory _params) internal virtual;

    /// @dev The finalization function checks that the msg.sender is indeed the answerer and
    /// forwards the answer to the linked KPI token.
    function finalize(uint256 _result) external {
        if (finalized || msg.sender != answerer) revert Forbidden();
        _finalize(_result);
        finalized = true;
        IKPIToken(kpiToken).finalize(_result);
        emit Finalize(_result);
    }

    function _finalize(uint256 _result) internal virtual;

    /// @dev View function returning all the most important data about the oracle, in
    /// an ABI-encoded structure. This must be extended by users.
    /// @return The ABI-encoded data.
    function data() external view virtual override returns (bytes memory);

    /// @dev View function returning info about the template used to instantiate this oracle.
    /// @return The template struct.
    function template() external view override returns (Template memory) {
        return IBaseTemplatesManager(oraclesManager).template(templateId, templateVersion);
    }
}
