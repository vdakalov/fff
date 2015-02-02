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

List<num> _parseComponents(String input, String prefix, [String postfix = ")"]) {
  if (input.startsWith(prefix) && input.contains(postfix)) {
    return new List<num>.from(
        input.substring(prefix.length, input.indexOf(postfix)).split(",")
        .map(_fromnum).toList());
  }
  return <num>[];
}

List<num> _parseRgb(String input) => _parseComponents(input, "rgb(");

List<num> _parseRgba(String input) => _parseComponents(input, "rgba(");

List<num> _parseHex(String input) {

  if (input.length == 3) {
    return [input.substring(0, 1),
            input.substring(1, 2),
            input.substring(2, 3)].map(_fromhex).toList();
  }

  if (input.length == 6) {
    return [input.substring(0, 2),
            input.substring(2, 4),
            input.substring(4, 6)].map(_fromhex).toList();
  }

  return [];
}

List _parseList(List<num> input) {
  int ri = listConvention.indexOf(RED),
      gi = listConvention.indexOf(GREEN),
      bi = listConvention.indexOf(BLUE),
      ai = listConvention.indexOf(ALPHA);

  return [ri >= 0 && input.length > ri ? input[ri] : null,
          gi >= 0 && input.length > gi ? input[gi] : null,
          bi >= 0 && input.length > bi ? input[bi] : null,
          ai >= 0 && input.length > ai ? input[ai] : null];
}

List _parseMap(Map<dynamic, num> input) {
  var convs = new List<List<String>>.from(mapConventions).reversed.toList(),
      conv,
      result = new List(),
      num = 4;

  if (convs.length == 0) {
    throw new Exception("To create an object of Color from data a map type, you need specify one or more map conventions");
  }

  for (int index = 0; index < convs.length; index++) {
    var conv = convs[index], c = conv.length;

    for (int j = 0; j < conv.length; j++) {
      if (input.containsKey(conv[j])) {
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

  conv = result.firstWhere((c) => c is List);

  return [input[conv[0]], input[conv[1]], input[conv[2]], input[conv[3]]];
}

List _parseArgs(List<num> args) {
  return [args.length > 0 && args[0] is num ? args[0].toInt() : DEF_RED,
          args.length > 1 && args[1] is num ? args[1].toInt() : DEF_GREEN,
          args.length > 2 && args[2] is num ? args[2].toInt() : DEF_BLUE,
          args.length > 3 && args[3] is num ? args[3].toDouble() : DEF_ALPHA];
}

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
double DEF_ALPHA = null;

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
  const Color._(this.red, this.green, this.blue, this.alpha);

  factory Color([dynamic red, num green, num blue, num alpha]) {

    List<num> args = [];

    if (red is String) {
      if (red.contains(")")) {

        if (red.startsWith("rgba(")) {
          args = _parseComponents(red, "rgba(");

        } else if (red.startsWith("rgb(")) {
          args = _parseComponents(red, "rgb(");

        }

      } else if (red.startsWith("#")) {
        args = _parseHex(red.substring(1));

      }

    } else if (red is List<num>) {
      args = _parseList(red);

    } else if (red is Map<dynamic, num>) {
      args = _parseMap(red);

    } else {
      args = [red, green, blue, alpha];

    }

    args = _parseArgs(args);

    return new Color._(args[0], args[1], args[2], args[3]);
  }

  bool operator ==(dynamic other) {
    other = other is Color ? other : new Color(other);
    return red == other.red && green == other.green && blue == other.blue &&
        alpha == other.alpha;
  }

  Color operator +(Color other) {
    return new Color(
        _min(red + other.red, 255),
        _min(green + other.green, 255),
        _min(blue + other.blue, 255),
        alpha != null && other.alpha != null ? _min(alpha + other.alpha, 1) : null);
  }

  Color operator -(Color other) {
    return new Color(
        _max(red - other.red, 0),
        _max(green - other.green, 0),
        _max(blue - other.blue, 0),
        alpha != null && other.alpha != null ? _max(alpha - other.alpha, 0) : null);
  }

  /// Create new [Color] from it
  Color clone() {
    return new Color(red, green, blue, alpha);
  }

  /// Output color as string in format specified [outputFormat]
  String toString() => alpha == null ? toRgbString() : toRgbaString();

  /// Output color in rgba format
  String toRgbaString() => "rgba($red, $green, $blue, ${alpha == null ? 1.0 : alpha})";

  /// Output color in rgb format
  String toRgbString() => "rgb($red, $green, $blue)";

  /// Ouput color in hex format
  String toHexString() => "#${_tohex(red)+_tohex(green)+_tohex(blue)}";

}