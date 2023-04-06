import 'dart:developer';
import 'package:chess/game_coordinator.dart';
import 'package:chess/pieces/king.dart';
import 'package:chess/pieces/pawn.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  Future<bool?> showWarning (BuildContext context) async => showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Вы правда хотите выйти из игры? Игра не будет сохранена.', textAlign: TextAlign.justify),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        actions: [ Row(mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,children: [
            Container( margin: const EdgeInsets.symmetric(horizontal: 20.0), child: ElevatedButton(onPressed:() => Navigator.pop(context, false), child: const Text('Нет'))),
            Container( margin: const EdgeInsets.symmetric(horizontal: 20.0),child: ElevatedButton(onPressed: () => Navigator.pushNamed(context, 'home'), child: const Text('Да'))),
          ],)],
      ));
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return WillPopScope(
      onWillPop: () async {
        if (kDebugMode) {
          print('Действие назад зафиксировано');
        }
        final shouldPop = await showWarning(context);
        return shouldPop ?? false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.greenAccent,
            title: const Text('♜EazyChess♜',style: TextStyle(fontSize: 24, color: Colors.black)),
            leading: const BackButton(color: Colors.black),
            elevation: 0,
            centerTitle: true,
    ),
    body: Column (
    children: [
    const Spacer(),
    buildBoard(),
    const Spacer(),
    ],
    ),
    ));
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

            // Короткая рокировка
            if (piece is King && piece.location.x == x - 2) {
                var rook = coordinator.pieceOfTile(x + 1, y);
                rook?.location = Location(x - 1, y);
            }

            // Длинная рокировка
            if (piece is King && piece.location.x == x + 2) {
              var rook = coordinator.pieceOfTile(x - 2, y);
              rook?.location = Location(x + 1, y);
            }

            // Проверка на совершение взятия на проходе
            if (piece is Pawn) {
              int dy = activePlayerColor == PlayerColor.white ? -1 : 1;
              int dx = x - piece.x;
              if (coordinator.pieceOfTile(piece.x + dx, piece.y - dy) == null && dx != 0) {
                pieces.remove(coordinator.pieceOfTile(piece.x + dx, piece.y));
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

            // Меняем цвет активного игрока
            activePlayerColor = activePlayerColor == PlayerColor.white
                ? PlayerColor.black
                : PlayerColor.white;

            // Меняем цвет активного игрока
            coordinator.currentTurn = coordinator.currentTurn == PlayerColor.white
                ? PlayerColor.black
                : PlayerColor.white;

            final allCurrentPlayerPieces = coordinator.pieces.where((piece) => piece.playerColor == coordinator.currentTurn).toList();
            var canDoMove = false;

            for (var currentPlayerPiece in allCurrentPlayerPieces) {
              var isCheck = true;
              final initialLocation = Location(
                  currentPlayerPiece.location.x, currentPlayerPiece.location.y);
              for (var location in currentPlayerPiece.legalMoves(pieces)) {
                if (coordinator.pieceOfTile(location.x, location.y) != currentPlayerPiece) {
                  if (coordinator.pieceOfTile(location.x, location.y) != null &&
                      coordinator.pieceOfTile(location.x, location.y) is King == false) {
                    final capturedPiece = coordinator.pieceOfTile(location.x, location.y);
                    coordinator.pieces.remove(coordinator.pieceOfTile(location.x, location.y));
                    currentPlayerPiece.location = Location(location.x, location.y);
                    if (coordinator.kingUnderCheck == false) {
                      isCheck = false;
                    }
                    currentPlayerPiece.location = initialLocation;
                    coordinator.pieces.add(capturedPiece as ChessPiece);
                  }
                  else {
                    currentPlayerPiece.location = Location(location.x, location.y);
                    if (coordinator.kingUnderCheck == false) {
                      isCheck = false;
                    }
                    currentPlayerPiece.location = initialLocation;
                  }
                }
                if (isCheck == false && coordinator.pieceOfTile(location.x, location.y) != currentPlayerPiece) {
                  canDoMove = true;
                  break;
                }
              }
              if (canDoMove) {
                break;
              }
            }
            if (canDoMove == false) {
              if (coordinator.kingUnderCheck) {
                log("Мат!!!!!");
                var message = coordinator.currentTurn == PlayerColor.black
                    ? 'Победили белые.'
                    : 'Победили черные.';
                    showDialog(
                        context: context,
                        builder: (_) =>
                            AlertDialog(
                              title: const Center(child: Text('Партия окончена')),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children : <Widget>[
                                  Expanded(
                                    child: Text(
                                      "$message Хотите сыграть еще раз?",
                                      textAlign: TextAlign.justify,
                                      style: const TextStyle(
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              actions: [ Row(mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,children: [
                                  Container( margin: const EdgeInsets.symmetric(horizontal: 20.0), child: ElevatedButton(onPressed:() => Navigator.pop(context), child: const Text('Нет'))),
                                  Container( margin: const EdgeInsets.symmetric(horizontal: 20.0),child: ElevatedButton(onPressed: () => Navigator.pushNamed(
                                      context, 'home_screen'),
                                       child: const Text('Да'))),
                                ],)],
                            )
                    );
              }
              else {
                log("Пат!!!!!");
                showDialog(
                    context: context,
                    builder: (_) =>
                        AlertDialog(
                          title: const Center(child: Text('Партия окончена')),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(32.0))),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children : const <Widget>[
                              Expanded(
                                child: Text(
                                  "Ничья. Хотите сыграть еще раз?",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                  ),
                                ),
                              )
                            ],
                          ),
                          actions: [ Row(mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,children: [
                              Container( margin: const EdgeInsets.symmetric(horizontal: 20.0), child: ElevatedButton(onPressed:() => Navigator.pop(context), child: const Text('Нет'))),
                              Container( margin: const EdgeInsets.symmetric(horizontal: 20.0),child: ElevatedButton(onPressed: () => Navigator.pushNamed(
                                  context, 'home_screen'),
                                  child: const Text('Да'))),
                            ],)],
                        )
                );
              }
            }
          }
        });
      },
      onWillAccept: (piece) {
        if (piece == null) {
          return false;
        }

        final canMoveTo = piece.canMoveTo(x, y, pieces);
        final canCapture = piece.canCapture(x, y, pieces, previousMoveIsTwoSquarePawnMove);

        var isCheck = true;
        final initialLocation = Location (piece.location.x, piece.location.y);

          if (coordinator.pieceOfTile(x, y) != piece) {
            if (coordinator.pieceOfTile(x, y) != null && coordinator.pieceOfTile(x, y) is King == false) {
              final capturedPiece = coordinator.pieceOfTile(x, y);
              coordinator.pieces.remove(coordinator.pieceOfTile(x, y));
              piece.location = Location(x, y);
              if (coordinator.kingUnderCheck == false) {
                isCheck = false;
              }
              piece.location = initialLocation;
              coordinator.pieces.add(capturedPiece as ChessPiece);
            }
            else {
              piece.location = Location(x, y);
              if (coordinator.kingUnderCheck == false) {
                isCheck = false;
              }
              piece.location = initialLocation;
            }
          }

        return  (canMoveTo || canCapture) && piece.location != Location(x, y) && isCheck == false;
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
