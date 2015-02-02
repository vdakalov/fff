// Copyright (c) 2015, Viktor Dakalov. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library fff;

_min(num a, num b) => a <= b ? a : b;
_max(num a, num b) => a >= b ? a : b;
_hexin(String comp) => comp.length == 1 ? comp + comp : comp;
_hexout(String comp) => comp.length == 1 ? "0$comp" : comp;
_tohex(num comp) => _hexout(comp.toInt().toRadixString(16));
_fromhex(String comp) => int.parse(_hexin(comp), radix: 16);
_fromnum(String num) => num.contains(".") ? double.parse(num.trim()) : int.parse(num.trim());

const String RGB = "rgb";
const String RGBA = "rgba";
const String HEX = "hex";

const String RED = "r";
const String GREEN = "g";
const String BLUE = "b";
const String ALPHA = "a";

/// Default red component
num DEF_RED = 0;

/// Default green component
num DEF_GREEN = 0;

/// Default blue component
num DEF_BLUE = 0;

/// Default alpha component
double DEF_ALPHA = 1.0;

/// Output color format by default
///
///     FORMAT = Color.HEX;
///     print(new Color()); // #000000
///     print(Color.red().r); // FF
///
///     FORMAT = Color.RGB
///     print(new Color()) // rgb(0, 0, 0)
///
String FORMAT = RGBA;

/// Agreement on the map color format
List<List<String>> mapConventions = [['r','g','b','a'],['x','y','z','a']];

/// Agreement on the list color format
List<String> listConvention = [RED, GREEN, BLUE, ALPHA];


/// Class for works with color
///
/// from rgb components
///
///     new Color(115, 225, 55);
///     Color.parse("rgb(115, 225, 55)");
///
/// from rgba components
///
///     new Color(90, 90, 255, 0.5);
///     Color.parse("rgba(90, 90, 255, 0.5)");
///
/// from hex string
///
///     new Color.fromHex("FfAacc");
///     Color.parse("#ffaaCC");
///
/// from rgba list
///
///     //          G  B  R  A
///     var gbra = [2, 3, 1, 0];
///     // change convention to [g,b,r,a] (defaul convention [r,g,b,a])
///     Color.listConvention = [Color.GREEN, Color.BLUE, Color.RED, Color.ALPHA];
///     new Color.fromList(grba);
///
/// from map
///
///     var abc = {"AA": 10, "BB": 20, "CC": 30};
///     //                        R     G     B
///     Color.mapConventions.add(["AA", "BB", "CC"]);
///     new Color.fromMap(abc);
///
/// default colors
///
///     Color.black() == new Color(0, 0, 0) == Color.parse('#000000')
///
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
  const Color._([this.red, this.green, this.blue, this.alpha]);

  factory Color([dynamic red, num green, num blue, num alpha]) {

    if (red is String) {
      if (red.contains(")") &&
          (red.startsWith("rgba(") || red.startsWith("rgb("))) {
        var comps = red
            .substring(red.indexOf("(") + 1, red.indexOf(")")).split(",")
            .map(_fromnum).toList();
        return new Color._(
            comps.length > 0 ? comps[0] : DEF_RED,
            comps.length > 1 ? comps[1] : DEF_GREEN,
            comps.length > 2 ? comps[2] : DEF_BLUE,
            comps.length > 3 ? comps[3] : DEF_ALPHA);

      } else if (red.startsWith("#")) {

        String hexR, hexG, hexB;

        if (red.length == 4) {
          hexR = red.substring(1, 2);
          hexG = red.substring(2, 3);
          hexB = red.substring(3, 4);
        }

        if (red.length == 7) {
          hexR = red.substring(1, 3);
          hexG = red.substring(3, 5);
          hexB = red.substring(5, 7);
        }

        return new Color._(
            hexR is String ? _fromhex(hexR) : DEF_RED,
            hexG is String ? _fromhex(hexG) : DEF_GREEN,
            hexB is String ? _fromhex(hexB) : DEF_BLUE,
            DEF_ALPHA);
      }

    } else if (red is List<num>) {
      int ri = listConvention.indexOf(RED),
          gi = listConvention.indexOf(GREEN),
          bi = listConvention.indexOf(BLUE),
          ai = listConvention.indexOf(ALPHA);

      var r = ri >= 0 && red.length > ri ? red[ri].toInt() : DEF_RED,
          g = gi >= 0 && red.length > gi ? red[gi].toInt() : DEF_GREEN,
          b = bi >= 0 && red.length > bi ? red[bi].toInt() : DEF_BLUE,
          a = ai >= 0 && red.length > ai ? red[ai].toDouble() : DEF_ALPHA;

      return new Color._(r, g, b, a);

    } else if (red is Map<dynamic, num>) {
      var convs = new List<List<String>>.from(mapConventions).reversed.toList(),
          result = new List(),
          num = 4;

      if (convs.length == 0) {
        throw new Exception("To create an object of Color from data a map type, you need specify one or more map conventions");
      }

      for (int index = 0; index < convs.length; index++) {
        var conv = convs[index], c = conv.length;

        for (int j = 0; j < conv.length; j++) {
          if (red.containsKey(conv[j])) {
            c--;
          }
        }

        if (c >= result.length) {
          result.length = c + 1;
        }

        result.insert(c, conv);
      }

      if (result.length == 0) {
        throw new Exception("The properties of the map does not match any of the conventions");
      }

      var conv = result.firstWhere((c) => c is List),
          r = red.containsKey(conv[0]) ? red[conv[0]].toInt() : DEF_RED,
          g = red.containsKey(conv[1]) ? red[conv[1]].toInt() : DEF_GREEN,
          b = red.containsKey(conv[2]) ? red[conv[2]].toInt() : DEF_BLUE,
          a = red.containsKey(conv[3]) ? red[conv[3]].toDouble() : DEF_ALPHA;

      return new Color._(r, g, b, a);

    }

    return new Color._(
        red is num ? red.toInt() : DEF_RED,
        green is num ? green.toInt() : DEF_GREEN,
        blue is num ? blue.toInt() : DEF_BLUE,
        alpha is num ? alpha.toDouble() : DEF_ALPHA);
  }

  bool operator ==(dynamic other) {
    other = other is Color ? other : new Color(other);
    return red == other.red && green == other.green && blue == other.blue &&
        alpha == other.alpha;
  }

  Color operator +(Color color) {
    double r = _min(red + color.red, 255.0),
           g = _min(green + color.green, 255.0),
           b = _min(blue + color.blue, 255.0),
           a = _min(alpha + color.alpha, 1.0);
    return new Color(r, g, b, a);
  }

  Color operator -(Color color) {
    double r = _max(red - color.red, 0.0),
           g = _max(green - color.green, 0.0),
           b = _max(blue - color.blue, 0.0),
           a = _max(alpha - color.alpha, 0.0);
    return new Color(r, g, b, a);
  }

  /// Create new [Color] from it
  Color clone() {
    return new Color(red, green, blue, alpha);
  }

  /// Output color as string in format specified [outputFormat]
  String toString() {
    switch (FORMAT) {
      case RGB: return toRgbString();
      case HEX: return toHexString();
      default: return toRgbaString();
    }
  }

  /// Output color in rgba format
  String toRgbaString() => "rgba($red, $green, $blue, $alpha)";

  /// Output color in rgb format
  String toRgbString() => "rgb($red, $green, $blue)";

  /// Ouput color in hex format
  String toHexString() => "#${_tohex(red)+_tohex(green)+_tohex(blue)}";

}