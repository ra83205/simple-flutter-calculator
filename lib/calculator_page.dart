import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'calculator_bloc.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Calculator'),
      ),
      body: Column(
        children: [
          BlocBuilder<CalculatorBloc, CalculatorState>(
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.centerRight,
                child: Text(
                  state.display,
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              children: [
                _buildButton(context, '7'),
                _buildButton(context, '8'),
                _buildButton(context, '9'),
                _buildButton(context, '/'),
                _buildButton(context, '4'),
                _buildButton(context, '5'),
                _buildButton(context, '6'),
                _buildButton(context, '*'),
                _buildButton(context, '1'),
                _buildButton(context, '2'),
                _buildButton(context, '3'),
                _buildButton(context, '-'),
                _buildButton(context, '0'),
                _buildButton(context, '.'),
                _buildButton(context, '='),
                _buildButton(context, '+'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => context.read<CalculatorBloc>().add(Clear()),
              child: const Text('Clear'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: () {
          final bloc = context.read<CalculatorBloc>();
          if (label == '=') {
            bloc.add(Calculate());
          } else if ('+-*/'.contains(label)) {
            bloc.add(AddOperator(label));
          } else {
            bloc.add(AddNumber(label));
          }
        },
        child: Text(label, style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}
