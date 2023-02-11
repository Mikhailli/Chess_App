import 'package:chess/pieces/chess_piece.dart';

class Knight extends ChessPiece {
  Knight(
      PlayerColor pieceColor,
      Location location,
      ) : super(pieceColor, location);

  @override
  List<Location> legalMoves(List<ChessPiece> others) {
    return <Location> [
      ..._generateMoves(others),
      ..._generateMoves(others),
      ..._generateMoves(others),
      ..._generateMoves(others),
    ].toList();
  }

  @override
  String get name => "knight";

  List<Location> _generateMoves(List<ChessPiece> pieces) {

    final destination1 = Location(x - 2, y + 1);
    final pieceOnLocation1 = pieces.any((piece) => piece.location == destination1);
    final tileLocation1 = pieceOnLocation1 ? null : destination1;

    final destination2 = Location(x - 1, y + 2);
    final pieceOnLocation2 = pieces.any((piece) => piece.location == destination2);
    final tileLocation2 = pieceOnLocation2 ? null : destination2;

    final destination3 = Location(x + 1, y + 2);
    final pieceOnLocation3 = pieces.any((piece) => piece.location == destination3);
    final tileLocation3 = pieceOnLocation3 ? null : destination3;

    final destination4 = Location(x + 2, y + 1);
    final pieceOnLocation4 = pieces.any((piece) => piece.location == destination4);
    final tileLocation4 = pieceOnLocation4 ? null : destination4;

    final destination5 = Location(x + 2, y - 1);
    final pieceOnLocation5 = pieces.any((piece) => piece.location == destination5);
    final tileLocation5 = pieceOnLocation5 ? null : destination5;

    final destination6 = Location(x + 1, y - 2);
    final pieceOnLocation6 = pieces.any((piece) => piece.location == destination6);
    final tileLocation6 = pieceOnLocation6 ? null : destination6;

    final destination7 = Location(x - 1, y - 2);
    final pieceOnLocation7 = pieces.any((piece) => piece.location == destination7);
    final tileLocation7 = pieceOnLocation7 ? null : destination7;

    final destination8 = Location(x - 2, y - 1);
    final pieceOnLocation8 = pieces.any((piece) => piece.location == destination8);
    final tileLocation8 = pieceOnLocation8 ? null : destination8;

    var list = List<Location?>.empty(growable: true);

    list.add(tileLocation1);
    list.add(tileLocation2);
    list.add(tileLocation3);
    list.add(tileLocation4);
    list.add(tileLocation5);
    list.add(tileLocation6);
    list.add(tileLocation7);
    list.add(tileLocation8);


    var filteredList = list
        .whereType<Location>()
        .where((location) => location.isValid)
        .toList();

    return filteredList;
  }

  List<Location> _generateCaptures(List<ChessPiece> pieces) {

      final destination1 = Location(x - 2, y + 1);
      final enemyPieceOnLocation1 = pieces.any((piece) => piece.location == destination1 && piece.playerColor != playerColor);
      final tileLocation1 = enemyPieceOnLocation1 ? destination1 : null;

      final destination2 = Location(x - 1, y + 2);
      final enemyPieceOnLocation2 = pieces.any((piece) => piece.location == destination2 && piece.playerColor != playerColor);
      final tileLocation2 = enemyPieceOnLocation2 ? destination2 : null;

      final destination3 = Location(x + 1, y + 2);
      final enemyPieceOnLocation3 = pieces.any((piece) => piece.location == destination3 && piece.playerColor != playerColor);
      final tileLocation3 = enemyPieceOnLocation3 ? destination3 : null;

      final destination4 = Location(x + 2, y + 1);
      final enemyPieceOnLocation4 = pieces.any((piece) => piece.location == destination4 && piece.playerColor != playerColor);
      final tileLocation4 = enemyPieceOnLocation4 ? destination4 : null;

      final destination5 = Location(x + 2, y - 1);
      final enemyPieceOnLocation5 = pieces.any((piece) => piece.location == destination5 && piece.playerColor != playerColor);
      final tileLocation5 = enemyPieceOnLocation5 ? destination5 : null;

      final destination6 = Location(x + 1, y - 2);
      final enemyPieceOnLocation6 = pieces.any((piece) => piece.location == destination6 && piece.playerColor != playerColor);
      final tileLocation6 = enemyPieceOnLocation6 ? destination6 : null;

      final destination7 = Location(x - 1, y - 2);
      final enemyPieceOnLocation7 = pieces.any((piece) => piece.location == destination7 && piece.playerColor != playerColor);
      final tileLocation7 = enemyPieceOnLocation7 ? destination7 : null;

      final destination8 = Location(x - 2, y - 1);
      final enemyPieceOnLocation8 = pieces.any((piece) => piece.location == destination8 && piece.playerColor != playerColor);
      final tileLocation8 = enemyPieceOnLocation8 ? destination8 : null;

      var list = List<Location?>.empty(growable: true);

      list.add(tileLocation1);
      list.add(tileLocation2);
      list.add(tileLocation3);
      list.add(tileLocation4);
      list.add(tileLocation5);
      list.add(tileLocation6);
      list.add(tileLocation7);
      list.add(tileLocation8);

      var filteredList = list
        .whereType<Location>()
        .where((location) => location.isValid)
        .toList();

    return filteredList;
  }

  @override
  List<Location> legalCaptures(List<ChessPiece> others) {
    return <Location> [
      ..._generateCaptures(others),
      ..._generateCaptures(others),
      ..._generateCaptures(others),
      ..._generateCaptures(others),
    ].toList();
  }
}