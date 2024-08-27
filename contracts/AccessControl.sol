// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "./Counters.sol";

contract AccessControlManager is AccessControl {
    using Counters for Counters.Counter;

    // Define roles
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    // Counter for tracking the number of role assignments
    Counters.Counter private _roleAssignmentCount;

    // Events
    event RoleAssigned(address indexed account, bytes32 indexed role);
    event RoleRevoked(address indexed account, bytes32 indexed role);

    // Constructor
    constructor() {
        _grantRole(ADMIN_ROLE, msg.sender);
        _setRoleAdmin(MINTER_ROLE, ADMIN_ROLE);
        _setRoleAdmin(BURNER_ROLE, ADMIN_ROLE);
    }

    // Modifier for admin role
    modifier onlyAdmin() {
        require(hasRole(ADMIN_ROLE, msg.sender), "Caller is not an admin");
        _;
    }

    // Modifier for minter role
    modifier onlyMinter() {
        require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
        _;
    }

    // Modifier for burner role
    modifier onlyBurner() {
        require(hasRole(BURNER_ROLE, msg.sender), "Caller is not a burner");
        _;
    }

    // Assign a role to an account
    function assignRole(address account, bytes32 role) external onlyAdmin {
        grantRole(role, account);
        _roleAssignmentCount.increment();
        emit RoleAssigned(account, role);
    }

    // Revoke a role from an account
    function revokeRoleFromAccount(address account, bytes32 role) external onlyAdmin {
        revokeRole(role, account);
        _roleAssignmentCount.increment();
        emit RoleRevoked(account, role);
    }

    // Check if an account has a specific role
    function checkRole(address account, bytes32 role) external view returns (bool) {
        return hasRole(role, account);
    }

    // Get the number of role assignments or revocations
    function getRoleAssignmentCount() external view returns (uint256) {
        return _roleAssignmentCount.current();
    }

    // Allow admins to renounce their role (self-revoke)
    function renounceRole(bytes32 role) external {
        renounceRole(role, msg.sender);
        emit RoleRevoked(msg.sender, role);
    }
}
