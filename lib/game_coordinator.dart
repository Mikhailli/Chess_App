import 'package:chess/pieces/bishop.dart';
import 'package:chess/pieces/chess_piece.dart';
import 'package:chess/pieces/king.dart';
import 'package:chess/pieces/pawn.dart';
import 'package:chess/pieces/queen.dart';
import 'package:chess/pieces/rook.dart';
import 'package:collection/collection.dart';

import 'pieces/knight.dart';

class GameCoordinator {
  //final List<ChessPiece> whitePieces;
  //final List<ChessPiece> blackPieces;


  List<ChessPiece> pieces = [];

  PlayerColor currentTurn;

  ChessPiece get currentPlayerKing => pieces.where((piece) => piece is King && piece.playerColor == currentTurn).first;

  bool get kingUnderCheck => pieces.any((piece) => piece.playerColor != currentTurn
  && piece.canCapture(currentPlayerKing.x, currentPlayerKing.y, pieces));
  //GameCoordinator(this.whitePieces, this.blackPieces, this.pieces);
  GameCoordinator(this.pieces, this.currentTurn);

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
          King(PlayerColor.white, Location(4, 0)),
          Pawn(PlayerColor.white, Location(0, 1)),
          Pawn(PlayerColor.white, Location(1, 1)),
          Pawn(PlayerColor.white, Location(2, 1)),
          Pawn(PlayerColor.white, Location(3, 1)),
          Pawn(PlayerColor.white, Location(4, 1)),
          Pawn(PlayerColor.white, Location(5, 1)),
          Pawn(PlayerColor.white, Location(6, 1)),
          Pawn(PlayerColor.white, Location(7, 1)),
          Rook(PlayerColor.black, Location(0, 7)),
          Rook(PlayerColor.black, Location(7, 7)),
          Knight(PlayerColor.black, Location(1, 7)),
          Knight(PlayerColor.black, Location(6, 7)),
          Bishop(PlayerColor.black, Location(2, 7)),
          Bishop(PlayerColor.black, Location(5, 7)),
          Queen(PlayerColor.black, Location(3, 7)),
          King(PlayerColor.black, Location(4, 7)),
          Pawn(PlayerColor.black, Location(0, 6)),
          Pawn(PlayerColor.black, Location(1, 6)),
          Pawn(PlayerColor.black, Location(2, 6)),
          Pawn(PlayerColor.black, Location(3, 6)),
          Pawn(PlayerColor.black, Location(4, 6)),
          Pawn(PlayerColor.black, Location(5, 6)),
          Pawn(PlayerColor.black, Location(6, 6)),
          Pawn(PlayerColor.black, Location(7, 6)),
        ],
      PlayerColor.white
    );
  }

  factory GameCoordinator.getPuzzle(int number, int moveCount) {
    if (moveCount == 1) {
      return GameCoordinator.mateInOnePuzzle(number);
    }
    if (moveCount == 2) {
      return GameCoordinator.mateInTwoPuzzle(number);
    }
    if (moveCount == 3) {
      return GameCoordinator.mateInThreePuzzle(number);
    }

    return GameCoordinator.empty();
  }

  factory GameCoordinator.mateInOnePuzzle(int number) {
    if (number == 1) {
    return GameCoordinator(
        [
          Knight(PlayerColor.white, Location(2, 5)),
          Bishop(PlayerColor.white, Location(4, 1)),
          King(PlayerColor.white, Location(1, 6)),
          Pawn(PlayerColor.white, Location(3, 1)),
          Rook(PlayerColor.black, Location(4, 7)),
          Bishop(PlayerColor.black, Location(3, 5)),
          Bishop(PlayerColor.black, Location(3, 4)),
          King(PlayerColor.black, Location(2, 4)),
          Pawn(PlayerColor.black, Location(1, 2)),
          Pawn(PlayerColor.black, Location(5, 5)),
        ],
        PlayerColor.white
    );}
    else if (number == 2) {
      return GameCoordinator(
          [
            Rook(PlayerColor.white, Location(0, 0)),
            Rook(PlayerColor.white, Location(7, 0)),
            Knight(PlayerColor.white, Location(4, 3)),
            Knight(PlayerColor.white, Location(6, 0)),
            Bishop(PlayerColor.white, Location(2, 0)),
            Bishop(PlayerColor.white, Location(5, 0)),
            Queen(PlayerColor.white, Location(4, 1)),
            King(PlayerColor.white, Location(4, 0)),
            Pawn(PlayerColor.white, Location(0, 1)),
            Pawn(PlayerColor.white, Location(1, 1)),
            Pawn(PlayerColor.white, Location(2, 1)),
            Pawn(PlayerColor.white, Location(3, 3)),
            Pawn(PlayerColor.white, Location(5, 1)),
            Pawn(PlayerColor.white, Location(6, 1)),
            Pawn(PlayerColor.white, Location(7, 1)),
            Rook(PlayerColor.black, Location(0, 7)),
            Rook(PlayerColor.black, Location(7, 7)),
            Knight(PlayerColor.black, Location(3, 6)),
            Knight(PlayerColor.black, Location(5, 5)),
            Bishop(PlayerColor.black, Location(2, 7)),
            Bishop(PlayerColor.black, Location(5, 7)),
            Queen(PlayerColor.black, Location(3, 7)),
            King(PlayerColor.black, Location(4, 7)),
            Pawn(PlayerColor.black, Location(0, 6)),
            Pawn(PlayerColor.black, Location(1, 6)),
            Pawn(PlayerColor.black, Location(2, 5)),
            Pawn(PlayerColor.black, Location(4, 6)),
            Pawn(PlayerColor.black, Location(5, 6)),
            Pawn(PlayerColor.black, Location(6, 6)),
            Pawn(PlayerColor.black, Location(7, 6)),
          ],
          PlayerColor.white
      );
    }
    else if (number == 3) {
      return GameCoordinator(
          [
            Rook(PlayerColor.white, Location(0, 0)),
            Rook(PlayerColor.white, Location(5, 0)),
            Knight(PlayerColor.white, Location(4, 4)),
            Bishop(PlayerColor.white, Location(2, 0)),
            Bishop(PlayerColor.white, Location(5, 6)),
            King(PlayerColor.white, Location(6, 0)),
            Pawn(PlayerColor.white, Location(0, 1)),
            Pawn(PlayerColor.white, Location(1, 1)),
            Pawn(PlayerColor.white, Location(2, 1)),
            Pawn(PlayerColor.white, Location(2, 2)),
            Pawn(PlayerColor.white, Location(5, 1)),
            Pawn(PlayerColor.white, Location(6, 1)),
            Pawn(PlayerColor.white, Location(7, 1)),
            Rook(PlayerColor.black, Location(0, 7)),
            Rook(PlayerColor.black, Location(7, 7)),
            Knight(PlayerColor.black, Location(1, 7)),
            Bishop(PlayerColor.black, Location(3, 0)),
            Bishop(PlayerColor.black, Location(5, 7)),
            Queen(PlayerColor.black, Location(3, 7)),
            King(PlayerColor.black, Location(4, 6)),
            Pawn(PlayerColor.black, Location(0, 6)),
            Pawn(PlayerColor.black, Location(1, 6)),
            Pawn(PlayerColor.black, Location(2, 6)),
            Pawn(PlayerColor.black, Location(3, 5)),
            Pawn(PlayerColor.black, Location(6, 6)),
            Pawn(PlayerColor.black, Location(7, 6)),
          ],
          PlayerColor.white
      );
    }
    else {
      return GameCoordinator.empty();
    }
  }

  factory GameCoordinator.mateInTwoPuzzle(int number) {
    if (number == 1) {
      return GameCoordinator(
          [
            Knight(PlayerColor.white, Location(6, 4)),
            Queen(PlayerColor.white, Location(4, 7)),
            King(PlayerColor.white, Location(1, 0)),
            Pawn(PlayerColor.white, Location(0, 2)),
            Pawn(PlayerColor.white, Location(1, 1)),
            Pawn(PlayerColor.white, Location(5, 3)),
            Pawn(PlayerColor.white, Location(6, 2)),
            Bishop(PlayerColor.black, Location(5, 7)),
            Queen(PlayerColor.black, Location(2, 4)),
            King(PlayerColor.black, Location(7, 7)),
            Pawn(PlayerColor.black, Location(0, 6)),
            Pawn(PlayerColor.black, Location(1, 4)),
            Pawn(PlayerColor.black, Location(2, 6)),
            Pawn(PlayerColor.black, Location(5, 4)),
            Pawn(PlayerColor.black, Location(6, 6)),
          ],
          PlayerColor.white
      );}
    else if (number == 2) {
      return GameCoordinator(
          [
            Rook(PlayerColor.white, Location(2, 5)),
            Knight(PlayerColor.white, Location(3, 3)),
            King(PlayerColor.white, Location(7, 3)),
            Pawn(PlayerColor.white, Location(0, 1)),
            Pawn(PlayerColor.white, Location(1, 2)),
            Pawn(PlayerColor.white, Location(4, 2)),
            Rook(PlayerColor.black, Location(1, 3)),
            Knight(PlayerColor.black, Location(6, 3)),
            King(PlayerColor.black, Location(6, 6)),
            Pawn(PlayerColor.black, Location(0, 4)),
            Pawn(PlayerColor.black, Location(4, 6)),
            Pawn(PlayerColor.black, Location(5, 6)),
            Pawn(PlayerColor.black, Location(7, 6)),
          ],
          PlayerColor.white
      );}
    else if (number == 3) {
      return GameCoordinator(
          [
            Rook(PlayerColor.white, Location(5, 0)),
            Queen(PlayerColor.white, Location(7, 3)),
            Bishop(PlayerColor.white, Location(6, 5)),
            King(PlayerColor.white, Location(6, 0)),
            Pawn(PlayerColor.white, Location(3, 2)),
            Pawn(PlayerColor.white, Location(4, 3)),
            Pawn(PlayerColor.white, Location(5, 4)),
            Pawn(PlayerColor.white, Location(6, 1)),
            Bishop(PlayerColor.black, Location(2, 5)),
            Queen(PlayerColor.black, Location(3, 7)),
            King(PlayerColor.black, Location(6, 7)),
            Pawn(PlayerColor.black, Location(1, 6)),
            Pawn(PlayerColor.black, Location(3, 3)),
            Pawn(PlayerColor.black, Location(4, 4)),
            Pawn(PlayerColor.black, Location(5, 5)),
            Pawn(PlayerColor.black, Location(7, 6)),
            Rook(PlayerColor.black, Location(0, 7)),
          ],
          PlayerColor.white
      );
    }
    else {
      return GameCoordinator.empty();
    }
  }

  factory GameCoordinator.mateInThreePuzzle(int number) {
    if (number == 1) {
      return GameCoordinator(
          [
            Bishop(PlayerColor.white, Location(2, 0)),
            King(PlayerColor.white, Location(7, 0)),
            Knight(PlayerColor.white, Location(4, 5)),
            Knight(PlayerColor.white, Location(5, 4)),
            Rook(PlayerColor.white, Location(6, 0)),
            Queen(PlayerColor.white, Location(4, 0)),
            Pawn(PlayerColor.white, Location(0, 1)),
            Pawn(PlayerColor.white, Location(4, 3)),
            Pawn(PlayerColor.white, Location(3, 4)),
            Pawn(PlayerColor.white, Location(5, 1)),
            Pawn(PlayerColor.white, Location(5, 5)),
            Pawn(PlayerColor.white, Location(7, 1)),
            Knight(PlayerColor.black, Location(0, 4)),
            King(PlayerColor.black, Location(6, 7)),
            Bishop(PlayerColor.black, Location(0, 5)),
            Bishop(PlayerColor.black, Location(2, 6)),
            Rook(PlayerColor.black, Location(1, 6)),
            Rook(PlayerColor.black, Location(5, 6)),
            Queen(PlayerColor.black, Location(0, 3)),
            Queen(PlayerColor.black, Location(1, 0)),
            Pawn(PlayerColor.black, Location(1, 3)),
            Pawn(PlayerColor.black, Location(3, 5)),
            Pawn(PlayerColor.black, Location(6, 6)),
            Pawn(PlayerColor.black, Location(7, 6)),
          ],
          PlayerColor.white
      );}
    else if (number == 2) {
      return GameCoordinator(
          [
            Bishop(PlayerColor.white, Location(5, 4)),
            Knight(PlayerColor.white, Location(6, 3)),
            Queen(PlayerColor.white, Location(7, 5)),
            King(PlayerColor.white, Location(7, 1)),
            Pawn(PlayerColor.white, Location(6, 1)),
            Pawn(PlayerColor.white, Location(5, 3)),
            Pawn(PlayerColor.white, Location(6, 5)),
            Queen(PlayerColor.black, Location(0, 0)),
            Rook(PlayerColor.black, Location(4, 6)),
            King(PlayerColor.black, Location(6, 7)),
            Pawn(PlayerColor.black, Location(0, 3)),
            Pawn(PlayerColor.black, Location(3, 4)),
          ],
          PlayerColor.white
      );}
    else if (number == 3) {
      return GameCoordinator(
          [
            Rook(PlayerColor.white, Location(5, 0)),
            Queen(PlayerColor.white, Location(3, 7)),
            Bishop(PlayerColor.white, Location(3, 5)),
            King(PlayerColor.white, Location(4, 1)),
            Pawn(PlayerColor.white, Location(1, 2)),
            Pawn(PlayerColor.white, Location(2, 3)),
            Pawn(PlayerColor.white, Location(5, 2)),
            Pawn(PlayerColor.white, Location(7, 1)),
            Knight(PlayerColor.white, Location(3, 1)),
            Knight(PlayerColor.white, Location(6, 3)),
            Bishop(PlayerColor.black, Location(5, 7)),
            Queen(PlayerColor.black, Location(2, 1)),
            King(PlayerColor.black, Location(6, 7)),
            Rook(PlayerColor.black, Location(3, 3)),
            Pawn(PlayerColor.black, Location(4, 5)),
            Pawn(PlayerColor.black, Location(7, 5)),
          ],
          PlayerColor.white
      );
    }
    else {
      return GameCoordinator.empty();
    }
  }

  factory GameCoordinator.empty()
  {
    return GameCoordinator([], PlayerColor.white);
  }
}