import 'package:bloc/bloc.dart';
import 'dart:math';
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
    on<Percentage>(_onPercentage);
    on<SquareRoot>(_onSquareRoot);
    on<Square>(_onSquare);
    on<Reciprocal>(_onReciprocal);
  }

  void _onAddNumber(AddNumber event, Emitter<CalculatorState> emit) {
    _expression += event.number;
    emit(CalculatorResultState(_expression));
  }

  void _onAddOperator(AddOperator event, Emitter<CalculatorState> emit) {
    _expression += event.operator;
    emit(CalculatorResultState(_expression));
  }

  void _onCalculate(Calculate event, Emitter<CalculatorState> emit) {
    try {
      final result = _calculateResult(_expression);
      _lastResult = double.parse(result);
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

  void _onPercentage(Percentage event, Emitter<CalculatorState> emit) {
    _applyOperation('%', emit);
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
      final value = _lastResult?.toString() ?? _expression;
      final result = _operations[operation]!.apply(value);
      _lastResult = double.parse(result);
      _expression = result;
      emit(CalculatorResultState(_expression));
    } catch (e) {
      emit(CalculatorErrorState(e.toString()));
    }
  }

  String _calculateResult(String expression) {
    final operatorIndex = expression.indexOf(RegExp(r'[+\-*/]'));
    if (operatorIndex == -1) {
      return expression;
    }

    final operator = expression[operatorIndex];
    final operation = _operations[operator];
    if (operation == null) {
      throw Exception("Invalid operator");
    }

    return operation.apply(expression);
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
