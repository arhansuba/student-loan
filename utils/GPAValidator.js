// GPAValidator.js

/**
 * Validates a student's GPA input.
 * @param {number} gpa - The GPA to validate.
 * @returns {boolean} True if GPA is valid, otherwise false.
 */
function validateGPA(gpa) {
    // Check if GPA is a number
    if (typeof gpa !== 'number') {
        console.error("Invalid GPA: GPA must be a number.");
        return false;
    }

    // GPA must be within the range of 0.0 to 4.0
    if (gpa < 0.0 || gpa > 4.0) {
        console.error("Invalid GPA: GPA must be between 0.0 and 4.0.");
        return false;
    }

    return true;
}

/**
 * Formats the GPA to a consistent precision (e.g., 2 decimal places).
 * @param {number} gpa - The GPA to format.
 * @returns {number} The formatted GPA.
 */
function formatGPA(gpa) {
    return parseFloat(gpa.toFixed(2));
}

module.exports = {
    validateGPA,
    formatGPA
};