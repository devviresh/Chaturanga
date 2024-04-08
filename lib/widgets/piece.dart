enum PieceType { pawn, rook, knight, bishop, queen, king }

class Piece {
  final PieceType type;
  final bool isWhite;
  final String imagePath;

  Piece({required this.type, required this.isWhite, required this.imagePath});
}
