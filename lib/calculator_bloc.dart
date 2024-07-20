import 'package:bloc/bloc.dart';

part 'calculator_event.dart';
part 'calculator_state.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  CalculatorBloc() : super(CalculatorInitialState());

  @override
  Stream<CalculatorState> mapEventToState(CalculatorEvent event) async* {
    if (event is CalculatorOperationEvent) {
      yield _mapOperationToState(event);
    }
  }

  CalculatorState _mapOperationToState(CalculatorOperationEvent event) {
    final operatorIndex = event.expression.indexOf(RegExp(r'[+\-*/]', caseSensitive: false));
    if (operatorIndex == -1) {
      throw Exception("Invalid expression");
    }

    // Extract operator
    final operator = event.expression[operatorIndex];

    // Extract operands
    final operand1 = double.parse(event.expression.substring(0, operatorIndex));
    final operand2 = double.parse(event.expression.substring(operatorIndex + 1));

    // Perform operation
    double result;
    switch (operator) {
      case '+':
        result = operand1 + operand2;
        break;
      case '-':
        result = operand1 - operand2;
        break;
      case '*':
        result = operand1 * operand2;
        break;
      case '/':
        if (operand2 == 0) {
          throw Exception("Cannot divide by zero");
        }
        result = operand1 / operand2;
        break;
      default:
        throw Exception("Invalid operator");
    }

    return CalculatorResultState(result);
  }
}
