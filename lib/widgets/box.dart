import 'package:chess/constants/colors.dart';
import 'package:chess/widgets/piece.dart';
import 'package:flutter/material.dart';

class Box extends StatelessWidget {
  const Box({
    super.key,
    required this.isWhite,
    this.piece,
    required this.isSelected,
    required this.onTap,
    required this.isValidMove,
  });
  final bool isWhite;
  final Piece? piece;
  final bool isSelected;
  final void Function()? onTap;
  final bool isValidMove;

  @override
  Widget build(BuildContext context) {
    Color? boxColor;
    if (isSelected || isValidMove) {
      boxColor = Colors.green;
    } else if (isValidMove) {
      boxColor = Colors.green[300];
    } else {
      boxColor = isWhite ? light : dark;
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: isSelected ? 5 : 0),
          color: isWhite ? light : dark,
        ),
        child: Container(
          color: boxColor,
          margin: EdgeInsets.all(isValidMove ? 8 : 0),
          child: piece != null
              ? Image.asset(piece!.imagePath,
                  color: piece!.isWhite ? Colors.white : Colors.black)
              : null,
        ),
      ),
    );
  }
}
