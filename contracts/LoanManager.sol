// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "./StudentLoan.sol";
import "./LoanToken.sol";

contract LoanManager is AccessControl {
    // Define roles
    bytes32 public constant LOAN_MANAGER_ROLE = keccak256("LOAN_MANAGER_ROLE");

    // Contracts
    StudentLoan public studentLoanContract;
    LoanToken public loanTokenContract;

    // Events
    event LoanIssued(address indexed student, uint256 amount, uint256 interestRate, uint256 dueDate);
    event LoanRepaid(address indexed student, uint256 amount);

    // Constructor
    constructor(address _studentLoanAddress, address _loanTokenAddress) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        studentLoanContract = StudentLoan(_studentLoanAddress);
        loanTokenContract = LoanToken(_loanTokenAddress);
    }

    // Modifier for loan manager role
    modifier onlyLoanManager() {
        require(hasRole(LOAN_MANAGER_ROLE, msg.sender), "Caller is not a loan manager");
        _;
    }

    // Issue loan to a student
    function issueLoan(address _student) external onlyLoanManager {
        require(studentLoanContract.hasApplied(_student), "Student has not applied for a loan");
        (uint256 amount, uint256 interestRate, uint256 dueDate, bool isRepaid) = studentLoanContract.loans(_student);
        StudentLoan.Loan memory loan = StudentLoan.Loan(amount, interestRate, dueDate, isRepaid);
        require(loan.amount > 0, "No loan amount specified");
        require(!loan.isRepaid, "Loan already repaid");

        // Transfer tokens from the contract to the student
        require(loanTokenContract.transfer(_student, loan.amount), "Transfer failed");

        emit LoanIssued(_student, loan.amount, loan.interestRate, loan.dueDate);
    }

    // Repay loan on behalf of a student
    function repayLoan(address _student, uint256 _amount) external onlyLoanManager {
        (uint256 amount, uint256 interestRate, uint256 dueDate, bool isRepaid) = studentLoanContract.loans(_student);
        StudentLoan.Loan memory loan = StudentLoan.Loan(amount, interestRate, dueDate, isRepaid);
        require(_amount > 0, "Amount must be greater than zero");
        require(!loan.isRepaid, "Loan already repaid");
        require(block.timestamp <= loan.dueDate, "Loan overdue");

        // Transfer repayment amount to the contract
        require(loanTokenContract.transferFrom(_student, address(this), _amount), "Transfer failed");

        // Check if loan is fully repaid
        uint256 totalRepayable = loan.amount + studentLoanContract.calculateInterest(loan.amount, loan.interestRate);
        if (_amount >= totalRepayable) {
            loan.isRepaid = true;
            emit LoanRepaid(_student, _amount);
        }
    }

    // Allow admin to set student loan contract
    function setStudentLoanContract(address _studentLoanAddress) external onlyRole(DEFAULT_ADMIN_ROLE) {
        studentLoanContract = StudentLoan(_studentLoanAddress);
    }

    // Allow admin to set loan token contract
    function setLoanTokenContract(address _loanTokenAddress) external onlyRole(DEFAULT_ADMIN_ROLE) {
        loanTokenContract = LoanToken(_loanTokenAddress);
    }

    // Add or remove loan manager roles
    function addLoanManager(address _account) external onlyRole(DEFAULT_ADMIN_ROLE) {
        grantRole(LOAN_MANAGER_ROLE, _account);
    }

    function removeLoanManager(address _account) external onlyRole(DEFAULT_ADMIN_ROLE) {
        revokeRole(LOAN_MANAGER_ROLE, _account);
    }
}
