class LoanDurationCalculator {
    /**
     * Calculate the duration of a loan based on monthly payments for a fixed-rate loan
     * @param {number} principal - The principal amount of the loan
     * @param {number} annualRate - The annual interest rate (in percentage)
     * @param {number} monthlyPayment - The fixed monthly payment amount
     * @returns {number} - The duration of the loan in months
     */
    static calculateLoanDuration(principal, annualRate, monthlyPayment) {
      if (principal <= 0 || annualRate <= 0 || monthlyPayment <= 0) {
        throw new Error("Principal, rate, and payment must be positive numbers.");
      }
      const monthlyRate = annualRate / 100 / 12;
      const numerator = Math.log(monthlyPayment / (monthlyPayment - principal * monthlyRate));
      const denominator = Math.log(1 + monthlyRate);
      const durationInMonths = Math.ceil(numerator / denominator);
  
      if (isNaN(durationInMonths) || durationInMonths <= 0) {
        throw new Error("Unable to calculate duration. Ensure inputs are valid.");
      }
  
      return durationInMonths;
    }
  
    /**
     * Calculate the number of payments required to pay off the loan with fixed payments and compound interest
     * @param {number} principal - The principal amount of the loan
     * @param {number} annualRate - The annual interest rate (in percentage)
     * @param {number} monthlyPayment - The fixed monthly payment amount
     * @returns {number} - The number of payments required to pay off the loan
     */
    static calculateNumberOfPayments(principal, annualRate, monthlyPayment) {
      if (principal <= 0 || annualRate <= 0 || monthlyPayment <= 0) {
        throw new Error("Principal, rate, and payment must be positive numbers.");
      }
      const monthlyRate = annualRate / 100 / 12;
      const numberOfPayments = Math.log(monthlyPayment / (monthlyPayment - principal * monthlyRate)) / Math.log(1 + monthlyRate);
  
      if (isNaN(numberOfPayments) || numberOfPayments <= 0) {
        throw new Error("Unable to calculate number of payments. Ensure inputs are valid.");
      }
  
      return Math.ceil(numberOfPayments);
    }
  }
  
  module.exports = LoanDurationCalculator;
  