// Copyright (c) 2015, Viktor Dakalov. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library color;

import 'utils.dart';

class Color {

  /// Return red component (0-255).
  final int red;

  /// Return green component (0-255).
  final int green;

  /// Return blue component (0-255).
  final int blue;

  /// Return opacity level (null or 0-1)
  final double alpha;

  /// Constructor create [Color] from rgba components.
  /// Default value for rgb component is 0, for alpha - null
  /// For color with specified alpha component output format will be rgba.
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
        alpha == null ? alpha : min(alpha + (other.alpha == null ? 1.0 : other.alpha), 1.0));
  }

  Color operator -(Color other) {
    return new Color(
        max(red - other.red, 0),
        max(green - other.green, 0),
        max(blue - other.blue, 0),
        alpha == null ? alpha : max(alpha - (other.alpha == null ? 1.0 : other.alpha), 0.0));
  }

  /// Output color as string in rgba(r, g, b, a) or rgb(r, g, b) format
  String toString() => alpha == null ? toRgbString() : toRgbaString();

  /// Output color in rgba format
  String toRgbaString() => "rgba($red, $green, $blue, ${alpha == null ? 1.0 : alpha})";

  /// Output color in rgb format
  String toRgbString() => "rgb($red, $green, $blue)";

  /// Ouput color in hex format
  String toHexString() => "${tohex(red)+tohex(green)+tohex(blue)}";

}