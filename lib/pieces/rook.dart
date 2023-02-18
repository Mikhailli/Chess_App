import 'package:chess/pieces/chess_piece.dart';

class Rook extends ChessPiece {
  Rook(
      PlayerColor pieceColor,
      Location location,
      ) : super(pieceColor, location);

  @override
  List<Location> legalMoves(List<ChessPiece> others) {
    return <Location> [
      ..._generateMovesOnVertical(true, others),
      ..._generateMovesOnVertical(false, others),
      ..._generateMovesOnHorizontal(true, others),
      ..._generateMovesOnHorizontal(false, others),
    ].toList();
  }

  @override
  String get name => "rook";

  List<Location> _generateMovesOnHorizontal(bool isRight, List<ChessPiece> pieces) {
    bool obstructed = false;

    var list = List<Location?>.generate(8, (i) {
      if (obstructed) return null;

      int dx = (isRight ? 1 : -1) * i;

      final destination = Location(x + dx, y);

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

  List<Location> _generateMovesOnVertical(bool isUp, List<ChessPiece> pieces) {
    bool obstructed = false;

    var list = List<Location?>.generate(8, (i) {
      if (obstructed) return null;

      int dy = (isUp ? 1 : -1) * i;

      final destination = Location(x, y + dy);

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

  List<Location> _generateCapturesOnHorizontal(bool isRight, List<ChessPiece> pieces) {
    bool hasFoundCapture = false;
    bool obstructed = false;

    var list = List<Location?>.generate(8, (i) {
      if (hasFoundCapture) return null;
      if (obstructed) return null;

      int dx = (isRight ? 1 : -1) * i;

      final destination = Location(x + dx, y);

      final friendlyPieceOnLocation =
      pieces.any((piece) => piece.location == destination && piece.playerColor == playerColor);

      final enemyPieceOnLocation =
      pieces.any((piece) => piece.location == destination && piece.playerColor != playerColor);

      if (enemyPieceOnLocation) {
        hasFoundCapture = true;
        return destination;
      }

      if (friendlyPieceOnLocation && location != destination) {
        obstructed = true;
      }

      return null;
    })
        .whereType<Location>()
        .where((location) => location.isValid)
        .toList();

    return list;
  }

  List<Location> _generateCapturesOnVertical(bool isUp, List<ChessPiece> pieces) {
    bool hasFoundCapture = false;
    bool obstructed = false;

    var list = List<Location?>.generate(8, (i) {
      if (hasFoundCapture) return null;
      if (obstructed) return null;

      int dy = (isUp ? 1 : -1) * i;

      final destination = Location(x, y + dy);

      final friendlyPieceOnLocation =
      pieces.any((piece) => piece.location == destination && piece.playerColor == playerColor);

      final enemyPieceOnLocation =
      pieces.any((piece) => piece.location == destination && piece.playerColor != playerColor);

      if (enemyPieceOnLocation) {
        hasFoundCapture = true;
        return destination;
      }

      if (friendlyPieceOnLocation && location != destination) {
        obstructed = true;
      }

      return null;
    })
        .whereType<Location>()
        .where((location) => location.isValid)
        .toList();

    return list;
  }

  @override
  List<Location> legalCaptures(List<ChessPiece> others, [bool previousMoveIsEnPassion = false]) {
    return <Location> [
      ..._generateCapturesOnVertical(true, others),
      ..._generateCapturesOnVertical(false, others),
      ..._generateCapturesOnHorizontal(true, others),
      ..._generateCapturesOnHorizontal(false, others),
    ].toList();
  }
}