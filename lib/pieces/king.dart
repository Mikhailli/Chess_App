import 'package:chess/pieces/chess_piece.dart';
import 'package:chess/pieces/rook.dart';
import 'package:collection/collection.dart';

class King extends ChessPiece {
  King(
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
  String get name => "king";

  List<Location> _generateMoves(List<ChessPiece> pieces) {
    var canDoShortCastle = false;
    var canDoLongCastle = false;


    if (makeFirstMove == false) {
      var notMovedRooks = pieces.where((piece) => piece is Rook && piece.makeFirstMove == false && piece.playerColor == playerColor);
      var locationsToCheckLongCastle = List<Location>.empty(growable: true);
      var locationsToCheckShortCastle = List<Location>.empty(growable: true);

      if (notMovedRooks.isNotEmpty) {
        for (var rook in notMovedRooks) {
          if (rook.x == 0) {
            locationsToCheckLongCastle.add(Location(1, y));
            locationsToCheckLongCastle.add(Location(2, y));
            locationsToCheckLongCastle.add(Location(3, y));
          }
          else {
            locationsToCheckShortCastle.add(Location(5, y));
            locationsToCheckShortCastle.add(Location(6, y));
          }
        }

        var enemyPieces = pieces.where((piece) => piece.playerColor != playerColor && piece is King == false).toList();

        if (enemyPieces.any((piece) => piece.canCapture(x, y, pieces)) == false) {
          canDoShortCastle = true;
          canDoLongCastle = true;
        }
        
        for (var currentLocation in locationsToCheckShortCastle) {
          if (pieces.any((piece) => piece.location == currentLocation)
              || enemyPieces.any((piece) => piece.canMoveTo(currentLocation.x, currentLocation.y, pieces))
              || enemyPieces.any((piece) => piece.canCapture(currentLocation.x, currentLocation.y, pieces))) {
            canDoShortCastle = false;
          }
        }

        for (var currentLocation in locationsToCheckLongCastle) {
          if (pieces.any((piece) => piece.location == currentLocation)
              || enemyPieces.any((piece) => piece.canMoveTo(currentLocation.x, currentLocation.y, pieces))
              || enemyPieces.any((piece) => piece.canCapture(currentLocation.x, currentLocation.y, pieces))) {
            canDoLongCastle = false;
          }
        }
      }
    }

    final destination1 = Location(x - 1, y);
    final pieceOnLocation1 = pieces.any((piece) => piece.location == destination1);
    final tileLocation1 = pieceOnLocation1 ? null : destination1;

    final destination2 = Location(x - 1, y + 1);
    final pieceOnLocation2 = pieces.any((piece) => piece.location == destination2);
    final tileLocation2 = pieceOnLocation2 ? null : destination2;

    final destination3 = Location(x, y + 1);
    final pieceOnLocation3 = pieces.any((piece) => piece.location == destination3);
    final tileLocation3 = pieceOnLocation3 ? null : destination3;

    final destination4 = Location(x + 1, y + 1);
    final pieceOnLocation4 = pieces.any((piece) => piece.location == destination4);
    final tileLocation4 = pieceOnLocation4 ? null : destination4;

    final destination5 = Location(x + 1, y);
    final pieceOnLocation5 = pieces.any((piece) => piece.location == destination5);
    final tileLocation5 = pieceOnLocation5 ? null : destination5;

    final destination6 = Location(x + 1, y - 1);
    final pieceOnLocation6 = pieces.any((piece) => piece.location == destination6);
    final tileLocation6 = pieceOnLocation6 ? null : destination6;

    final destination7 = Location(x, y - 1);
    final pieceOnLocation7 = pieces.any((piece) => piece.location == destination7);
    final tileLocation7 = pieceOnLocation7 ? null : destination7;

    final destination8 = Location(x - 1, y - 1);
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

    if (canDoShortCastle) {
      list.add(Location(x + 2, y));
    }

    if (canDoLongCastle) {
      list.add(Location(x - 2, y));
    }

    var filteredList = list
        .whereType<Location>()
        .where((location) => location.isValid)
        .toList();

    return filteredList;
  }

  List<Location> _generateCaptures(List<ChessPiece> pieces) {

    final destination1 = Location(x - 1, y);
    final pieceOnLocation1 = pieces.any((piece) => piece.location == destination1);
    final tileLocation1 = pieceOnLocation1 ? destination1 : null;

    final destination2 = Location(x - 1, y + 1);
    final pieceOnLocation2 = pieces.any((piece) => piece.location == destination2);
    final tileLocation2 = pieceOnLocation2 ? destination2 : null;

    final destination3 = Location(x, y + 1);
    final pieceOnLocation3 = pieces.any((piece) => piece.location == destination3);
    final tileLocation3 = pieceOnLocation3 ? destination3 : null;

    final destination4 = Location(x + 1, y + 1);
    final pieceOnLocation4 = pieces.any((piece) => piece.location == destination4);
    final tileLocation4 = pieceOnLocation4 ? destination4 : null;

    final destination5 = Location(x + 1, y);
    final pieceOnLocation5 = pieces.any((piece) => piece.location == destination5);
    final tileLocation5 = pieceOnLocation5 ? destination5 : null;

    final destination6 = Location(x + 1, y - 1);
    final pieceOnLocation6 = pieces.any((piece) => piece.location == destination6);
    final tileLocation6 = pieceOnLocation6 ? destination6 : null;

    final destination7 = Location(x, y - 1);
    final pieceOnLocation7 = pieces.any((piece) => piece.location == destination7);
    final tileLocation7 = pieceOnLocation7 ? destination7 : null;

    final destination8 = Location(x - 1, y - 1);
    final pieceOnLocation8 = pieces.any((piece) => piece.location == destination8);
    final tileLocation8 = pieceOnLocation8 ? destination8 : null;

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
  List<Location> legalCaptures(List<ChessPiece> others, [bool previousMoveIsEnPassion = false]
      ) {
    return <Location> [
      ..._generateCaptures(others),
      ..._generateCaptures(others),
      ..._generateCaptures(others),
      ..._generateCaptures(others),
    ].toList();
  }
}