import 'package:bloc/bloc.dart';
import 'dart:math';
import 'calculator_event.dart';
import 'calculator_state.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  String _expression = "";
  double? _lastResult;

  CalculatorBloc() : super(CalculatorInitialState()) {
    on<AddNumber>((event, emit) {
      _expression += event.number;
      emit(CalculatorResultState(_expression));
    });

    on<AddOperator>((event, emit) {
      _expression += event.operator;
      emit(CalculatorResultState(_expression));
    });

    on<Calculate>((event, emit) {
      try {
        final result = _calculateResult(_expression);
        _lastResult = result;
        emit(CalculatorResultState(result.toString()));
      } catch (e) {
        emit(CalculatorErrorState(e.toString()));
      }
    });

    on<Clear>((event, emit) {
      _expression = "";
      _lastResult = null;
      emit(CalculatorInitialState());
    });

    on<ChangeSign>((event, emit) {
      if (_lastResult != null) {
        _lastResult = -_lastResult!;
        _expression = _lastResult.toString();
      } else if (_expression.isNotEmpty) {
        if (_expression.startsWith('-')) {
          _expression = _expression.substring(1);
        } else {
          _expression = '-$_expression';
        }
      }
      emit(CalculatorResultState(_expression));
    });

    on<Percentage>((event, emit) {
      if (_lastResult != null) {
        _lastResult = _lastResult! / 100;
        _expression = _lastResult.toString();
      } else if (_expression.isNotEmpty) {
        try {
          double value = double.parse(_expression);
          value /= 100;
          _expression = value.toString();
        } catch (e) {
          emit(CalculatorErrorState("Invalid input for percentage"));
          return;
        }
      }
      emit(CalculatorResultState(_expression));
    });

    on<SquareRoot>((event, emit) {
      try {
        double value = _lastResult ?? double.parse(_expression);
        if (value < 0) {
          throw Exception("Cannot calculate square root of a negative number");
        }
        _lastResult = sqrt(value);
        _expression = _lastResult.toString();
        emit(CalculatorResultState(_expression));
      } catch (e) {
        emit(CalculatorErrorState(e.toString()));
      }
    });

    on<Square>((event, emit) {
      try {
        double value = _lastResult ?? double.parse(_expression);
        _lastResult = value * value;
        _expression = _lastResult.toString();
        emit(CalculatorResultState(_expression));
      } catch (e) {
        emit(CalculatorErrorState(e.toString()));
      }
    });

    on<Reciprocal>((event, emit) {
      try {
        double value = _lastResult ?? double.parse(_expression);
        if (value == 0) {
          throw Exception("Cannot divide by zero");
        }
        _lastResult = 1 / value;
        _expression = _lastResult.toString();
        emit(CalculatorResultState(_expression));
      } catch (e) {
        emit(CalculatorErrorState(e.toString()));
      }
    });
  }

  double _calculateResult(String expression) {
    final operatorIndex =
        expression.indexOf(RegExp(r'[+\-*/]', caseSensitive: false));
    if (operatorIndex == -1) {
      return double.parse(expression);
    }

    // Extract operator
    final operator = expression[operatorIndex];

    // Extract operands
    final operand1 = double.parse(expression.substring(0, operatorIndex));
    final operand2 = double.parse(expression.substring(operatorIndex + 1));

    // Perform operation
    switch (operator) {
      case '+':
        return operand1 + operand2;
      case '-':
        return operand1 - operand2;
      case '*':
        return operand1 * operand2;
      case '/':
        if (operand2 == 0) {
          throw Exception("Cannot divide by zero");
        }
        return operand1 / operand2;
      default:
        throw Exception("Invalid operator");
    }
  }
}
