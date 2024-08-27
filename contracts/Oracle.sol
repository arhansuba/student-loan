// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract Oracle is AccessControl {
    // Define roles
    bytes32 public constant DATA_PROVIDER_ROLE = keccak256("DATA_PROVIDER_ROLE");

    // Data storage
    mapping(string => uint256) private data;

    // Events
    event DataUpdated(string indexed key, uint256 value);

    // Constructor
    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    // Modifier for data provider role
    modifier onlyDataProvider() {
        require(hasRole(DATA_PROVIDER_ROLE, msg.sender), "Caller is not a data provider");
        _;
    }

    // Update data in the oracle
    function updateData(string calldata key, uint256 value) external onlyDataProvider {
        data[key] = value;
        emit DataUpdated(key, value);
    }

    // Retrieve data from the oracle
    function getData(string calldata key) external view returns (uint256) {
        return data[key];
    }

    // Add or remove data provider roles
    function addDataProvider(address account) external onlyRole(DEFAULT_ADMIN_ROLE) {
        grantRole(DATA_PROVIDER_ROLE, account);
    }

    function removeDataProvider(address account) external onlyRole(DEFAULT_ADMIN_ROLE) {
        revokeRole(DATA_PROVIDER_ROLE, account);
    }
}
