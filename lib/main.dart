import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart'; // Import package for expression evaluation

// Main function - Entry point of the app
void main() {
  runApp(CalculatorApp());
}

// StatelessWidget as the root widget
class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hides the debug banner
      theme: ThemeData.dark(), // Dark theme for modern UI
      home: CalculatorScreen(),
    );
  }
}

// StatefulWidget for the Calculator UI and Logic
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

// State class to manage UI updates and logic
class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = ""; // Stores user input (e.g., "12+5")
  String output = ""; // Stores calculated result

  // Function to handle button presses
  void onButtonPressed(String value) {
    setState(() {
      if (value == "C") {
        // Clears all input
        input = "";
        output = "";
      } else if (value == "⌫") {
        // Deletes the last character
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
      } else if (value == "=") {
        // Evaluates the expression safely
        output = evaluateExpression(input);
      } else {
        // Append pressed button to input
        input += value;
      }
    });
  }

  // Function to evaluate mathematical expressions safely
  String evaluateExpression(String expression) {
    try {
      expression = expression
          .replaceAll("×", "*")
          .replaceAll("÷", "/"); // Convert symbols
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      return eval.toString();
    } catch (e) {
      return "Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color
      appBar: AppBar(title: Text("Calculator")), // App title

      // Main column for layout
      body: Column(
        children: [
          // Display Section
          Expanded(
            flex: 2, // Takes more space for better visibility
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(input,
                      style: TextStyle(fontSize: 32, color: Colors.white)),
                  SizedBox(height: 10),
                  Text(output,
                      style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.green)),
                ],
              ),
            ),
          ),

          // Buttons Section
          Expanded(
            flex: 3,
            child: Column(
              children: [
                buildButtonRow(["C", "÷", "×", "⌫"]),
                buildButtonRow(["7", "8", "9", "-"]),
                buildButtonRow(["4", "5", "6", "+"]),
                buildButtonRow(["1", "2", "3", "="]),
                buildButtonRow(["0", ".", "00"]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to build a row of calculator buttons
  Widget buildButtonRow(List<String> values) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: values.map((value) => buildButton(value)).toList(),
      ),
    );
  }

  // Function to build a single calculator button
  Widget buildButton(String value) {
    bool isOperator = ["+", "-", "×", "÷", "="].contains(value);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => onButtonPressed(value),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(20),
            backgroundColor: isOperator
                ? Colors.orange
                : Colors.grey[800], // Different colors for operators
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            value,
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
