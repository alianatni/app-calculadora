import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  final String _limpar = 'Limpar tudo';
  final String _backspace = '⌫';
  String _expressao = '';
  String _resultado = '';

  void _pressionarBotao(String valor) {
    setState(() {
      if (valor == _limpar) {
        _expressao = '';
        _resultado = '';
      } else if (valor == _backspace) {
        _removerUltimoCaractere();
      } else if (valor == '=') {
        _calcularResultado();
      } else {
        _expressao += valor;
      }
    });
  }

  void _removerUltimoCaractere() {
    if (_expressao.isNotEmpty) {
      _expressao = _expressao.substring(0, _expressao.length - 1);
    }
  } 

  void _calcularResultado() {
    try {
      _resultado = _avaliarExpressao(_expressao).toString();
    } catch (e) {
      _resultado = 'Erro ao calcular a expressão';
    }
  }

  double _avaliarExpressao(String expressao) {
    expressao = expressao.replaceAll('x', '*');
    expressao = expressao.replaceAll('÷', '/');
    expressao = expressao.replaceAll('%', '/100');
    expressao = expressao.replaceAll(',', '.');
    
    expressao = expressao.replaceAllMapped(RegExp(r'(\d)(\()'), (match) {
      return '${match.group(1)}*(';
    });
    expressao = expressao.replaceAllMapped(RegExp(r'(\))(\d)'), (match) {
      return '${match.group(1)}*${match.group(2)}';
    });

    ExpressionEvaluator avaliador = const ExpressionEvaluator();
    double resultado = avaliador.eval(Expression.parse(expressao), {});
    return resultado;
  }

  Widget _botao(String valor) {
    return TextButton(
      child: Text(
        valor,
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      onPressed: () => _pressionarBotao(valor),
    );
  }

@override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _expressao,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _resultado,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: GridView.count(
            crossAxisCount: 4,
            childAspectRatio: 2,
            children: [
              _botao('('),
              _botao(')'),
              _botao('%'),
              _botao('÷'),
              _botao('7'),
              _botao('8'),
              _botao('9'),
              _botao('x'),
              _botao('4'),
              _botao('5'),
              _botao('6'),
              _botao('-'),
              _botao('1'),
              _botao('2'),
              _botao('3'),
              _botao('+'),
              _botao('0'),
              _botao(','),
              _botao(_backspace),
              _botao('='),
            ],
          ),
        ),
        Expanded(
          child: _botao(_limpar),
        )
      ],
    );
  }
}