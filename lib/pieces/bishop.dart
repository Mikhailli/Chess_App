import 'package:chess/pieces/chess_piece.dart';
import 'package:collection/collection.dart';

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

  List<Location> _generateMovesOnDiagonal(bool isUp, bool isRight, List<ChessPiece> pieces) {
    bool obstructed = false;

    var list = List<Location?>.generate(8, (i) {
      if (obstructed) return null;

      int dx = (isRight ? 1: -1) * i;
      int dy = (isUp ? 1 : -1) * i;

      final destination = Location(x + dx, y + dy);

      final pieceOnLocation =
          pieces.any((piece) => piece.location == destination);
      if (pieceOnLocation && location != destination) {
        obstructed = true;
        return null;
      }

      return destination;
    })
        .whereType<Location>()
        .where((location) => location.isValid)
        .toList();

    return list;
  }

  List<Location> _generateCapturesOnDiagonal(bool isUp, bool isRight, List<ChessPiece> pieces) {
    bool hasFoundCapture = false;

    var list = List<Location?>.generate(8, (i) {
      if (hasFoundCapture) return null;

      int dx = (isRight ? 1: -1) * i;
      int dy = (isUp ? 1 : -1) * i;

      final destination = Location(x + dx, y + dy);

      final pieceOnLocation =
      pieces.any((piece) => piece.location == destination);

      final enemyPieceOnLocation =
      pieces.any((piece) => piece.location == destination && piece.playerColor != playerColor);

      if (enemyPieceOnLocation) {
        hasFoundCapture = true;
        return destination;
      }

      if (pieceOnLocation) {
        return null;
      }

      return null;
    })
        .whereType<Location>()
        .where((location) => location.isValid)
        .toList();

    return list;
  }

  @override
  List<Location> legalCaptures(List<ChessPiece> others) {
    return <Location> [
      ..._generateCapturesOnDiagonal(true, true, others),
      ..._generateCapturesOnDiagonal(false, true, others),
      ..._generateCapturesOnDiagonal(true, false, others),
      ..._generateCapturesOnDiagonal(false, false, others),
    ].toList();
  }
}