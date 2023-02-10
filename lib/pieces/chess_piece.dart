enum PlayerColor { black, white }

class Location {
  final int x;
  final int y;

  Location(
      this.x,
      this.y
      );

  bool get isValid => x <= 7 && y <= 7;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  bool operator == (Object other) {
    return other is Location && (x == other.x && y == other.y);
  }
}

abstract class ChessPiece {
  final PlayerColor playerColor;
  Location location;

  String get name;

  String get fileName => "assets/${playerColor.toString().split(".").last}_$name.png";

  int get x => location.x;
  int get y => location.y;

  ChessPiece(
      this.playerColor,
      this.location);

  List<Location> legalMoves(List<ChessPiece> others);
  List<Location> legalCaptures(List<ChessPiece> others);

  bool canMoveTo(int x, int y, List<ChessPiece> others) =>
      legalMoves(others).contains(Location(x, y));

  bool canCapture(int x, int y, List<ChessPiece> others) =>
      legalCaptures(others).contains(Location(x, y));
}