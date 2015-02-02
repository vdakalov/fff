library color;

import 'package:fff/utils.dart';

class Color {

  /// Return red component (0-255).
  final int red;

  /// Return green component (0-255).
  final int green;

  /// Return blue component (0-255).
  final int blue;

  /// Return opacity level (0-1)
  final double alpha;

  /// Constructor create [Color] from rgba components.
  /// Instead not transmitted component will be used by default components
  const Color([this.red = 0, this.green = 0, this.blue = 0, this.alpha]);

  bool operator ==(Color other) {
    return red == other.red && green == other.green && blue == other.blue &&
        alpha == other.alpha;
  }

  Color operator +(Color other) {
    return new Color(
        min(red + other.red, 255),
        min(green + other.green, 255),
        min(blue + other.blue, 255),
        alpha != null && other.alpha != null ? min(alpha + other.alpha, 1) : null);
  }

  Color operator -(Color other) {
    return new Color(
        max(red - other.red, 0),
        max(green - other.green, 0),
        max(blue - other.blue, 0),
        alpha != null && other.alpha != null ? max(alpha - other.alpha, 0) : null);
  }

  /// Output color as string in format specified [outputFormat]
  String toString() => alpha == null ? toRgbString() : toRgbaString();

  /// Output color in rgba format
  String toRgbaString() => "rgba($red, $green, $blue, ${alpha == null ? 1.0 : alpha})";

  /// Output color in rgb format
  String toRgbString() => "rgb($red, $green, $blue)";

  /// Ouput color in hex format
  String toHexString() => "${tohex(red)+tohex(green)+tohex(blue)}";

}