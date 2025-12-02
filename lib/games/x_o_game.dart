import 'package:flutter/material.dart';

class PlayerNamesScreen extends StatelessWidget {
  final TextEditingController player1Controller = TextEditingController();
  final TextEditingController player2Controller = TextEditingController();

  PlayerNamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter Player Names')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter names for the players:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              TextField(
                controller: player1Controller,
                decoration: InputDecoration(labelText: 'Player 1 Name'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: player2Controller,
                decoration: InputDecoration(labelText: 'Player 2 Name'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (player1Controller.text.isNotEmpty &&
                      player2Controller.text.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => TicTacToeGame(
                              player1Name: player1Controller.text,
                              player2Name: player2Controller.text,
                            ),
                      ),
                    );
                  }
                },
                child: Text('Start Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// لعبة "Tic Tac Toe"
class TicTacToeGame extends StatefulWidget {
  final String player1Name;
  final String player2Name;

   TicTacToeGame({super.key, required this.player1Name, required this.player2Name});

  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  List<List<String>> _board = [
    ['', '', ''],
    ['', '', ''],
    ['', '', ''],
  ];
  bool _isXTurn = true;
  int _player1Score = 0;
  int _player2Score = 0;

  void _makeMove(int row, int col) {
    if (_board[row][col].isEmpty) {
      setState(() {
        _board[row][col] = _isXTurn ? 'X' : 'O';
        _isXTurn = !_isXTurn;
        _checkWinner();
      });
    }
  }

  void _checkWinner() {
    // تحقق من الفائز
    for (int i = 0; i < 3; i++) {
      if (_board[i][0] == _board[i][1] &&
          _board[i][1] == _board[i][2] &&
          _board[i][0] != '') {
        _showWinnerDialog(_board[i][0]);
        return;
      }
      if (_board[0][i] == _board[1][i] &&
          _board[1][i] == _board[2][i] &&
          _board[0][i] != '') {
        _showWinnerDialog(_board[0][i]);
        return;
      }
    }
    if (_board[0][0] == _board[1][1] &&
        _board[1][1] == _board[2][2] &&
        _board[0][0] != '') {
      _showWinnerDialog(_board[0][0]);
      return;
    }
    if (_board[0][2] == _board[1][1] &&
        _board[1][1] == _board[2][0] &&
        _board[0][2] != '') {
      _showWinnerDialog(_board[0][2]);
      return;
    }
  }

  void _showWinnerDialog(String winner) {
    String winnerName = winner == 'X' ? widget.player1Name : widget.player2Name;
    if (winner == 'X') {
      _player1Score++;
    } else {
      _player2Score++;
    }
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Game Over'),
            content: Text('$winnerName wins!'),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _board = [
                      ['', '', ''],
                      ['', '', ''],
                      ['', '', ''],
                    ];
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Play Again'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tic Tac Toe')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${widget.player1Name}: $_player1Score',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '${widget.player2Name}: $_player2Score',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            for (int i = 0; i < 3; i++)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int j = 0; j < 3; j++)
                    GestureDetector(
                      onTap: () => _makeMove(i, j),
                      child: Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent[100],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(blurRadius: 4.0, color: Colors.black26),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _board[i][j],
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            SizedBox(height: 20),
            Text(
              _isXTurn
                  ? '${widget.player1Name}\'s turn'
                  : '${widget.player2Name}\'s turn',
              style: TextStyle(fontSize: 20, color: Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }
}
