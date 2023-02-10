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

    var list = List<Location?>.generate(8, (i) {
      int dx = (isRight ? 1: -1) * i;
      int dy = (isUp ? 1 : -1) * i;

      final destination = Location(x + dx, y + dy);

      final pieceOnLocation =
          others.any((piece) => piece.location == destination);
      if (pieceOnLocation && location != destination) {
        obstructed = true;
      }

      return obstructed ? null : destination;
    })
        .whereType<Location>()
        .where((location) => location.isValid)
        .toList();

    return list;
  }
}