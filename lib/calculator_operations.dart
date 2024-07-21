import 'dart:math';

abstract class CalculatorOperation {
  double apply(double operand1, [double? operand2]);
  bool get requiresTwoOperands;
}

class AdditionOperation implements CalculatorOperation {
  @override
  double apply(double operand1, [double? operand2]) => operand1 + operand2!;

  @override
  bool get requiresTwoOperands => true;
}

class SubtractionOperation implements CalculatorOperation {
  @override
  double apply(double operand1, [double? operand2]) => operand1 - operand2!;

  @override
  bool get requiresTwoOperands => true;
}

class MultiplicationOperation implements CalculatorOperation {
  @override
  double apply(double operand1, [double? operand2]) => operand1 * operand2!;

  @override
  bool get requiresTwoOperands => true;
}

class DivisionOperation implements CalculatorOperation {
  @override
  double apply(double operand1, [double? operand2]) {
    if (operand2 == 0) throw Exception("Cannot divide by zero");
    return operand1 / operand2!;
  }

  @override
  bool get requiresTwoOperands => true;
}

class SquareRootOperation implements CalculatorOperation {
  @override
  double apply(double operand1, [double? operand2]) {
    if (operand1 < 0) {
      throw Exception("Cannot calculate square root of a negative number");
    }
    return sqrt(operand1);
  }

  @override
  bool get requiresTwoOperands => false;
}

class SquareOperation implements CalculatorOperation {
  @override
  double apply(double operand1, [double? operand2]) => operand1 * operand1;

  @override
  bool get requiresTwoOperands => false;
}

class ReciprocalOperation implements CalculatorOperation {
  @override
  double apply(double operand1, [double? operand2]) {
    if (operand1 == 0) throw Exception("Cannot divide by zero");
    return 1 / operand1;
  }

  @override
  bool get requiresTwoOperands => false;
}

class PercentageOperation implements CalculatorOperation {
  @override
  double apply(double operand1, [double? operand2]) {
    if (operand2 == null) return operand1;
    return operand1 * (operand2 / 100);
  }

  @override
  bool get requiresTwoOperands => true;
}
