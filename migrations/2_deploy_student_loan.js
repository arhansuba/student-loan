const StudentLoan = artifacts.require("StudentLoan");
const LoanToken = artifacts.require("LoanToken");
const AccessControlManager = artifacts.require("AccessControlManager");

module.exports = async function (deployer) {
  // Deploy AccessControlManager contract first
  await deployer.deploy(AccessControlManager);
  const accessControl = await AccessControlManager.deployed();

  // Deploy LoanToken contract with AccessControlManager address
  await deployer.deploy(LoanToken, accessControl.address);
  const loanToken = await LoanToken.deployed();

  // Deploy StudentLoan contract with LoanToken and AccessControlManager addresses
  await deployer.deploy(StudentLoan, loanToken.address, accessControl.address);
  const studentLoan = await StudentLoan.deployed();
};
