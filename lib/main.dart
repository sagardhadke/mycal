import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String display = '0';  // Display value on the screen
  double num1 = 0;       // First number
  double num2 = 0;       // Second number
  String operator = '';  // Current operator
  String result = '0';   // Calculation result

  void buttonPressed(String value) {
    setState(() {
      if (value == 'C') {
        display = '0';
        num1 = 0;
        num2 = 0;
        operator = '';
        result = '0';
      } else if (value == '=' && operator.isNotEmpty) {
        num2 = double.tryParse(display) ?? 0;
        result = calculateResult();
        display = result; // Display the result on the screen
      } else if (value == '+' || value == '-' || value == '×' || value == '÷') {
        // Only set operator if it's the first time, otherwise calculate result and set num1 to result
        if (num1 == 0) {
          num1 = double.tryParse(display) ?? 0;
        } else {
          num2 = double.tryParse(display) ?? 0;
          result = calculateResult();
          num1 = double.tryParse(result) ?? 0;
        }
        operator = value;
        // Display the current operation as a full expression, e.g., "5 +"
        display = num1.toString() + ' ' + operator;
      } else {
        if (display == '0') {
          display = value; // If the display is '0', replace it with the pressed number
        } else {
          display += value; // Append the value to the display
        }
      }
    });
  }

  String calculateResult() {
    switch (operator) {
      case '+':
        return (num1 + num2).toString();
      case '-':
        return (num1 - num2).toString();
      case '×':
        return (num1 * num2).toString();
      case '÷':
        if (num2 == 0) {
          return 'Error'; // Handling division by zero
        } else {
          return (num1 / num2).toString();
        }
      default:
        return 'Error';
    }
  }

  Widget calculatorButton(String value) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () => buttonPressed(value),
        child: Text(
          value,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Calculator'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Display the current input and operation
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.all(20),
            child: Text(
              display,
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          // Display the result
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.all(20),
            child: Text(
              result,
              style: TextStyle(fontSize: 32, color: Colors.grey),
            ),
          ),
          // Row for number buttons 7, 8, 9, divide
          Row(
            children: [
              calculatorButton('7'),
              calculatorButton('8'),
              calculatorButton('9'),
              calculatorButton('÷'),
            ],
          ),
          // Row for number buttons 4, 5, 6, multiply
          Row(
            children: [
              calculatorButton('4'),
              calculatorButton('5'),
              calculatorButton('6'),
              calculatorButton('×'),
            ],
          ),
          // Row for number buttons 1, 2, 3, subtract
          Row(
            children: [
              calculatorButton('1'),
              calculatorButton('2'),
              calculatorButton('3'),
              calculatorButton('-'),
            ],
          ),
          // Row for number buttons 0, decimal, clear, add
          Row(
            children: [
              calculatorButton('0'),
              calculatorButton('.'),
              calculatorButton('C'),
              calculatorButton('+'),
            ],
          ),
          // Row for equals button
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => buttonPressed('='),
                  child: Text(
                    '=',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
