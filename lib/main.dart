import 'package:flutter/material.dart';

import 'chess_board.dart';

void main() {
  runApp(const ChessGame());
}

class ChessGame extends StatelessWidget {
  const ChessGame({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChessBoard(),
    );
  }
}
