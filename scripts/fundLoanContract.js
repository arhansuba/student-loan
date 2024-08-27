
const Web3 = require('web3');
const LoanToken = require('../build/contracts/LoanToken.json');
const AccessControlManager = require('../build/contracts/AccessControlManager.json');

// Set up Web3
const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));

// Set up contract instances
const loanTokenAddress = '0xYourLoanTokenAddress'; // Replace with your deployed LoanToken address
const accessControlAddress = '0xYourAccessControlAddress'; // Replace with your deployed AccessControlManager address

const loanToken = new web3.eth.Contract(LoanToken.abi, loanTokenAddress);
const accessControl = new web3.eth.Contract(AccessControlManager.abi, accessControlAddress);

// Function to fund the loan contract
async function fundLoanContract(amount) {
  try {
    const accounts = await web3.eth.getAccounts();
    const fundingAccount = accounts[0]; // The account that will fund the contract

    // Check if the funding account has permission to fund
    const hasPermission = await accessControl.methods.hasRole(web3.utils.sha3('FUNDER_ROLE'), fundingAccount).call();
    if (!hasPermission) {
      console.log('Funding account does not have permission to fund the contract.');
      return;
    }

    // Fund the LoanToken contract
    await loanToken.methods.transfer(fundingAccount, amount).send({ from: fundingAccount });

    console.log(`Successfully funded the loan contract with ${amount} tokens.`);
  } catch (error) {
    console.error('Error funding the loan contract:', error);
  }
}

// Example usage
const amount = web3.utils.toWei('10000', 'ether'); // Replace with the amount to fund, in wei

fundLoanContract(amount);
