// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IStudentLoan {
    function applyLoan(uint256 studentId, uint256 amount) external;
    function getLoanStatus(uint256 studentId) external view returns (string memory);
    function repayLoan(uint256 studentId, uint256 amount) external;
    function getLoanDetails(uint256 studentId) external view returns (uint256 amount, uint256 dueDate, uint256 repaymentAmount, string memory status);
}
