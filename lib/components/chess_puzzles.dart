import 'dart:async';
import 'dart:developer';
import 'package:chess/game_coordinator.dart';
import 'package:chess/pieces/king.dart';
import 'package:chess/pieces/pawn.dart';
import 'package:flutter/material.dart';
import '../pieces/bishop.dart';
import '../pieces/chess_piece.dart';
import '../pieces/knight.dart';
import '../pieces/queen.dart';
import '../pieces/rook.dart';
import 'home_edu_screen.dart';
import 'home_game_screen.dart';
import 'home_main_screen.dart';
import 'home_settings_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:tuple/tuple.dart';

class CustomAlertDialogShape extends RoundedRectangleBorder {
  final double radius;

  const CustomAlertDialogShape(this.radius);

}

class ChessPuzzle extends StatefulWidget {
  const ChessPuzzle({super.key});

  @override
  State<StatefulWidget> createState() => ChessPuzzleState();

}

class ChessPuzzleState extends State<ChessPuzzle> {
  int check = -1;
  int index = 2;
  final screens = [
    const HomeMainScreen(),
    const HomeGameScreen(),
    const HomeEduScreen(),
    const HomeSettingsScreen(),
  ];

  late final double tileWidth = MediaQuery.of(context).size.width / 8.0;

  final Color green = const Color.fromRGBO(119, 149, 86, 100);
  final Color white = const Color.fromRGBO(235, 236, 208, 100);

  var activePlayerColor = PlayerColor.white;
  var previousMoveIsTwoSquarePawnMove = false;
  var numberOfPuzzle = 0;
  var movesCount = 0;
  var countOfMakedMove = 0;

  GameCoordinator coordinator = GameCoordinator.empty();

  List<ChessPiece> get pieces => coordinator.pieces;

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as List<int>;
    numberOfPuzzle = arguments[1];
    movesCount = arguments[0];


    if (coordinator.pieces.isEmpty) {
      coordinator = GameCoordinator.getPuzzle(numberOfPuzzle, movesCount);
    }
    final items = <Widget>[
      const Icon(Icons.home_filled, size: 30,),
      const Icon(Icons.gamepad_rounded, size: 30,),
      const Icon(Icons.book, size: 30,),
      const Icon(Icons.settings, size: 30,)
    ];

    if (check == -1) {
    return Scaffold(
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
        bottomNavigationBar: CurvedNavigationBar (
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: Colors.white,
          animationDuration: const Duration(milliseconds: 300),
          items: items,
          color: Colors.greenAccent,
          height: 60,
          index: index,
          onTap: (index) => setState (() => {
            this.index = index,
            check = 0
          }),
        ),
    );}
    else {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.greenAccent,
          title: const Text('♜EazyChess♜'),
          elevation: 0,
          centerTitle: true,
        ),
        body: screens[index],
        bottomNavigationBar: CurvedNavigationBar (
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: Colors.white,
          animationDuration: const Duration(milliseconds: 300),
          items: items,
          color: Colors.greenAccent,
          height: 60,
          index: index,
          onTap: (index) => setState (() => this.index = index),
        ),
      );
    }
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
          final correctMoves = getCorrectMoves(movesCount, numberOfPuzzle);
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
              var location = piece.location;
              piece.location = Location(x, y);
              if (coordinator.pieceOfTile(correctMoves[countOfMakedMove].item1?.x as int, correctMoves[countOfMakedMove].item1?.y as int) != null
              || coordinator.pieceOfTile(correctMoves[countOfMakedMove].item2?.x as int, correctMoves[countOfMakedMove].item2?.y as int) == null )
                {
                  piece.location = location;
                }
              else {
                countOfMakedMove += 1;


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
                coordinator.currentTurn =
                coordinator.currentTurn == PlayerColor.white
                    ? PlayerColor.black
                    : PlayerColor.white;

                if (activePlayerColor == PlayerColor.black &&
                    countOfMakedMove != 0 && correctMoves.length >= countOfMakedMove + 1 &&
                    correctMoves[countOfMakedMove - 1].item3 != null) {
                  var piece = coordinator.pieceOfTile(correctMoves[countOfMakedMove - 1].item3?.x as int, correctMoves[countOfMakedMove - 1].item3?.y as int);
                  Timer(const Duration(milliseconds: 300), () {
                    setState((){
                      var capturedPiece = coordinator.pieceOfTile(correctMoves[countOfMakedMove - 1].item4?.x as int, correctMoves[countOfMakedMove - 1].item4?.y as int);
                      if (capturedPiece != null) {
                        coordinator.pieces.remove(capturedPiece);
                      }
                    piece?.location = Location(correctMoves[countOfMakedMove - 1].item4?.x as int, correctMoves[countOfMakedMove - 1].item4?.y as int);

                  activePlayerColor = PlayerColor.white;
                  coordinator.currentTurn = PlayerColor.white;});

                  });
                }

                final allCurrentPlayerPieces = coordinator.pieces.where((
                    piece) =>
                piece.playerColor == coordinator.currentTurn)
                    .toList();
                var canDoMove = false;

                for (var currentPlayerPiece in allCurrentPlayerPieces) {
                  var isCheck = true;
                  final initialLocation = Location(
                      currentPlayerPiece.location.x,
                      currentPlayerPiece.location.y);
                  for (var location in currentPlayerPiece.legalMoves(pieces)) {
                    if (coordinator.pieceOfTile(location.x, location.y) !=
                        currentPlayerPiece) {
                      if (coordinator.pieceOfTile(location.x, location.y) !=
                          null &&
                          coordinator.pieceOfTile(
                              location.x, location.y) is King == false) {
                        final capturedPiece = coordinator.pieceOfTile(
                            location.x, location.y);
                        coordinator.pieces.remove(
                            coordinator.pieceOfTile(location.x, location.y));
                        currentPlayerPiece.location =
                            Location(location.x, location.y);
                        if (coordinator.kingUnderCheck == false) {
                          isCheck = false;
                        }
                        currentPlayerPiece.location = initialLocation;
                        coordinator.pieces.add(capturedPiece as ChessPiece);
                      }
                      else {
                        currentPlayerPiece.location =
                            Location(location.x, location.y);
                        if (coordinator.kingUnderCheck == false) {
                          isCheck = false;
                        }
                        currentPlayerPiece.location = initialLocation;
                      }
                    }
                    if (isCheck == false &&
                        coordinator.pieceOfTile(location.x, location.y) !=
                            currentPlayerPiece) {
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
                    Timer(const Duration(milliseconds: 300), () {
                    if (numberOfPuzzle != 3) {
                    showDialog(
                        context: context,
                        builder: (_) =>
                          AlertDialog(
                            title: const Center(child: Text('Задача решена')),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(32.0))),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children : const <Widget>[
                                Expanded(
                                  child: Text(
                                    'Хотите перейти к следующей задаче?',
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
                                    context, 'chess_puzzles',
                                    arguments: [movesCount, numberOfPuzzle + 1]), child: const Text('Да'))),
                              ],)],
                          )
                    );}
                    else {
                      showDialog(
                          context: context,
                          builder: (_) =>
                              AlertDialog(
                                title: const Center(child: Text('Задача решена')),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children : const <Widget>[
                                    Expanded(
                                      child: Text(
                                        'Это последняя задача в данной категории. Хотите вернуться к выбору категории?',
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
                                  Container( margin: const EdgeInsets.symmetric(horizontal: 20.0),child: ElevatedButton(onPressed: () => Navigator.pushNamed(context, 'chess_puzzles_screen'), child: const Text('Да'))),
                                ],)],
                              ));
                    }});
                  }

                  else {
                    log("Пат!!!!!");
                  }
                }
              }}
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
      if (piece.playerColor == PlayerColor.black){
        return Container (
            alignment: Alignment.center,
            child: Image.asset(
              piece.fileName,
              height: tileWidth * 0.8,
              width: tileWidth * 0.8,
            )
        );
      }
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

  List<Tuple4<Location?, Location?, Location?, Location?>> getCorrectMoves(int movesCount, int number) {
    if (movesCount == 1) {
      if (number == 1) {
        return [Tuple4(Location(3, 1), Location(3, 3), null, null)];
      }
      else if (number == 2) {
        return [Tuple4(Location(4, 3), Location(3, 5), null, null)];
      }
      else if (number == 3) {
        return [Tuple4(Location(2, 0), Location(6, 4), null, null)];
      }
    }
    else if (movesCount == 2) {
      if (number == 1) {
        return
          [Tuple4(Location(4, 7), Location(7, 4), Location(7, 7), Location(6, 7)),
          Tuple4(Location(7, 4), Location(7, 6), null, null)];
      }
      else if (number == 2) {
        return
          [Tuple4(Location(3, 3), Location(5, 4), Location(6, 6), Location(6, 7)),
          Tuple4(Location(7, 4), Location(7, 6), null, null)];
      }
      else if (number == 3) {
        return
          [Tuple4(Location(7, 3), Location(7, 6), Location(6, 7), Location(5, 7)),
          Tuple4(Location(7, 6), Location(5, 6), null, null)];
      }
    }
    else if (movesCount == 3) {
      if (number == 1) {
        return
          [Tuple4(Location(5, 4), Location(7, 5), Location(6, 7), Location(7, 7)),
            Tuple4(Location(7, 5), Location(5, 6), Location(7, 7), Location(6, 7)),
            Tuple4(Location(0, 6), Location(6, 6), null, null)];
      }
      else if (number == 2) {
        return
          [Tuple4(Location(5, 4), Location(4, 5), Location(4, 6), Location(4, 5)),
            Tuple4(Location(7, 5), Location(7, 6), Location(6, 7), Location(5, 7)),
            Tuple4(Location(7, 6), Location(5, 6), null, null)];
      }
      else if (number == 3) {
        return
          [Tuple4(Location(3, 7), Location(5, 7), Location(6, 7), Location(7, 6)),
            Tuple4(Location(5, 7), Location(5, 6), Location(7, 6), Location(7, 7)),
            Tuple4(Location(3, 5), Location(4, 4), null, null)];
      }
    }
    return [const Tuple4(null, null, null, null)];
  }
}
