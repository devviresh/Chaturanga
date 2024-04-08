bool isWhite(int index) {
  int x = index ~/ 8;
  int y = index % 8;

  return (x + y) % 2 == 0;
}

bool validIndices(int row, int col) {
  return row >= 0 && row < 8 && col >= 0 && col < 8;
}
