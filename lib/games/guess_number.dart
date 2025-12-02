// لعبة "Guess the Number"
import 'dart:math';

import 'package:flutter/material.dart';

class GuessNumberGame extends StatefulWidget {
  const GuessNumberGame({super.key});

  @override
  _GuessNumberGameState createState() => _GuessNumberGameState();
}

class _GuessNumberGameState extends State<GuessNumberGame> {
  final _controller = TextEditingController();
  final int _targetNumber = Random().nextInt(101) ;

  String _message = '';
  Color _messageColor = Colors.black;

  void _checkGuess() {
    final guess = int.tryParse(_controller.text);
    if (guess == null) {
      setState(() {
        _message = 'Please enter a valid number';
        _messageColor = Colors.red;
      });
    } else if (guess == _targetNumber) {
      setState(() {
        _message = 'Congratulations! You guessed the number!';
        _messageColor = Colors.green;
      });
    } else if (guess < _targetNumber) {
      setState(() {
        _message = 'Too low! Try again.';
        _messageColor = Colors.orange;
      });
    } else {
      setState(() {
        _message = 'Too high! Try again.';
        _messageColor = Colors.orange;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Guess the Number')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Guess a number between 1 and 100',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter your guess',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkGuess,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text('Guess', style: TextStyle(fontSize: 20)),
            ),
            SizedBox(height: 20),
            Text(
              _message,
              style: TextStyle(fontSize: 22, color: _messageColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
