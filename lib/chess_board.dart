import 'package:chess/widgets/box.dart';
import 'package:chess/widgets/piece.dart';
import 'package:flutter/material.dart';

import 'dead_piece.dart';
import 'functions/methods.dart';

class ChessBoard extends StatefulWidget {
  const ChessBoard({super.key});

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  ///Game Board
  late List<List<Piece?>> board;

  /// selected piece
  Piece? selectedPiece;

  int selectedRow = -1;
  int selectedCol = -1;

  /// valid moves for selected piece
  List<List<int>> validMoves = [];

  /// list of pieces taken
  // black pieces
  List<Piece> blackPiecesTaken = [];
  // white pieces
  List<Piece> whitePiecesTaken = [];

  /// Turn
  bool isWhiteTurn = true;

  /// King position
  List<int> whiteKingPos = [7, 3];
  List<int> blackKingPos = [0, 3];
  bool checkStatus = false;

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  /// create starting point of the game
  void _initializeBoard() {
    List<List<Piece?>> newBoard =
        List.generate(8, (index) => List.generate(8, (index) => null));

    /// Place pawns
    for (int i = 0; i < 8; i++) {
      newBoard[1][i] = Piece(
          type: PieceType.pawn, isWhite: false, imagePath: "images/pawn.png");
      newBoard[6][i] = Piece(
          type: PieceType.pawn, isWhite: true, imagePath: "images/pawn.png");
    }

    // / temp place
    // newBoard[4][4] = Piece(
    //     type: PieceType.knight, isWhite: false, imagePath: "images/king.png");

    /// place rooks
    newBoard[0][0] = Piece(
        type: PieceType.rook, isWhite: false, imagePath: "images/rook.png");
    newBoard[0][7] = Piece(
        type: PieceType.rook, isWhite: false, imagePath: "images/rook.png");
    newBoard[7][0] = Piece(
        type: PieceType.rook, isWhite: true, imagePath: "images/rook.png");
    newBoard[7][7] = Piece(
        type: PieceType.rook, isWhite: true, imagePath: "images/rook.png");

    /// place knights
    newBoard[0][1] = Piece(
        type: PieceType.knight, isWhite: false, imagePath: "images/knight.png");
    newBoard[0][6] = Piece(
        type: PieceType.knight, isWhite: false, imagePath: "images/knight.png");
    newBoard[7][1] = Piece(
        type: PieceType.knight, isWhite: true, imagePath: "images/knight.png");
    newBoard[7][6] = Piece(
        type: PieceType.knight, isWhite: true, imagePath: "images/knight.png");

    /// place bishops
    newBoard[0][2] = Piece(
        type: PieceType.bishop, isWhite: false, imagePath: "images/bishop.png");
    newBoard[0][5] = Piece(
        type: PieceType.bishop, isWhite: false, imagePath: "images/bishop.png");
    newBoard[7][2] = Piece(
        type: PieceType.bishop, isWhite: true, imagePath: "images/bishop.png");
    newBoard[7][5] = Piece(
        type: PieceType.bishop, isWhite: true, imagePath: "images/bishop.png");

    /// place queens
    newBoard[0][4] = Piece(
        type: PieceType.queen, isWhite: false, imagePath: "images/queen.png");
    newBoard[7][4] = Piece(
        type: PieceType.queen, isWhite: true, imagePath: "images/queen.png");

    /// place kings
    newBoard[0][3] = Piece(
        type: PieceType.king, isWhite: false, imagePath: "images/king.png");
    newBoard[7][3] = Piece(
        type: PieceType.king, isWhite: true, imagePath: "images/king.png");

    board = newBoard;
  }

  /// select a piece
  void pieceSelected(int row, int col) {
    setState(() {
      /// no piece selected
      if (selectedPiece == null && board[row][col] != null) {
        if (board[row][col]!.isWhite == isWhiteTurn) {
          selectedPiece = board[row][col];
          selectedCol = col;
          selectedRow = row;
        }

        ///select another piece
      } else if (board[row][col] != null &&
          board[row][col]!.isWhite == selectedPiece!.isWhite) {
        selectedPiece = board[row][col];
        selectedCol = col;
        selectedRow = row;

        /// try to move piece
      } else if (selectedPiece != null &&
          validMoves.any((element) => element[0] == row && element[1] == col)) {
        movePiece(row, col);

        /// change turn
        isWhiteTurn = !isWhiteTurn;
      }

      /// calculate the valid moves
      validMoves =
          calculateAllPossibleMoves(selectedRow, selectedCol, selectedPiece);
    });
  }

  /// calculate available moves
  List<List<int>> calculateAllPossibleMoves(int row, int col, Piece? piece) {
    List<List<int>> candidateMoves = [];

    if (piece == null) {
      return [];
    }

    // int direction = piece.isWhite ? -1 : 1;

    switch (piece.type) {
      /// ================================== pawn  ==========================================
      case PieceType.pawn:
        //TODO: look below
        int direction = piece.isWhite ? -1 : 1;

        /// move forward one step if vacant
        if (validIndices(row + direction, col) &&
            board[row + direction][col] == null) {
          candidateMoves.add([row + direction, col]);
        }

        /// can move 2 step if at initial
        if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if (
              // validIndices(row + 2 * direction, col) &&
              board[row + 2 * direction][col] == null &&
                  board[row + direction][col] == null) {
            candidateMoves.add([row + 2 * direction, col]);
          }
        }

        /// can capture diagonally
        if (validIndices(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col - 1]);
        }
        if (validIndices(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col + 1]);
        }
        break;

      /// ================================= rook =====================================
      case PieceType.rook:

        /// horizontal and vertical
        var directions = [
          [-1, 0],
          [1, 0],
          [0, -1],
          [0, 1]
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!validIndices(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              // if different color then cut
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }

        break;

      /// ================================= knight =====================================
      case PieceType.knight:
        var knightMoves = [
          [-2, -1],
          [-2, 1],
          [-1, -2],
          [-1, 2],
          [1, -2],
          [1, 2],
          [2, -1],
          [2, 1]
        ];

        for (var move in knightMoves) {
          int newRow = row + move[0];
          int newCol = col + move[1];
          if (validIndices(newRow, newCol)) {
            if (board[newRow][newCol] == null ||
                board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]);
            }
          }
        }

        break;

      /// ================================= bishop =====================================
      case PieceType.bishop:

        // moves diagonally
        var directions = [
          [-1, -1],
          [-1, 1],
          [1, -1],
          [1, 1]
        ];

        for (var direction in directions) {
          var i = 1;
          while (true) {
            int newRow = row + i * direction[0];
            int newCol = col + i * direction[1];
            if (!validIndices(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              // if different color then cut
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;

      /// ================================= queen =====================================
      case PieceType.queen:
        // all directions horizontal , vertical, diagonal
        var directions = [
          [-1, -1],
          [-1, 1],
          [1, -1],
          [1, 1],
          [-1, 0],
          [1, 0],
          [0, -1],
          [0, 1]
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            int newRow = row + i * direction[0];
            int newCol = col + i * direction[1];
            if (!validIndices(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              // if different color then cut
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;

      /// ================================= king =====================================
      case PieceType.king:
        var directions = [
          [-1, -1],
          [-1, 1],
          [1, -1],
          [1, 1],
          [-1, 0],
          [1, 0],
          [0, -1],
          [0, 1]
        ];
        for (var direction in directions) {
          int newRow = row + direction[0];
          int newCol = col + direction[1];
          if (!validIndices(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            // if different color then cut
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]);
            }
            continue;
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;
      default:
    }

    return candidateMoves;
  }

  /// move piece
  void movePiece(int newRow, int newCol) {
    // a piece taken down
    if (board[newRow][newCol] != null) {
      Piece takenPiece = board[newRow][newCol]!;
      if (takenPiece.isWhite) {
        whitePiecesTaken.add(takenPiece);
      } else {
        blackPiecesTaken.add(takenPiece);
      }
    }

    /// move to new position
    // check update king position if king moved
    if (selectedPiece!.type == PieceType.king) {
      if (selectedPiece!.isWhite) {
        whiteKingPos = [newRow, newCol];
      } else {
        blackKingPos = [newRow, newCol];
      }
    }

    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;

    // check if king in under attack
    if (kingInCheck(!isWhiteTurn)) {
      checkStatus = true;
    } else {
      checkStatus = false;
    }

    /// reset selection
    setState(() {
      selectedPiece = null;
      selectedCol = -1;
      selectedRow = -1;
      validMoves = [];
    });
  }

  /// check if king is in check
  bool kingInCheck(bool isWhiteKing) {
    List<int> kingPos = isWhiteKing ? whiteKingPos : blackKingPos;

    // check if any piece can attack
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        if (board[r][c] == null || board[r][c]!.isWhite == isWhiteKing) {
          continue;
        }

        List<List<int>> pieceValidMoves =
            calculateAllPossibleMoves(r, c, board[r][c]);
        // check if king position is there in pieceValidMoves
        if (pieceValidMoves
            .any((move) => move[0] == kingPos[0] && move[1] == kingPos[1])) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.teal,
        body: Center(
          child: Row(
            children: [
              /// white pieces captured
              Expanded(
                  child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return DeadPiece(
                    piece: whitePiecesTaken[index],
                  );
                },
                itemCount: whitePiecesTaken.length,
              )),

              /// game status
              Text(checkStatus ? 'Check!' : ""),

              /// chess Board
              SizedBox(
                width: MediaQuery.of(context).size.shortestSide,
                child: GridView.builder(
                  itemCount: 8 * 8,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8),
                  itemBuilder: (context, index) {
                    int row = index ~/ 8;
                    int col = index % 8;

                    /// check if selected
                    bool isSelected = selectedRow == row && selectedCol == col;

                    /// check if valid move
                    bool isValidMove = false;
                    for (var pos in validMoves) {
                      if (pos[0] == row && pos[1] == col) {
                        isValidMove = true;
                      }
                    }
                    return Box(
                      isWhite: isWhite(index),
                      piece: board[row][col],
                      isSelected: isSelected,
                      onTap: () => pieceSelected(row, col),
                      isValidMove: isValidMove,
                    );
                  },
                ),
              ),

              /// black pieces captured
              Expanded(
                  child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return DeadPiece(
                    piece: blackPiecesTaken[index],
                  );
                },
                itemCount: blackPiecesTaken.length,
              )),
            ],
          ),
        ));
  }
}
