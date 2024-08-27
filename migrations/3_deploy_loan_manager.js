const LoanManager = artifacts.require("LoanManager");
const StudentLoan = artifacts.require("StudentLoan");
const LoanToken = artifacts.require("LoanToken");
const AccessControlManager = artifacts.require("AccessControlManager");

module.exports = async function (deployer) {
  const accessControl = await AccessControlManager.deployed();
  const studentLoan = await StudentLoan.deployed();
  const loanToken = await LoanToken.deployed();

  // Deploy LoanManager contract with StudentLoan and LoanToken addresses
  await deployer.deploy(LoanManager, studentLoan.address, loanToken.address);
  const loanManager = await LoanManager.deployed();

  // Optionally set roles or other configurations if needed
  // e.g., await accessControl.addLoanManager(loanManager.address);
};
