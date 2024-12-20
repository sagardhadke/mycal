import 'package:get/get.dart';

class HomeController extends GetxController {
  RxString displaycal = ''.obs; // To show the calculation on the screen
  RxString result = '0'.obs; // Final result after calculation
  RxString currentNumber =
      ''.obs; // The number that the user is currently entering
  RxString operator = ''.obs; // Operator (+, -, ×, ÷)

  // Button click handler for numbers and operators
  void btnonClick(String value) {
    if (value == 'C') {
      // Clear everything
      displaycal.value = '';
      currentNumber.value = '';
      result.value = '0';
      operator.value = '';
    } else if (value == '⌫') {
      // Handle backspace
      if (currentNumber.value.isNotEmpty) {
        currentNumber.value =
            currentNumber.value.substring(0, currentNumber.value.length - 1);
        displaycal.value =
            displaycal.value.substring(0, displaycal.value.length - 1);
      }
    } else if (value == '+' || value == '×' || value == '÷' || value == '%') {
      // Handle operators (+, ×, ÷, %)
      if (currentNumber.value.isNotEmpty) {
        if (operator.value.isEmpty) {
          // Store the first number and the operator
          displaycal.value = currentNumber.value + ' ' + value + ' ';
          operator.value = value;
          result.value =
              currentNumber.value; // Store the first number as result
          currentNumber.value = ''; // Clear current number for next input
        } else {
          // If operator is already there, calculate the result
          result.value = calculateResult();
          displaycal.value = result.value + ' ' + value + ' ';
          operator.value = value; // Update the operator
          currentNumber.value = ''; // Clear current number for next input
        }
      }
    } else if (value == '-' && currentNumber.value.isEmpty) {
      // Allow negative sign at the start (only if no number is entered yet)
      currentNumber.value = '-';
      displaycal.value = '-';
    } else if (value == '-' && currentNumber.value.isNotEmpty) {
      // If a number is already entered, treat `-` as a subtraction operator
      if (operator.value.isEmpty) {
        operator.value = '-';
        displaycal.value = displaycal.value + ' - ';
      } else {
        // If operator already exists, calculate the result and add new operator
        result.value = calculateResult();
        displaycal.value = result.value + ' - ';
        operator.value = '-';
        currentNumber.value = '';
      }
    } else if (value == '=') {
      // When '=' is pressed, calculate the result
      if (currentNumber.value.isNotEmpty && operator.value.isNotEmpty) {
        result.value = calculateResult();
        displaycal.value += ' = ' + result.value; // Show the final result
        currentNumber.value = result
            .value; // Set the result as the starting point for the next calculation
        operator.value = ''; // Clear operator after calculation
      }
    } else {
      // Handle numbers (0-9)
      currentNumber.value += value;
      displaycal.value = displaycal.value + value;
    }
  }

  // Perform the calculation based on the operator
  String calculateResult() {
    double num1 = double.tryParse(result.value) ??
        0; // The result stored from previous calculation
    double num2 =
        double.tryParse(currentNumber.value) ?? 0; // Current number entered

    switch (operator.value) {
      case '+':
        return (num1 + num2).toString();
      case '-':
        return (num1 - num2).toString();
      case '×':
        return (num1 * num2).toString();
      case '÷':
        if (num2 == 0) {
          return 'Cannot divide by 0'; // Handle division by zero
        } else {
          return (num1 / num2).toString();
        }
      case '%':
        // Ensure modulus works for integers
        if (num1 == num1.toInt() && num2 == num2.toInt()) {
          // If both numbers are whole numbers (integers), perform integer modulus
          return (num1.toInt() % num2.toInt()).toString();
        } else {
          // For floating point numbers, handle modulus and round result
          return (num1 % num2)
              .toStringAsFixed(2); // Return result rounded to 2 decimal places
        }
      default:
        return "Error";
    }
  }
}
