import 'package:chess/pieces/chess_piece.dart';

class Bishop extends ChessPiece {
  Bishop(
      PlayerColor pieceColor,
      Location location,
      ) : super(pieceColor, location);

  @override
  List<Location> legalMoves(List<ChessPiece> others) {
    return <Location> [
      ..._generateMovesOnDiagonal(true, true, others),
      ..._generateMovesOnDiagonal(false, true, others),
      ..._generateMovesOnDiagonal(true, false, others),
      ..._generateMovesOnDiagonal(false, false, others),
    ].toList();
  }

  @override
  String get name => "bishop";

  List<Location> _generateMovesOnDiagonal(bool isUp, bool isRight, List<ChessPiece> others) {
    bool obstructed = false;

    return List<Location?>.generate(8, (i) {
      int dx = isRight ? 1: -1;
      int dy = isUp ? 1 : -1;

      final position = Location(x + dx, y + dy);

      final pieceOnLocation =
          others.any((piece) => piece.location == position);
      if (pieceOnLocation) {
        obstructed = true;
      }

      return obstructed ? null : position;
    })
        .whereType<Location>()
        .where((location) => location.isValid)
        .toList();
  }
}