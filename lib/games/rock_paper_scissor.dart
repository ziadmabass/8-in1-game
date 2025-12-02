import 'dart:math';

import 'package:flutter/material.dart';

class RockPaperScissorsGame extends StatefulWidget {
  const RockPaperScissorsGame({super.key});

  @override
  _RockPaperScissorsGameState createState() => _RockPaperScissorsGameState();
}

class _RockPaperScissorsGameState extends State<RockPaperScissorsGame> {
  final _choices = ['Rock', 'Paper', 'Scissors'];
  String _playerChoice = '';
  String _computerChoice = '';
  String _result = '';

  void _playGame(String playerChoice) {
    final random = Random();
    _playerChoice = playerChoice;
    _computerChoice = _choices[random.nextInt(3)];
    if (_playerChoice == _computerChoice) {
      _result = 'It\'s a draw!';
    } else if (_playerChoice == 'Rock' && _computerChoice == 'Scissors' ||
        _playerChoice == 'Scissors' && _computerChoice == 'Paper' ||
        _playerChoice == 'Paper' && _computerChoice == 'Rock') {
      _result = 'You win!';
    } else {
      _result = 'Computer wins!';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rock Paper Scissors')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Choose Rock, Paper, or Scissors',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _choiceButton('Rock'),
                SizedBox(width: 20),
                _choiceButton('Paper'),
                SizedBox(width: 20),
                _choiceButton('Scissors'),
              ],
            ),
            SizedBox(height: 20),
            Text('Your choice: $_playerChoice', style: TextStyle(fontSize: 18)),
            Text(
              'Computer choice: $_computerChoice',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              _result,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _choiceButton(String choice) {
    return ElevatedButton(
      onPressed: () => _playGame(choice),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Text(choice, style: TextStyle(fontSize: 20)),
    );
  }
}
