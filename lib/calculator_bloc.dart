import 'package:bloc/bloc.dart';
import 'calculator_event.dart';
import 'calculator_state.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  String _expression = "";

  CalculatorBloc() : super(CalculatorInitialState());

  @override
  void on<AddNumber>(
    AddNumber event,
    Emitter<CalculatorState> emit,
  ) {
    _expression += event.number;
    emit(CalculatorResultState(_expression));
  }

  @override
  void on<AddOperator>(
    AddOperator event,
    Emitter<CalculatorState> emit,
  ) {
    _expression += event.operator;
    emit(CalculatorResultState(_expression));
  }

  @override
  void on<Calculate>(
    Calculate event,
    Emitter<CalculatorState> emit,
  ) {
    try {
      final result = _calculateResult(_expression);
      emit(CalculatorResultState(result.toString()));
    } catch (e) {
      emit(CalculatorErrorState(e.toString()));
    }
  }

  @override
  void on<Clear>(
    Clear event,
    Emitter<CalculatorState> emit,
  ) {
    _expression = "";
    emit(CalculatorInitialState());
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
