import 'package:flutter/material.dart';

import 'widgets/piece.dart';

class DeadPiece extends StatelessWidget {
  const DeadPiece({super.key, required this.piece});

  final Piece piece;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      piece.imagePath,
      color: piece.isWhite ? Colors.white : Colors.black,
    );
  }
}
