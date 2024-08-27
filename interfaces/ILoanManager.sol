// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ILoanManager {
    function createLoan(uint256 studentId, uint256 amount) external;
    function getLoan(uint256 loanId) external view returns (uint256 studentId, uint256 amount, uint256 status);
    function updateLoan(uint256 loanId, uint256 newAmount) external;
}
