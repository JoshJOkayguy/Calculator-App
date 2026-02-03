import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _displayValue = '0';
  String _expression = '';
  bool _startNewNumber = true;
  String _previousOperator = '';

  void _onNumberPressed(String number) {
    setState(() {
      if (_startNewNumber) {
        _displayValue = number;
        _startNewNumber = false;
      } else {
        if (_displayValue == '0') {
          _displayValue = number;
        } else {
          _displayValue += number;
        }
      }
      _expression += number;
    });
  }

  void _onOperatorPressed(String operator) {
    setState(() {
      if (!_startNewNumber) {
        // Just finished entering a number, add the operator
        _expression += ' $operator ';
        _startNewNumber = true;
      } else if (_expression.isNotEmpty) {
        // We have a result from previous operation, add operator to continue
        _expression += ' $operator ';
        _startNewNumber = true;
      }
    });
  }

  void _onClear() {
    setState(() {
      _displayValue = '0';
      _expression = '';
      _startNewNumber = true;
      _previousOperator = '';
    });
  }

  void _onEquals() {
    try {
      if (_expression.isEmpty) return;

      // Evaluate the expression using the expressions package
      final expression = Expression.parse(_expression);
      const evaluator = ExpressionEvaluator();
      final result = evaluator.eval(expression, {});

      setState(() {
        if (result is double) {
          // Handle double results
          if (result == result.toInt()) {
            _displayValue = result.toInt().toString();
          } else {
            _displayValue = result.toStringAsFixed(10).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
          }
        } else if (result is int) {
          _displayValue = result.toString();
        } else {
          _displayValue = result.toString();
        }
        _expression = _displayValue;
        _startNewNumber = true;
      });
    } catch (e) {
      setState(() {
        _displayValue = 'Error';
        _expression = '';
        _startNewNumber = true;
      });
    }
  }

  void _onDecimal() {
    setState(() {
      if (_startNewNumber) {
        _displayValue = '0.';
        _expression += '0.';
        _startNewNumber = false;
      } else if (!_displayValue.contains('.')) {
        _displayValue += '.';
        _expression += '.';
      }
    });
  }

  void _onBackspace() {
    setState(() {
      if (_displayValue.length > 1) {
        _displayValue = _displayValue.substring(0, _displayValue.length - 1);
        _expression = _expression.substring(0, _expression.length - 1);
      } else {
        _displayValue = '0';
        _expression = _expression.isEmpty ? '' : _expression.substring(0, _expression.length - 1);
        _startNewNumber = true;
      }
    });
  }

  Widget _buildButton(String label, {Color? color, VoidCallback? onPressed}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[300],
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            label,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator App - GitHub Copilot'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Expression display
                    Text(
                      _expression.isEmpty ? '0' : _expression,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10),
                    // Result display
                    Text(
                      _displayValue,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Button Grid
              Row(
                children: [
                  _buildButton(
                    'C',
                    color: Colors.red[400],
                    onPressed: _onClear,
                  ),
                  _buildButton(
                    '⌫',
                    color: Colors.orange[400],
                    onPressed: _onBackspace,
                  ),
                  _buildButton(
                    '÷',
                    color: Colors.blue[400],
                    onPressed: () => _onOperatorPressed('/'),
                  ),
                  _buildButton(
                    '×',
                    color: Colors.blue[400],
                    onPressed: () => _onOperatorPressed('*'),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildButton('7', onPressed: () => _onNumberPressed('7')),
                  _buildButton('8', onPressed: () => _onNumberPressed('8')),
                  _buildButton('9', onPressed: () => _onNumberPressed('9')),
                  _buildButton(
                    '−',
                    color: Colors.blue[400],
                    onPressed: () => _onOperatorPressed('-'),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildButton('4', onPressed: () => _onNumberPressed('4')),
                  _buildButton('5', onPressed: () => _onNumberPressed('5')),
                  _buildButton('6', onPressed: () => _onNumberPressed('6')),
                  _buildButton(
                    '+',
                    color: Colors.blue[400],
                    onPressed: () => _onOperatorPressed('+'),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildButton('1', onPressed: () => _onNumberPressed('1')),
                  _buildButton('2', onPressed: () => _onNumberPressed('2')),
                  _buildButton('3', onPressed: () => _onNumberPressed('3')),
                  _buildButton(
                    '=',
                    color: Colors.green[400],
                    onPressed: _onEquals,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _onNumberPressed('0'),
                        child: const Text(
                          '0',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  _buildButton('.', onPressed: _onDecimal),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}