import 'dart:math';

abstract class CalculatorOperation {
  String apply(String expression);
}

class AdditionOperation implements CalculatorOperation {
  @override
  String apply(String expression) {
    final parts = expression.split('+');
    final result = parts.map(double.parse).reduce((a, b) => a + b);
    return result.toString();
  }
}

class SubtractionOperation implements CalculatorOperation {
  @override
  String apply(String expression) {
    final parts = expression.split('-');
    final result = parts.map(double.parse).reduce((a, b) => a - b);
    return result.toString();
  }
}

class MultiplicationOperation implements CalculatorOperation {
  @override
  String apply(String expression) {
    final parts = expression.split('*');
    final result = parts.map(double.parse).reduce((a, b) => a * b);
    return result.toString();
  }
}

class DivisionOperation implements CalculatorOperation {
  @override
  String apply(String expression) {
    final parts = expression.split('/');
    if (parts.length != 2) throw Exception("Invalid division expression");
    final dividend = double.parse(parts[0]);
    final divisor = double.parse(parts[1]);
    if (divisor == 0) throw Exception("Cannot divide by zero");
    return (dividend / divisor).toString();
  }
}

class SquareRootOperation implements CalculatorOperation {
  @override
  String apply(String expression) {
    final value = double.parse(expression);
    if (value < 0) throw Exception("Cannot calculate square root of a negative number");
    return sqrt(value).toString();
  }
}

class SquareOperation implements CalculatorOperation {
  @override
  String apply(String expression) {
    final value = double.parse(expression);
    return (value * value).toString();
  }
}

class ReciprocalOperation implements CalculatorOperation {
  @override
  String apply(String expression) {
    final value = double.parse(expression);
    if (value == 0) throw Exception("Cannot divide by zero");
    return (1 / value).toString();
  }
}

class PercentageOperation implements CalculatorOperation {
  @override
  String apply(String expression) {
    if (expression.contains('*')) {
      final parts = expression.split('*');
      if (parts.length == 2 && parts[1].endsWith('%')) {
        final base = double.parse(parts[0]);
        final percentage = double.parse(parts[1].replaceAll('%', ''));
        return ((base * percentage) / 100).toString();
      }
    }
    if (expression.endsWith('%')) {
      final value = double.parse(expression.replaceAll('%', ''));
      return (value / 100).toString();
    }
    // If the expression doesn't match any of the above cases,
    // we'll return it as is, allowing for further processing
    return expression;
  }
}
