// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract StudentLoan is AccessControl {
    // Roles
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant LENDER_ROLE = keccak256("LENDER_ROLE");

    // Loan structure
    struct Loan {
        uint256 amount;
        uint256 interestRate;
        uint256 dueDate;
        bool isRepaid;
    }

    // Mappings
    mapping(address => Loan) public loans;
    mapping(address => bool) public hasApplied;

    // State variables
    IERC20 public loanToken;
    uint256 public loanDuration = 365 days; // Example: 1 year

    // Events
    event LoanApplied(address indexed student, uint256 amount);
    event LoanRepaid(address indexed student, uint256 amount);
    event LoanIssued(address indexed student, uint256 amount, uint256 interestRate, uint256 dueDate);

    // Constructor
    constructor(address _loanToken) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        loanToken = IERC20(_loanToken);
    }

    // Modifiers
    modifier onlyAdmin() {
        require(hasRole(ADMIN_ROLE, msg.sender), "Not an admin");
        _;
    }

    modifier onlyLender() {
        require(hasRole(LENDER_ROLE, msg.sender), "Not a lender");
        _;
    }

    // Apply for a loan
    function applyForLoan(uint256 _gpa) external {
        require(!hasApplied[msg.sender], "Loan already applied");
        uint256 amount = calculateLoanAmount(_gpa);
        require(amount > 0, "Invalid GPA for loan");

        // Set loan details
        Loan storage loan = loans[msg.sender];
        loan.amount = amount;
        loan.interestRate = calculateInterestRate(_gpa);
        loan.dueDate = block.timestamp + loanDuration;
        loan.isRepaid = false;

        hasApplied[msg.sender] = true;

        emit LoanApplied(msg.sender, amount);
    }

    // Issue the loan (lender must call this)
    function issueLoan(address _student) external onlyLender {
        require(hasApplied[_student], "Student has not applied for a loan");
        Loan storage loan = loans[_student];
        require(loan.amount > 0, "Loan amount is zero");
        require(!loan.isRepaid, "Loan already repaid");

        // Transfer loan amount to student
        require(loanToken.transfer(_student, loan.amount), "Transfer failed");

        emit LoanIssued(_student, loan.amount, loan.interestRate, loan.dueDate);
    }

    // Repay loan
    function repayLoan(uint256 _amount) external {
        Loan storage loan = loans[msg.sender];
        require(_amount > 0, "Amount must be greater than zero");
        require(!loan.isRepaid, "Loan already repaid");
        require(block.timestamp <= loan.dueDate, "Loan overdue");

        // Transfer repayment amount from student
        require(loanToken.transferFrom(msg.sender, address(this), _amount), "Transfer failed");

        // Check if loan is fully repaid
        if (_amount >= loan.amount + calculateInterest(loan.amount, loan.interestRate)) {
            loan.isRepaid = true;
            emit LoanRepaid(msg.sender, _amount);
        }
    }

    // Calculate loan amount based on GPA
    function calculateLoanAmount(uint256 _gpa) public pure returns (uint256) {
        if (_gpa >= 3.5 * 10) {
            return 10000 * 10 ** 18; // Example amount in smallest unit of token
        } else if (_gpa >= 2.5 * 10) {
            return 5000 * 10 ** 18; // Example amount in smallest unit of token
        } else {
            return 0;
        }
    }

    // Calculate interest rate based on GPA
    function calculateInterestRate(uint256 _gpa) public pure returns (uint256) {
        if (_gpa >= 3.5 * 10) {
            return 5; // 5% interest rate
        } else if (_gpa >= 2.5 * 10) {
            return 7; // 7% interest rate
        } else {
            return 10; // 10% interest rate
        }
    }

    // Calculate interest amount
    function calculateInterest(uint256 _principal, uint256 _interestRate) public pure returns (uint256) {
        return (_principal * _interestRate) / 100;
    }

    // Allow admin to set loan duration
    function setLoanDuration(uint256 _duration) external onlyAdmin {
        loanDuration = _duration;
    }

    // Allow admin to add or remove roles
    function addAdmin(address _account) external onlyAdmin {
        grantRole(ADMIN_ROLE, _account);
    }

    function removeAdmin(address _account) external onlyAdmin {
        revokeRole(ADMIN_ROLE, _account);
    }

    function addLender(address _account) external onlyAdmin {
        grantRole(LENDER_ROLE, _account);
    }

    function removeLender(address _account) external onlyAdmin {
        revokeRole(LENDER_ROLE, _account);
    }
}
