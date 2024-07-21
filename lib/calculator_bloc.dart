import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'calculator_event.dart';
import 'calculator_state.dart';
import 'calculator_operations.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  String _expression = "";
  double? _lastResult;
  final Map<String, CalculatorOperation> _operations = {
    '+': AdditionOperation(),
    '-': SubtractionOperation(),
    '*': MultiplicationOperation(),
    '/': DivisionOperation(),
    'sqrt': SquareRootOperation(),
    'square': SquareOperation(),
    'reciprocal': ReciprocalOperation(),
    '%': PercentageOperation(),
  };

  CalculatorBloc() : super(CalculatorInitialState()) {
    _loadLastResult();
    on<AddNumber>(_onAddNumber);
    on<AddOperator>(_onAddOperator);
    on<Calculate>(_onCalculate);
    on<Clear>(_onClear);
    on<ChangeSign>(_onChangeSign);
    // on<Percentage>(_onPercentage); // Удалено
    on<SquareRoot>(_onSquareRoot);
    on<Square>(_onSquare);
    on<Reciprocal>(_onReciprocal);
  }

  void _onAddNumber(AddNumber event, Emitter<CalculatorState> emit) {
    _expression += event.number;
    emit(CalculatorResultState(_expression));
    _lastResult = null;
  }

  void _onAddOperator(AddOperator event, Emitter<CalculatorState> emit) {
    if (_lastResult != null) {
      _expression = _lastResult.toString() + event.operator;
      _lastResult = null;
    } else {
      _expression += event.operator; // % добавляется как оператор
    }
    emit(CalculatorResultState(_expression));
  }

  void _onCalculate(Calculate event, Emitter<CalculatorState> emit) {
    try {
      final result = _calculateResult(_expression);

      if (!containsOperators(_expression)) {
        _lastResult = double.parse(result);
      } else {
        _lastResult = null;
      }

      _expression = result;
      emit(CalculatorResultState(result));
      _saveLastResult();
    } catch (e) {
      emit(CalculatorErrorState(e.toString()));
    }
  }

  void _onClear(Clear event, Emitter<CalculatorState> emit) {
    _expression = "";
    _lastResult = null;
    emit(CalculatorInitialState());
  }

  void _onChangeSign(ChangeSign event, Emitter<CalculatorState> emit) {
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
  }

  void _onSquareRoot(SquareRoot event, Emitter<CalculatorState> emit) {
    _applyOperation('sqrt', emit);
  }

  void _onSquare(Square event, Emitter<CalculatorState> emit) {
    _applyOperation('square', emit);
  }

  void _onReciprocal(Reciprocal event, Emitter<CalculatorState> emit) {
    _applyOperation('reciprocal', emit);
  }

  void _applyOperation(String operation, Emitter<CalculatorState> emit) {
    try {
      if (_lastResult != null && _operations[operation]!.requiresTwoOperands) {
        final result = _operations[operation]!
            .apply(_lastResult!, double.parse(_expression));
        _lastResult = result;
        _expression = result.toString();
        emit(CalculatorResultState(_expression));
      } else if (_operations[operation]!.requiresTwoOperands == false) {
        final result = _operations[operation]!.apply(double.parse(_expression));
        _lastResult = result;
        _expression = result.toString();
        emit(CalculatorResultState(_expression));
      } else {
        throw Exception("Not enough operands for this operation");
      }
    } catch (e) {
      emit(CalculatorErrorState(e.toString()));
    }
  }

  String _calculateResult(String expression) {
    return Calculator.calculate(expression).toString();
  }

  bool containsOperators(String expression) {
    return expression.contains(RegExp(r'[\+\-\*\/\%]'));
  }

  Future<void> _saveLastResult() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastResult', _lastResult?.toString() ?? '');
  }

  Future<void> _loadLastResult() async {
    final prefs = await SharedPreferences.getInstance();
    final lastResultString = prefs.getString('lastResult');
    if (lastResultString != null && lastResultString.isNotEmpty) {
      _lastResult = double.tryParse(lastResultString);
      _expression = _lastResult?.toString() ?? '';
      emit(CalculatorResultState(_expression));
    }
  }
}

class Calculator {
  static double calculate(String expression) {
    expression = expression.replaceAll(' ', '');

    List<String> tokens = [];
    String currentToken = '';
    for (int i = 0; i < expression.length; i++) {
      String char = expression[i];
      if (isOperator(char)) {
        if (currentToken.isNotEmpty) {
          tokens.add(currentToken);
        }
        tokens.add(char);
        currentToken = '';
      } else {
        currentToken += char;
      }
    }
    if (currentToken.isNotEmpty) {
      tokens.add(currentToken);
    }

    tokens = _handleMultiplicationDivision(tokens);
    tokens = _handleAdditionSubtraction(tokens);

    return double.parse(tokens[0]);
  }

  static bool isOperator(String char) {
    return ['+', '-', '*', '/', '%'].contains(char);
  }

  static List<String> _handleMultiplicationDivision(List<String> tokens) {
    List<String> result = [];
    double currentNumber = 0;
    String currentOperator = '';

    for (int i = 0; i < tokens.length; i++) {
      String token = tokens[i];

      if (isOperator(token)) {
        currentOperator = token;
      } else {
        double number = double.parse(token);
        if (currentOperator == '*' ||
            currentOperator == '/' ||
            currentOperator == '%') {
          currentNumber =
              _performOperation(currentNumber, number, currentOperator);
        } else {
          if (currentOperator.isNotEmpty) {
            result.add(currentNumber.toString());
            result.add(currentOperator);
          }
          currentNumber = number;
          currentOperator = '';
        }
      }
    }

    if (currentOperator.isNotEmpty) {
      result.add(currentNumber.toString());
      result.add(currentOperator);
    } else {
      result.add(currentNumber.toString());
    }

    return result;
  }

  static List<String> _handleAdditionSubtraction(List<String> tokens) {
    double result = 0;
    String currentOperator = '+';

    for (String token in tokens) {
      if (isOperator(token)) {
        currentOperator = token;
      } else {
        double number = double.parse(token);
        result = _performOperation(result, number, currentOperator);
      }
    }

    return [result.toString()];
  }

  static double _performOperation(double a, double b, String operator) {
    switch (operator) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '*':
        return a * b;
      case '/':
        return a / b;
      case '%':
        return a % b;
      default:
        throw ArgumentError("Неверный оператор: $operator");
    }
  }
}
