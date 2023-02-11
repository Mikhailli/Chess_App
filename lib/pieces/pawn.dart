import 'package:chess/pieces/chess_piece.dart';
import 'package:collection/collection.dart';

class Pawn extends ChessPiece {
  Pawn(
      PlayerColor pieceColor,
      Location location,
      ) : super(pieceColor, location);

  @override
  List<Location> legalMoves(List<ChessPiece> others) {
    return <Location> [
      ..._generateMovesOnVertical(others),
      ..._generateMovesOnVertical(others),
    ].toList();
  }

  @override
  String get name => "pawn";

  var previousMoveIsTwoSquareMove = false;
  var previousMoveIsEnPassion = false;

  List<Location> _generateMovesOnVertical(List<ChessPiece> pieces) {
    bool obstructed = false;

    var list = List<Location?>.generate(3, (i) {
      if (obstructed) return null;

      int dy = (playerColor == PlayerColor.white ? 1 : -1) * i;

      final destination = Location(x, y + dy);

      final pieceOnLocation =
      pieces.any((piece) => piece.location == destination);

      if (pieceOnLocation && location != destination) {
        obstructed = true;
        return null;
      }

      // Если пешка уже ходила, то она не может сходить на два поля
      if ((dy == 2 || dy == -2) && makeFirstMove)
        {
          return null;
        }

      return destination;
    })
        .whereType<Location>()
        .where((location) => location.isValid)
        .toList();

    return list;
  }

  List<Location> _generateCapturesOnDiagonal(bool isRight, List<ChessPiece> pieces, [bool previousMoveIsTwoSquarePawnMove = false]) {

    var list = List<Location?>.generate(2, (i) {

      int dx = (isRight ? 1 : -1) * i;
      int dy = (playerColor == PlayerColor.white ? 1 : -1) * i;

      final destination = Location(x + dx, y + dy);

      final enemyPieceOnLocation =
      pieces.any((piece) => piece.location == destination && piece.playerColor != playerColor);

      if (enemyPieceOnLocation) {
        return destination;
      }

      return null;
    })
        .whereType<Location>()
        .where((location) => location.isValid)
        .toList();


    // Если предыдущий ход был на две клетки вперед пешкой, то ищем возможное взятие на проходе
    if (previousMoveIsTwoSquarePawnMove) {
      var enemyPawn = pieces.firstWhereOrNull((piece) =>
      piece.playerColor != playerColor && piece is Pawn &&
          piece.previousMoveIsTwoSquareMove);

      Location? tileForEnPassion;

      if (enemyPawn != null) {
        if (Location(enemyPawn.x + 1, enemyPawn.y) == location || Location(enemyPawn.x - 1, enemyPawn.y) == location) {
          int dy = playerColor == PlayerColor.white ? 1: -1;
          tileForEnPassion = Location(enemyPawn.x, enemyPawn.y + dy);
        }
      }

      if (tileForEnPassion != null) {
        list.add(tileForEnPassion);
      }
    }

    return list;
  }

  @override
  List<Location> legalCaptures(List<ChessPiece> others, [bool previousMoveIsEnPassion = false]) {
    return <Location> [
      ..._generateCapturesOnDiagonal(true, others, previousMoveIsEnPassion),
      ..._generateCapturesOnDiagonal(false, others, previousMoveIsEnPassion),
    ].toList();
  }
}