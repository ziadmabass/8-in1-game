import 'package:flutter/material.dart';

class PlayerInputScreen extends StatefulWidget {
  const PlayerInputScreen({super.key});

  @override
  _PlayerInputScreenState createState() => _PlayerInputScreenState();
}

class _PlayerInputScreenState extends State<PlayerInputScreen> {
  final _player1Controller = TextEditingController();
  final _player2Controller = TextEditingController();

  void _startGame() {
    final player1 = _player1Controller.text.trim();
    final player2 = _player2Controller.text.trim();

    if (player1.isEmpty || player2.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConnectFourGame(player1: player1, player2: player2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enter Player Names")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _player1Controller,
              decoration: InputDecoration(labelText: "Player 1 (Red)"),
            ),
            TextField(
              controller: _player2Controller,
              decoration: InputDecoration(labelText: "Player 2 (Yellow)"),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _startGame, child: Text("Start Game")),
          ],
        ),
      ),
    );
  }
}

class ConnectFourGame extends StatefulWidget {
  final String player1;
  final String player2;

  const ConnectFourGame({super.key, required this.player1, required this.player2});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<ConnectFourGame> {
  static const int rows = 6;
  static const int cols = 7;
  List<List<int>> board = List.generate(rows, (_) => List.filled(cols, 0));
  int currentPlayer = 1; // 1: Player 1 (Red), 2: Player 2 (Yellow)
  String winner = '';

  void resetBoard() {
    setState(() {
      board = List.generate(rows, (_) => List.filled(cols, 0));
      currentPlayer = 1;
      winner = '';
    });
  }

  void dropDisc(int col) {
    if (winner.isNotEmpty) return;

    for (int row = rows - 1; row >= 0; row--) {
      if (board[row][col] == 0) {
        setState(() {
          board[row][col] = currentPlayer;
          if (checkWin(row, col)) {
            winner = currentPlayer == 1 ? widget.player1 : widget.player2;
          } else {
            currentPlayer = currentPlayer == 1 ? 2 : 1;
          }
        });
        break;
      }
    }
  }

  bool checkWin(int row, int col) {
    int player = board[row][col];
    return checkDirection(row, col, 1, 0, player) || // Horizontal
        checkDirection(row, col, 0, 1, player) || // Vertical
        checkDirection(row, col, 1, 1, player) || // Diagonal /
        checkDirection(row, col, 1, -1, player); // Diagonal \
  }

  bool checkDirection(int row, int col, int dRow, int dCol, int player) {
    int count = 1;

    for (int i = 1; i < 4; i++) {
      int r = row + dRow * i;
      int c = col + dCol * i;
      if (r < 0 || r >= rows || c < 0 || c >= cols || board[r][c] != player)
        break;
      count++;
    }

    for (int i = 1; i < 4; i++) {
      int r = row - dRow * i;
      int c = col - dCol * i;
      if (r < 0 || r >= rows || c < 0 || c >= cols || board[r][c] != player)
        break;
      count++;
    }

    return count >= 4;
  }

  Color getPlayerColor(int player) {
    switch (player) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.yellow;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connect Four"),
        actions: [IconButton(onPressed: resetBoard, icon: Icon(Icons.refresh))],
      ),
      body: Column(
        children: [
          if (winner.isEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${currentPlayer == 1 ? widget.player1 : widget.player2}'s Turn",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          if (winner.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "$winner Wins!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
              ),
              itemCount: rows * cols,
              itemBuilder: (context, index) {
                int row = index ~/ cols;
                int col = index % cols;
                return GestureDetector(
                  onTap: () => dropDisc(col),
                  child: Container(
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: getPlayerColor(board[row][col]),
                      border: Border.all(color: Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
