import 'package:get/get.dart';

class HomeController extends GetxController {
  RxString displaycal = ''.obs;
  RxString result = '0'.obs;
  RxString currentNumber = ''.obs;
  RxString operator = ''.obs;

  void btnonClick(String value) {
    if (value == 'C') {
      displaycal.value = '';
      currentNumber.value = '';
      result.value = '0';
      operator.value = '';
    } else if (value == '⌫') {
      if (currentNumber.value.isNotEmpty) {
        currentNumber.value =
            currentNumber.value.substring(0, currentNumber.value.length - 1);
        displaycal.value =
            displaycal.value.substring(0, displaycal.value.length - 1);
      }
    } else if (value == '+' || value == '×' || value == '÷' || value == '%') {
      if (currentNumber.value.isNotEmpty) {
        if (operator.value.isEmpty) {
          displaycal.value = currentNumber.value + ' ' + value + ' ';
          operator.value = value;
          result.value = currentNumber.value;
          currentNumber.value = '';
        } else {
          result.value = calculateResult();
          displaycal.value = result.value + ' ' + value + ' ';
          operator.value = value;
          currentNumber.value = '';
        }
      }
    } else if (value == '-' && currentNumber.value.isEmpty) {
      currentNumber.value = '-';
      displaycal.value = '-';
    } else if (value == '-' && currentNumber.value.isNotEmpty) {
      if (operator.value.isEmpty) {
        operator.value = '-';
        displaycal.value = displaycal.value + ' - ';
      } else {
        result.value = calculateResult();
        displaycal.value = result.value + ' - ';
        operator.value = '-';
        currentNumber.value = '';
      }
    } else if (value == '=') {
      if (currentNumber.value.isNotEmpty && operator.value.isNotEmpty) {
        result.value = calculateResult();
        displaycal.value += ' = ' + result.value;
        currentNumber.value = result.value;
        operator.value = '';
      }
    } else {
      currentNumber.value += value;
      displaycal.value = displaycal.value + value;
    }
  }

  String calculateResult() {
    double num1 = double.tryParse(result.value) ?? 0;
    double num2 = double.tryParse(currentNumber.value) ?? 0;

    switch (operator.value) {
      case '+':
        return (num1 + num2).toString();
      case '-':
        return (num1 - num2).toString();
      case '×':
        return (num1 * num2).toString();
      case '÷':
        if (num2 == 0) {
          return 'Cannot divide by 0';
        } else {
          return (num1 / num2).toString();
        }
      case '%':
        if (num1 == num1.toInt() && num2 == num2.toInt()) {
          return (num1.toInt() % num2.toInt()).toString();
        } else {
          return (num1 % num2).toStringAsFixed(2);
        }
      default:
        return "Error";
    }
  }
}
