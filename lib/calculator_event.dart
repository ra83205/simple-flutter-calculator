abstract class CalculatorEvent {}

class AddNumber extends CalculatorEvent {
  final String number;
  AddNumber(this.number);
}

class AddOperator extends CalculatorEvent {
  final String operator;
  AddOperator(this.operator);
}

class Calculate extends CalculatorEvent {}

class Clear extends CalculatorEvent {}

class ChangeSign extends CalculatorEvent {}

class Percentage extends CalculatorEvent {}
