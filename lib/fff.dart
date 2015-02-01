// Copyright (c) 2015, Viktor Dakalov. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library fff;

_min(num a, num b) => a <= b ? a : b;
_max(num a, num b) => a >= b ? a : b;
_hexin(String comp) => comp.length == 1 ? comp + comp : comp;
_hexout(String comp) => comp.length == 1 ? "0$comp" : comp;
_tohex(num comp) => _hexout(comp.toInt().toRadixString(16));
_fromhex(String comp) => int.parse(_hexin(comp), radix: 16);

const String _RGB = "rgb";
const String _RGBA = "rgba";
const String _HEX = "hex";

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

  /// Return black [Color] object
  static Color black() => new Color();

  /// Return red [Color] object
  static Color red() => new Color(255, 0, 0, 1);

  /// Return green [Color] object
  static Color green() => new Color(0, 255, 0, 1);

  /// Return blue [Color] object
  static Color blue() => new Color(0, 0, 255, 1);

  /// Return white [Color] object
  static Color white() => new Color(255, 255, 255, 1);

  /// Return gray [Color] object
  static Color gray() => new Color(127.5, 127.5, 127.5, 1);

  static final String RGB = _RGB;
  static final String RGBA = _RGBA;
  static final String HEX = _HEX;

  static final String RED = "r";
  static final String GREEN = "g";
  static final String BLUE = "b";
  static final String ALPHA = "a";

  /// Default red component
  static num DEF_RED = 0;

  /// Default green component
  static num DEF_GREEN = 0;

  /// Default blue component
  static num DEF_BLUE = 0;

  /// Default alpha component
  static num DEF_ALPHA = 1;

  /// Agreement on the map color format
  static List<List<String>> mapConventions = [['r','g','b','a'],['x','y','z','a']];

  /// Agreement on the list color format
  static List<String> listConvention = [RED, GREEN, BLUE, ALPHA];

  /// Output color format by default
  ///
  ///     Color.outputFormat = Color.HEX;
  ///     print(new Color()); // #000000
  ///     print(Color.red().r); // FF
  ///
  ///     Color.outputFormat = Color.RGB
  ///     print(new Color()) // rgb(0, 0, 0)
  ///
  static String outputFormat = RGBA;

  /// Return red component.
  /// Output format specified in [outputFormat]
  dynamic get r => outputFormat == HEX ? _tohex(components[0]) : components[0].toInt();
  void set r(num value) { components[0] = value.toDouble(); }

  /// Return red component.
  /// Output format specified in [outputFormat]
  dynamic get g => outputFormat == HEX ? _tohex(components[1]) : components[1].toInt();
  void set g(num value) { components[1] = value.toDouble(); }

  /// Return red component.
  /// Output format specified in [outputFormat]
  dynamic get b => outputFormat == HEX ? _tohex(components[2]) : components[2].toInt();
  void set b(num value) { components[2] = value.toDouble(); }

  /// Return opacity level
  double get a => components[3];
  void set a(num value) { components[3] = value.toDouble(); }

  /// Color components in [r,g,b,a] format
  List<double> components = new List<double>(4);

  /// Constructor create [Color] from rgba components.
  /// Instead not transmitted component will be used by default components
  Color([num red, num green, num blue, num alpha]) {
    _fromArgs(red, green, blue, alpha);
  }

  /// Create [Color] object from list of components.
  /// To change the order of the component use [listConvention]
  Color.fromList(List<num> input) {
    _fromList(input);
  }

  /// Create [Color] object from map of components.
  /// You can also specify the appropriate fields and components in [mapConventions]
  Color.fromMap(Map<String, num> input) {
    _fromMap(input);
  }

  /// Create [Color] object from hex color format.
  /// Allow use as "ffAAff" or "faF"
  Color.fromHex(String input) {
    _fromHex(input.toLowerCase());
  }


  /// Parsing a string containing the color.
  /// Allow formats:
  ///
  /// - rgb(255, 255, 255)
  /// - rgba(255, 255, 255, 0.9)
  /// - #abc
  /// - #afbfcf
  ///
  /// return Color object or null
  static Color parse(String source) {
    if (source.contains(")") &&
        (source.startsWith("rgba(") || source.startsWith("rgb("))) {
      var comps = source
          .substring(source.indexOf("(") + 1, source.indexOf(")")).split(",")
          .map((c) =>
              c.indexOf(".") >= 0 ? double.parse(c.trim()) : int.parse(c.trim()) )
          .toList();
      return new Color(comps[0], comps[1], comps[2], comps.length == 4 ? comps[3] : null);

    } else if (source.startsWith("#")) {
      return new Color.fromHex(source.substring(1));
    }

    return null;
  }

  _fromArgs(num r, num g, num b, num a) {
    components[0] = (r is num ? _min(_max(r, 0), 255) : DEF_RED).toDouble();
    components[1] = (g is num ? _min(_max(g, 0), 255) : DEF_GREEN).toDouble();
    components[2] = (b is num ? _min(_max(b, 0), 255) : DEF_BLUE).toDouble();
    components[3] = (a is num ? _min(_max(a, 0), 1) : DEF_ALPHA).toDouble();
  }

  _fromMap(Map comps) {

    var convs = new List<List<String>>.from(mapConventions).reversed.toList(),
        result = new List(),
        num = 4;

    if (convs.length == 0) {
      throw new Exception("To create an object of Color from data a map type, you need specify one or more map conventions");
    }

    for (int index = 0; index < convs.length; index++) {
      var conv = convs[index], c = conv.length;

      for (int j = 0; j < conv.length; j++) {
        if (comps.containsKey(conv[j])) {
          c--;
        }
      }

      if (c >= result.length) {
        result.length = c + 1;
      }

      result.insert(c, conv);
    }

    if (result.length > 0) {
      var conv = result.firstWhere((c) => c is List),
          r = conv.length > 0 ? comps[conv[0]] : null,
          g = conv.length > 1 ? comps[conv[1]] : null,
          b = conv.length > 2 ? comps[conv[2]] : null,
          a = conv.length > 3 ? comps[conv[3]] : null;

      _fromArgs(r, g, b, a);
    }

  }

  _fromList(List comps) {

    int ri = listConvention.indexOf(RED),
        gi = listConvention.indexOf(GREEN),
        bi = listConvention.indexOf(BLUE),
        ai = listConvention.indexOf(ALPHA);

    var r = ri >= 0 && comps.length > ri ? comps[ri] : DEF_RED,
        g = gi >= 0 && comps.length > gi ? comps[gi] : DEF_GREEN,
        b = bi >= 0 && comps.length > bi ? comps[bi] : DEF_BLUE,
        a = ai >= 0 && comps.length > ai ? comps[ai] : DEF_ALPHA;

    _fromArgs(r, g, b, a);
  }

  _fromHex(String hex) {

    String hexR = hex.substring(0, 1),
           hexG = hex.substring(1, 2),
           hexB = hex.substring(2, 3);

    if (hex.length == 6) {
      hexR = hex.substring(0, 2);
      hexG = hex.substring(2, 4);
      hexB = hex.substring(4, 6);
    }

    _fromArgs(_fromhex(hexR), _fromhex(hexG), _fromhex(hexB), 1);
  }

  _asHex() {
    return [_tohex(components[0]), _tohex(components[1]), _tohex(components[2])];
  }

  bool operator ==(Color other) {
    return components[0] == other.components[0] &&
        components[1] == other.components[1] &&
        components[2] == other.components[2] &&
        components[3] == other.components[3];
  }

  Color operator +(Color color) {
    double r = _min(components[0] + color.components[0], 255.0),
           g = _min(components[1] + color.components[1], 255.0),
           b = _min(components[2] + color.components[2], 255.0),
           a = _min(components[3] + color.components[3], 1.0);
    return new Color(r, g, b, a);
  }

  Color operator -(Color color) {
    double r = _max(components[0] - color.components[0], 0.0),
           g = _max(components[1] - color.components[1], 0.0),
           b = _max(components[2] - color.components[2], 0.0),
           a = _max(components[3] - color.components[3], 1.0);
    return new Color(r, g, b, a);
  }

  /// Create new [Color] from it
  Color clone() {
    return new Color.fromList(components);
  }

  /// Output color as string in format specified [outputFormat]
  String toString() {
    switch (outputFormat) {
      case _RGB: return toRGBString();
      case _HEX: return toHEXString();
    }
    return toRGBAString();
  }

  /// Output color in rgba format
  String toRGBAString() => "rgba($r, $g, $b, $a)";

  /// Output color in rgb format
  String toRGBString() => "rgb($r, $g, $b)";

  /// Ouput color in hex format
  String toHEXString() => "#${_asHex().join()}";

}