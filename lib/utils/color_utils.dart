import 'dart:ui';

Color hexStringToColor(String? hexColor) {
  hexColor = hexColor?.toUpperCase().replaceAll('#', '');
  return Color(int.parse('0xFF$hexColor'));
}