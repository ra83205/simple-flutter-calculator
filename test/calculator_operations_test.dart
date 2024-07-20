import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_calculator3_app/calculator_operations.dart';

void main() {
  group('AdditionOperation', () {
    test('should correctly add two numbers', () {
      final operation = AdditionOperation();
      expect(operation.apply('1+2'), '3.0');
    });

    test('should correctly add multiple numbers', () {
      final operation = AdditionOperation();
      expect(operation.apply('1+2+3+4'), '10.0');
    });
  });

  group('SubtractionOperation', () {
    test('should correctly subtract two numbers', () {
      final operation = SubtractionOperation();
      expect(operation.apply('4-2'), '2.0');
    });

    test('should correctly subtract multiple numbers', () {
      final operation = SubtractionOperation();
      expect(operation.apply('10-2-3'), '5.0');
    });
  });

  group('MultiplicationOperation', () {
    test('should correctly multiply two numbers', () {
      final operation = MultiplicationOperation();
      expect(operation.apply('3*2'), '6.0');
    });

    test('should correctly multiply multiple numbers', () {
      final operation = MultiplicationOperation();
      expect(operation.apply('2*3*4'), '24.0');
    });
  });

  group('DivisionOperation', () {
    test('should correctly divide two numbers', () {
      final operation = DivisionOperation();
      expect(operation.apply('6/2'), '3.0');
    });

    test('should throw exception for division by zero', () {
      final operation = DivisionOperation();
      expect(() => operation.apply('6/0'), throwsException);
    });

    test('should throw exception for invalid division expression', () {
      final operation = DivisionOperation();
      expect(() => operation.apply('6/2/3'), throwsException);
    });
  });

  group('SquareRootOperation', () {
    test('should correctly calculate square root', () {
      final operation = SquareRootOperation();
      expect(operation.apply('9'), '3.0');
    });

    test('should throw exception for negative number', () {
      final operation = SquareRootOperation();
      expect(() => operation.apply('-1'), throwsException);
    });
  });

  group('SquareOperation', () {
    test('should correctly calculate square', () {
      final operation = SquareOperation();
      expect(operation.apply('3'), '9.0');
    });
  });

  group('ReciprocalOperation', () {
    test('should correctly calculate reciprocal', () {
      final operation = ReciprocalOperation();
      expect(operation.apply('2'), '0.5');
    });

    test('should throw exception for zero', () {
      final operation = ReciprocalOperation();
      expect(() => operation.apply('0'), throwsException);
    });
  });

  group('PercentageOperation', () {
    test('should correctly calculate percentage', () {
      final operation = PercentageOperation();
      expect(operation.apply('50'), '0.5');
    });
  });
}
