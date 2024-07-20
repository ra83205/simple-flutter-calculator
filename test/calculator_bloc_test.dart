import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_calculator3_app/calculator_bloc.dart';
import 'package:flutter_calculator3_app/calculator_event.dart';
import 'package:flutter_calculator3_app/calculator_state.dart';

void main() {
  group('CalculatorBloc', () {
    late CalculatorBloc calculatorBloc;

    setUp(() {
      calculatorBloc = CalculatorBloc();
    });

    tearDown(() {
      calculatorBloc.close();
    });

    test('initial state is CalculatorInitialState', () {
      expect(calculatorBloc.state, isA<CalculatorInitialState>());
      expect(calculatorBloc.state.display, equals('0'));
    });

    blocTest<CalculatorBloc, CalculatorState>(
      'emits [CalculatorResultState] when AddNumber is added',
      build: () => calculatorBloc,
      act: (bloc) => bloc.add(AddNumber('5')),
      expect: () => [CalculatorResultState('5')],
    );

    blocTest<CalculatorBloc, CalculatorState>(
      'emits [CalculatorResultState] when AddOperator is added',
      build: () => calculatorBloc,
      act: (bloc) => bloc.add(AddOperator('+')),
      expect: () => [CalculatorResultState('+')],
    );

    blocTest<CalculatorBloc, CalculatorState>(
      'emits [CalculatorResultState] when Calculate is added',
      build: () => calculatorBloc,
      act: (bloc) {
        bloc.add(AddNumber('5'));
        bloc.add(AddOperator('+'));
        bloc.add(AddNumber('3'));
        bloc.add(Calculate());
      },
      expect: () => [
        CalculatorResultState('5'),
        CalculatorResultState('5+'),
        CalculatorResultState('5+3'),
        CalculatorResultState('8.0'),
      ],
    );

    blocTest<CalculatorBloc, CalculatorState>(
      'emits [CalculatorInitialState] when Clear is added',
      build: () => calculatorBloc,
      act: (bloc) {
        bloc.add(AddNumber('5'));
        bloc.add(Clear());
      },
      expect: () => [
        CalculatorResultState('5'),
        CalculatorInitialState(),
      ],
    );

    blocTest<CalculatorBloc, CalculatorState>(
      'emits [CalculatorResultState] when ChangeSign is added',
      build: () => calculatorBloc,
      act: (bloc) {
        bloc.add(AddNumber('5'));
        bloc.add(ChangeSign());
      },
      expect: () => [
        CalculatorResultState('5'),
        CalculatorResultState('-5'),
      ],
    );

    blocTest<CalculatorBloc, CalculatorState>(
      'emits [CalculatorResultState] when Percentage is added',
      build: () => calculatorBloc,
      act: (bloc) {
        bloc.add(AddNumber('50'));
        bloc.add(Percentage());
      },
      expect: () => [
        CalculatorResultState('50'),
        CalculatorResultState('0.5'),
      ],
    );

    blocTest<CalculatorBloc, CalculatorState>(
      'emits [CalculatorResultState] when SquareRoot is added',
      build: () => calculatorBloc,
      act: (bloc) {
        bloc.add(AddNumber('9'));
        bloc.add(SquareRoot());
      },
      expect: () => [
        CalculatorResultState('9'),
        CalculatorResultState('3.0'),
      ],
    );

    blocTest<CalculatorBloc, CalculatorState>(
      'emits [CalculatorResultState] when Square is added',
      build: () => calculatorBloc,
      act: (bloc) {
        bloc.add(AddNumber('3'));
        bloc.add(Square());
      },
      expect: () => [
        CalculatorResultState('3'),
        CalculatorResultState('9.0'),
      ],
    );

    blocTest<CalculatorBloc, CalculatorState>(
      'emits [CalculatorResultState] when Reciprocal is added',
      build: () => calculatorBloc,
      act: (bloc) {
        bloc.add(AddNumber('2'));
        bloc.add(Reciprocal());
      },
      expect: () => [
        CalculatorResultState('2'),
        CalculatorResultState('0.5'),
      ],
    );

    blocTest<CalculatorBloc, CalculatorState>(
      'emits [CalculatorErrorState] when dividing by zero',
      build: () => calculatorBloc,
      act: (bloc) {
        bloc.add(AddNumber('1'));
        bloc.add(AddOperator('/'));
        bloc.add(AddNumber('0'));
        bloc.add(Calculate());
      },
      expect: () => [
        CalculatorResultState('1'),
        CalculatorResultState('1/'),
        CalculatorResultState('1/0'),
        CalculatorErrorState('Exception: Cannot divide by zero'),
      ],
    );
  });
}
