import 'package:chess/pieces/bishop.dart';
import 'package:chess/pieces/chess_piece.dart';
import 'package:collection/collection.dart';

class GameCoordinator {
  final List<ChessPiece> whitePieces;
  final List<ChessPiece> blackPieces;

  List<ChessPiece> get pieces => [
    ...whitePieces,
    ...blackPieces
  ].toList();

  PlayerColor currentTurn = PlayerColor.white;

  GameCoordinator(this.whitePieces, this.blackPieces);

  ChessPiece? pieceOfTile(int x, int y) => pieces.firstWhereOrNull((p) => p.x == x && p.y == y);

  factory GameCoordinator.newGame() {
    return GameCoordinator(
        [
          Bishop(PlayerColor.white, Location(2, 0)),
          Bishop(PlayerColor.white, Location(5, 0))
        ],
        [
          Bishop(PlayerColor.black, Location(2, 7)),
          Bishop(PlayerColor.black, Location(5, 7))
        ],
    );
  }
}