const Web3 = require('web3');
const StudentLoan = require('../build/contracts/StudentLoan.json');

// Set up Web3
const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));

// Set up contract instance
const studentLoanAddress = '0xYourStudentLoanAddress'; // Replace with your deployed StudentLoan address
const studentLoan = new web3.eth.Contract(StudentLoan.abi, studentLoanAddress);

// Function to get the loan status
async function getLoanStatus(studentId) {
  try {
    const status = await studentLoan.methods.getLoanStatus(studentId).call();
    console.log(`Loan Status for Student ${studentId}: ${status}`);
  } catch (error) {
    console.error('Error retrieving loan status:', error);
  }
}

// Example usage
const studentId = '12345'; // Replace with actual student ID

getLoanStatus(studentId);
