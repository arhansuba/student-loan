const Web3 = require('web3');
const StudentLoan = require('../build/contracts/StudentLoan.json');
const LoanToken = require('../build/contracts/LoanToken.json');

// Set up Web3
const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));

// Set up contract instances
const studentLoanAddress = '0xYourStudentLoanAddress'; // Replace with your deployed StudentLoan address
const loanTokenAddress = '0xYourLoanTokenAddress'; // Replace with your deployed LoanToken address

const studentLoan = new web3.eth.Contract(StudentLoan.abi, studentLoanAddress);
const loanToken = new web3.eth.Contract(LoanToken.abi, loanTokenAddress);

// Function to repay a loan
async function repayLoan(studentId, amount) {
  try {
    const accounts = await web3.eth.getAccounts();
    const repayingAccount = accounts[0]; // The account that will repay the loan

    // Check if the repaying account has enough tokens
    const balance = await loanToken.methods.balanceOf(repayingAccount).call();
    if (parseInt(balance) < amount) {
      console.log('Insufficient balance to repay the loan.');
      return;
    }

    // Approve the repayment amount
    await loanToken.methods.approve(studentLoanAddress, amount).send({ from: repayingAccount });

    // Repay the loan
    await studentLoan.methods.repayLoan(studentId, amount).send({ from: repayingAccount });

    console.log(`Successfully repaid ${amount} tokens for student ${studentId}.`);
  } catch (error) {
    console.error('Error repaying the loan:', error);
  }
}

// Example usage
const studentId = '12345'; // Replace with actual student ID
const amount = web3.utils.toWei('5000', 'ether'); // Replace with the amount to repay, in wei

repayLoan(studentId, amount);
