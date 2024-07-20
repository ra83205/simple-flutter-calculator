import 'package:bloc/bloc.dart';
import 'calculator_event.dart';
import 'calculator_state.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  String _expression = "";

  CalculatorBloc() : super(CalculatorInitialState());

  @override
  Stream<CalculatorState> mapEventToState(CalculatorEvent event) async* {
    if (event is AddNumber) {
      _expression += event.number;
      yield CalculatorResultState(_expression);
    } else if (event is AddOperator) {
      _expression += event.operator;
      yield CalculatorResultState(_expression);
    } else if (event is Calculate) {
      try {
        final result = _calculateResult(_expression);
        yield CalculatorResultState(result.toString());
      } catch (e) {
        yield CalculatorErrorState(e.toString());
      }
    } else if (event is Clear) {
      _expression = "";
      yield CalculatorInitialState();
    }
  }
    if (event is AddNumber) {
      _expression += event.number;
      yield CalculatorResultState(_expression);
    } else if (event is AddOperator) {
      _expression += event.operator;
      yield CalculatorResultState(_expression);
    } else if (event is Calculate) {
      try {
        final result = _calculateResult(_expression);
        yield CalculatorResultState(result.toString());
      } catch (e) {
        yield CalculatorErrorState(e.toString());
      }
    } else if (event is Clear) {
      _expression = "";
      yield CalculatorInitialState();
    }
  }

  double _calculateResult(String expression) {
    final operatorIndex = expression.indexOf(RegExp(r'[+\-*/]', caseSensitive: false));
    if (operatorIndex == -1) {
      throw Exception("Invalid expression");
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
