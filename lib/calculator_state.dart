import 'package:equatable/equatable.dart';

abstract class CalculatorState extends Equatable {
  final String display;
  final String? lastResult;

  const CalculatorState(this.display, {this.lastResult});

  @override
  List<Object?> get props => [display, lastResult];
}

class CalculatorInitialState extends CalculatorState {
  CalculatorInitialState({String? lastResult}) : super("0", lastResult: lastResult);
}

class CalculatorResultState extends CalculatorState {
  CalculatorResultState(String result, {String? lastResult}) : super(result, lastResult: lastResult);
}

class CalculatorErrorState extends CalculatorState {
  final String errorMessage;
  CalculatorErrorState(this.errorMessage, {String? lastResult}) : super(errorMessage, lastResult: lastResult);
}
