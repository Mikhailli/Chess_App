import 'package:chess/pieces/bishop.dart';
import 'package:chess/pieces/chess_piece.dart';
import 'package:chess/pieces/queen.dart';
import 'package:chess/pieces/rook.dart';
import 'package:collection/collection.dart';

import 'pieces/knight.dart';

class GameCoordinator {
  //final List<ChessPiece> whitePieces;
  //final List<ChessPiece> blackPieces;


  final List<ChessPiece> pieces;

  PlayerColor currentTurn = PlayerColor.white;

  //GameCoordinator(this.whitePieces, this.blackPieces, this.pieces);
  GameCoordinator(this.pieces);

  ChessPiece? pieceOfTile(int x, int y) => pieces.firstWhereOrNull((p) => p.x == x && p.y == y);

  factory GameCoordinator.newGame() {
    return GameCoordinator(
        //[
        //  Bishop(PlayerColor.white, Location(2, 0)),
        //  Bishop(PlayerColor.white, Location(5, 0))
        //],
        //[
        //  Bishop(PlayerColor.black, Location(2, 7)),
        //  Bishop(PlayerColor.black, Location(5, 7))
        //],
        [
          Rook(PlayerColor.white, Location(0, 0)),
          Rook(PlayerColor.white, Location(7, 0)),
          Knight(PlayerColor.white, Location(1, 0)),
          Knight(PlayerColor.white, Location(6, 0)),
          Bishop(PlayerColor.white, Location(2, 0)),
          Bishop(PlayerColor.white, Location(5, 0)),
          Queen(PlayerColor.white, Location(3, 0)),
          Rook(PlayerColor.black, Location(0, 7)),
          Rook(PlayerColor.black, Location(7, 7)),
          Knight(PlayerColor.black, Location(1, 7)),
          Knight(PlayerColor.black, Location(6, 7)),
          Bishop(PlayerColor.black, Location(2, 7)),
          Bishop(PlayerColor.black, Location(5, 7)),
          Queen(PlayerColor.black, Location(3, 7)),
        ]
    );
  }
}