import 'package:chess/constants/app_colors.dart';
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
    if (isSelected) {
      boxColor = Colors.green;
    } else if (isValidMove) {
      if (piece != null) {
        boxColor = Colors.red;
      } else {
        boxColor = Colors.green;
      }
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: isSelected ? 2 : 0),
          color: isWhite ? light : dark,
        ),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: boxColor != null
                ? [
                    BoxShadow(
                      color: boxColor,
                    ),
                    BoxShadow(
                      color: isWhite ? light! : dark!,
                      spreadRadius: -12,
                      blurRadius: 10,
                    ),
                  ]
                : null,
          ),
          child: piece != null
              ? Image.asset(piece!.imagePath,
                  color: piece!.isWhite ? Colors.white : Colors.black)
              : null,
        ),
      ),
    );
  }
}
