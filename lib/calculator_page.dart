import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'calculator_bloc.dart';
import 'calculator_event.dart';
import 'calculator_state.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.pushNamed(context, '/config');
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<CalculatorBloc, CalculatorState>(
                builder: (context, state) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.bottomRight,
                    child: Text(
                      state.display,
                      style: const TextStyle(fontSize: 72, fontWeight: FontWeight.w300),
                    ),
                  );
                },
              ),
            ),
            Container(
              color: const Color(0xFFF1F2F3),
              child: Column(
                children: [
                  _buildButtonRow(context, ['C', '+/-', '%', '÷']),
                  _buildButtonRow(context, ['√', 'x²', '1/x', '×']),
                  _buildButtonRow(context, ['7', '8', '9', '-']),
                  _buildButtonRow(context, ['4', '5', '6', '+']),
                  _buildButtonRow(context, ['1', '2', '3', '=']),
                  _buildButtonRow(context, ['0', '.']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonRow(BuildContext context, List<String> buttons) {
    return Row(
      children: buttons.map((button) => _buildButton(context, button)).toList(),
    );
  }

  Widget _buildButton(BuildContext context, String label) {
    final isWide = label == '0';
    final isOperator = '÷×-+='.contains(label);
    final isFunction = 'C+/-%√x²1/x'.contains(label);

    return Expanded(
      flex: isWide ? 2 : 1,
      child: Container(
        height: 80,
        margin: const EdgeInsets.all(1),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isOperator ? Colors.orange : (isFunction ? const Color(0xFFD4D4D2) : Colors.white),
            foregroundColor: isOperator || isFunction ? Colors.white : Colors.black,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          onPressed: () {
            final bloc = context.read<CalculatorBloc>();
            switch (label) {
              case 'C':
                bloc.add(Clear());
                break;
              case '+/-':
                bloc.add(ChangeSign());
                break;
              case '%':
                bloc.add(Percentage());
                break;
              case '÷':
                bloc.add(AddOperator('/'));
                break;
              case '×':
                bloc.add(AddOperator('*'));
                break;
              case '=':
                bloc.add(Calculate());
                break;
              case '√':
                bloc.add(SquareRoot());
                break;
              case 'x²':
                bloc.add(Square());
                break;
              case '1/x':
                bloc.add(Reciprocal());
                break;
              default:
                if ('+-'.contains(label)) {
                  bloc.add(AddOperator(label));
                } else {
                  bloc.add(AddNumber(label));
                }
            }
          },
          child: Text(
            label,
            style: TextStyle(fontSize: isWide ? 30 : 24, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}
