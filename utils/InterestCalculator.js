class InterestCalculator {
    /**
     * Calculate simple interest
     * @param {number} principal - The principal amount of the loan
     * @param {number} annualRate - The annual interest rate (in percentage)
     * @param {number} timeInYears - The time period for which the interest is calculated (in years)
     * @returns {number} - The calculated interest amount
     */
    static calculateSimpleInterest(principal, annualRate, timeInYears) {
      if (principal <= 0 || annualRate <= 0 || timeInYears <= 0) {
        throw new Error("Principal, rate, and time must be positive numbers.");
      }
      return (principal * annualRate * timeInYears) / 100;
    }
  
    /**
     * Calculate compound interest
     * @param {number} principal - The principal amount of the loan
     * @param {number} annualRate - The annual interest rate (in percentage)
     * @param {number} timeInYears - The time period for which the interest is calculated (in years)
     * @param {number} numberOfTimesCompounded - The number of times interest is compounded per year
     * @returns {number} - The accumulated amount including principal and interest
     */
    static calculateCompoundInterest(principal, annualRate, timeInYears, numberOfTimesCompounded) {
      if (principal <= 0 || annualRate <= 0 || timeInYears <= 0 || numberOfTimesCompounded <= 0) {
        throw new Error("Principal, rate, time, and number of times compounded must be positive numbers.");
      }
      const ratePerPeriod = annualRate / (100 * numberOfTimesCompounded);
      const totalPeriods = numberOfTimesCompounded * timeInYears;
      return principal * Math.pow(1 + ratePerPeriod, totalPeriods);
    }
  }
  
  module.exports = InterestCalculator;
  