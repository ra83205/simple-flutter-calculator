abstract class CalculatorState {
  final String display;
  CalculatorState(this.display);
}

class CalculatorInitialState extends CalculatorState {
  CalculatorInitialState() : super("0");
}

class CalculatorResultState extends CalculatorState {
  CalculatorResultState(String result) : super(result);
}

class CalculatorErrorState extends CalculatorState {
  final String errorMessage;
  CalculatorErrorState(this.errorMessage) : super(errorMessage);
}
