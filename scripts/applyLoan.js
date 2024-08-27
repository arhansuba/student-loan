const Web3 = require('web3');
const LoanManager = require('../build/contracts/LoanManager.json');
const StudentLoan = require('../build/contracts/StudentLoan.json');
const LoanToken = require('../build/contracts/LoanToken.json');
const AccessControlManager = require('../build/contracts/AccessControlManager.json');

// Set up Web3
const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));

// Set up contract instances
const loanManagerAddress = '0xYourLoanManagerAddress'; // Replace with your deployed LoanManager address
const studentLoanAddress = '0xYourStudentLoanAddress'; // Replace with your deployed StudentLoan address
const loanTokenAddress = '0xYourLoanTokenAddress'; // Replace with your deployed LoanToken address
const accessControlAddress = '0xYourAccessControlAddress'; // Replace with your deployed AccessControlManager address

const loanManager = new web3.eth.Contract(LoanManager.abi, loanManagerAddress);
const studentLoan = new web3.eth.Contract(StudentLoan.abi, studentLoanAddress);
const loanToken = new web3.eth.Contract(LoanToken.abi, loanTokenAddress);
const accessControl = new web3.eth.Contract(AccessControlManager.abi, accessControlAddress);

// Function to apply for a loan
async function applyForLoan(studentId, gpa) {
  try {
    // Check if the student is eligible based on GPA
    let loanAmount = 0;
    if (gpa >= 3) {
      loanAmount = 10000; // Example loan amount for GPA >= 3
    } else if (gpa >= 2.5) {
      loanAmount = 5000; // Example loan amount for GPA >= 2.5
    } else {
      console.log('Student not eligible for a loan based on GPA.');
      return;
    }

    // Apply for the loan
    const accounts = await web3.eth.getAccounts();
    await studentLoan.methods.applyForLoan(studentId, loanAmount).send({ from: accounts[0] });

    // Disburse the loan amount
    await loanToken.methods.mint(accounts[0], loanAmount).send({ from: accounts[0] });

    console.log(`Loan of ${loanAmount} has been successfully applied and disbursed to student ${studentId}.`);
  } catch (error) {
    console.error('Error applying for loan:', error);
  }
}

// Example usage
const studentId = '12345'; // Replace with actual student ID
const gpa = 3.2; // Replace with actual GPA

applyForLoan(studentId, gpa);
