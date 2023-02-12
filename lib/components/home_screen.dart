import 'package:chess/game_coordinator.dart';
import 'package:chess/pieces/pawn.dart';
import 'package:flutter/material.dart';
import '../pieces/bishop.dart';
import '../pieces/chess_piece.dart';
import '../pieces/knight.dart';
import '../pieces/queen.dart';
import '../pieces/rook.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => HomeScreenState();

}

class HomeScreenState extends State<HomeScreen> {
  late final double tileWidth = MediaQuery.of(context).size.width / 8.0;

  final Color green = const Color.fromRGBO(119, 149, 86, 100);
  final Color white = const Color.fromRGBO(235, 236, 208, 100);

  var activePlayerColor = PlayerColor.white;
  var previousMoveIsTwoSquarePawnMove = false;

  GameCoordinator coordinator = GameCoordinator.newGame();

  List<ChessPiece> get pieces => coordinator.pieces;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('chess'),
      ),
      body: Column (
        children: [
          const Spacer(),
          buildBoard(),
          const Spacer(),
        ],
      ),
    );
  }

  Column buildBoard() {
    return Column(
      children: [
        ...List.generate(8, (y) => Row(
          children: [
            ...List.generate(8, (x) => buildDragTarget(x, y)),
          ],
        )).reversed,
      ],
  );
  }

  DragTarget<ChessPiece> buildDragTarget(int x, int y) {

    return DragTarget<ChessPiece>(
      onAccept: (piece) {
        final capturedPiece = coordinator.pieceOfTile(x, y);

        setState(() {
          if (activePlayerColor == piece.playerColor) {

            // Если фигура является пешкой и разница по y равна 2, то previousMoveIsTwoSquarePawnMove = true
            if (piece is Pawn && (piece.location == Location(x, y - 2)
                || piece.location == Location(x, y + 2))) {
              previousMoveIsTwoSquarePawnMove = true;
              piece.previousMoveIsTwoSquareMove = true;
            }

            // Иначе у всех пешек флаг previousMoveIsTwoSquareMove = false
            else {
              previousMoveIsTwoSquarePawnMove = false;
              var pawns = coordinator.pieces.whereType<Pawn>();
              for (var element in pawns) {
                {element.previousMoveIsTwoSquareMove = false;}
              }
            }
            // Перемещение фигуры
            piece.location = Location(x, y);

            if (piece is Pawn && (y == 0 || y == 7)) {
                _showSimpleDialog(piece, capturedPiece);
                activePlayerColor = activePlayerColor == PlayerColor.white
                    ? PlayerColor.black
                    : PlayerColor.white;
                return;
            }
            // Фигура сделала первый ход, нужно для рокировки и первого хода пешек
            piece.makeFirstMove = true;

            // Удаление срубленной фигуры
            if (capturedPiece != null) {
              pieces.remove(capturedPiece);
            }


            // Проверка на совершение взятия на проходе
            if (piece is Pawn) {
              int dy = activePlayerColor == PlayerColor.white ? -1 : 1;
              if (coordinator.pieceOfTile(piece.x, piece.y + dy) != null) {
                pieces.remove(coordinator.pieceOfTile(piece.x, piece.y + dy));
              }
            }

            // Меняем цвет активного игрока
            activePlayerColor = activePlayerColor == PlayerColor.white
                ? PlayerColor.black
                : PlayerColor.white;
          }
        });
      },
      onWillAccept: (piece) {
        if (piece == null) {
          return false;
        }

        final canMoveTo = piece.canMoveTo(x, y, pieces);
        final canCapture = piece.canCapture(x, y, pieces, previousMoveIsTwoSquarePawnMove);

        return  (canMoveTo || canCapture) && piece.location != Location(x, y);
    },
      builder: (context, data, rejects) => Container(
        decoration: BoxDecoration(
          color: getTileColor(x, y),
        ),
        width: tileWidth,
        height: tileWidth,
        child: _buildChessPiece(x, y),
      )
    );
  }

  Color getTileColor(int x, int y){
    var value = x;
    if (y.isOdd) {
      value++;
    }
    return value.isEven ? green : white;
  }

  Widget? _buildChessPiece(int x, int y) {
    final piece = coordinator.pieceOfTile(x, y);
    if (piece != null) {
      final child = Container (
        alignment: Alignment.center,
        child: Image.asset(
          piece.fileName,
          height: tileWidth * 0.8,
          width: tileWidth * 0.8,
        )
      );
      return Draggable<ChessPiece> (
        data: piece,
        feedback: child,
        childWhenDragging: const SizedBox.shrink(),
        child: child,
      );
    }
    return null;
  }

  void _showSimpleDialog(ChessPiece piece, ChessPiece? capturedPiece) {
     showDialog (
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Chose your piece'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  _onPressedBehaviour(piece, capturedPiece, 'bishop');
                },
                child: _buildChildForSimpleDialog(piece, 'bishop')
              ),
              SimpleDialogOption(
                onPressed: () {
                  _onPressedBehaviour(piece, capturedPiece, 'knight');
                },
                child: _buildChildForSimpleDialog(piece, 'knight')
              ),
              SimpleDialogOption(
                onPressed: () {
                  _onPressedBehaviour(piece, capturedPiece, 'rook');
                  },
                child: _buildChildForSimpleDialog(piece, 'rook')
              ),
              SimpleDialogOption(
                onPressed: () {
                  _onPressedBehaviour(piece, capturedPiece, 'queen');
                  },
                child: _buildChildForSimpleDialog(piece, 'queen')
              ),
            ],
          );
        });

  }

  Image _buildChildForSimpleDialog(ChessPiece piece, String pickedChessPiece, [double widthCoefficient = 0.8, double heightCoefficient = 0.8]) {
    return Image.asset(
      'assets/${piece.playerColor == PlayerColor.white ? 'white' : 'black'}_$pickedChessPiece.png',
      height: tileWidth * widthCoefficient,
      width: tileWidth * heightCoefficient,
    );
  }

  void _onPressedBehaviour(ChessPiece piece, ChessPiece? capturedPiece, String pickedChessPiece) {
    Navigator.pop(context, 'queen');
    setState(() {
      if (capturedPiece != null) {
        pieces.remove(capturedPiece);
      }

      pieces.remove(piece);
      if (pickedChessPiece == 'bishop') {
        pieces.add(Bishop(piece.playerColor, piece.location));
      }
      else if (pickedChessPiece == 'knight') {
        pieces.add(Knight(piece.playerColor, piece.location));
      }
      else if (pickedChessPiece == 'rook') {
        pieces.add(Rook(piece.playerColor, piece.location));
      }
      else {
        pieces.add(Queen(piece.playerColor, piece.location));
      }
    });
  }
}