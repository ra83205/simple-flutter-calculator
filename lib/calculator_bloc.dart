import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class CalculatorEvent extends Equatable {
  const CalculatorEvent();

  @override
  List<Object> get props => [];
}

class AddNumber extends CalculatorEvent {
  final String number;

  const AddNumber(this.number);

  @override
  List<Object> get props => [number];
}

class AddOperator extends CalculatorEvent {
  final String operator;

  const AddOperator(this.operator);

  @override
  List<Object> get props => [operator];
}

class Calculate extends CalculatorEvent {}

class Clear extends CalculatorEvent {}

// State
class CalculatorState extends Equatable {
  final String display;

  const CalculatorState({this.display = '0'});

  @override
  List<Object> get props => [display];
}

// BLoC
class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  CalculatorBloc() : super(const CalculatorState()) {
    on<AddNumber>(_onAddNumber);
    on<AddOperator>(_onAddOperator);
    on<Calculate>(_onCalculate);
    on<Clear>(_onClear);
  }

  void _onAddNumber(AddNumber event, Emitter<CalculatorState> emit) {
    if (state.display == '0') {
      emit(CalculatorState(display: event.number));
    } else {
      emit(CalculatorState(display: state.display + event.number));
    }
  }

  void _onAddOperator(AddOperator event, Emitter<CalculatorState> emit) {
    emit(CalculatorState(display: state.display + event.operator));
  }

  void _onCalculate(Calculate event, Emitter<CalculatorState> emit) {
    try {
      final result = eval(state.display);
      emit(CalculatorState(display: result.toString()));
    } catch (e) {
      emit(const CalculatorState(display: 'Error'));
    }
  }

  void _onClear(Clear event, Emitter<CalculatorState> emit) {
    emit(const CalculatorState());
  }

  double eval(String expression) {
    // This is a simple implementation and doesn't handle all cases
    final parts = expression.split(RegExp(r'([+\-*/])'));
    var result = double.parse(parts[0]);
    for (var i = 1; i < parts.length; i += 2) {
      final operator = expression[expression.indexOf(RegExp(r'[+\-*/]', i))];
      final operand = double.parse(parts[i + 1]);
      switch (operator) {
        case '+':
          result += operand;
          break;
        case '-':
          result -= operand;
          break;
        case '*':
          result *= operand;
          break;
        case '/':
          result /= operand;
          break;
      }
    }
    return result;
  }
}
