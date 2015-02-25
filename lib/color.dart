// Copyright (c) 2015, Viktor Dakalov. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library color;

import 'parser.dart' show RED, GREEN, BLUE, ALPHA;
import 'utils.dart';

class Color {

  /// Return red component (0-255)
  final int red;

  /// Return green component (0-255)
  final int green;

  /// Return blue component (0-255)
  final int blue;

  /// Return opacity level (null or 0-1)
  final double alpha;

  /// Constructor create [Color] from rgba components.
  /// Default value for [red], [green] and [blue] component is 0, for [alpha]- null
  /// For color with specified [alpha] component output format will be rgba.
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
  String toHexString() => tohex(red) + tohex(green) + tohex(blue);

  /// Output color as [List] object
  /// By default, the list will be output in rgb or rgba format, depending on
  /// the format of this object. You can also specify an arbitrary number and
  /// order of the components are specify in the [template]. Default values rgb
  /// component output as int. You can change this bypassing a true argument
  /// [asDouble]. All rgb components of the default set in the range of 0-255,
  /// but you can change this by specifying a range argument [range] from 0-range
  /// (eg from 0 to 1). It is also possible to deduce the components several
  /// times, specify the argument [rows]. This may be necessary when you need to
  /// set the same color for each vertex in the polygon 3D model.
  List toList({
    List template, bool asDouble: false, int range, int rows: 1}) {

    var values = [red, green, blue, alpha],
        defEnd = 255,
        end = range is int ? range : defEnd,
        comps = template == null && alpha == null ?
            [RED, GREEN, BLUE] : [RED, GREEN, BLUE, ALPHA],
        target = template == null ?
            new List.from(comps) : new List.from(template);

    for (var index = 0; index < comps.length; ) {
      var pos = target.indexOf(comps[index]), isAlpha = comps[index] == ALPHA,
          value = values[index];
      if (pos is int && pos >= 0) {
        if (isAlpha) {
          value = value == null ? 1.0 : value;
        }
        if (value is int && asDouble) {
          value = value.toDouble();
        }
        if (value is int && end != defEnd && !isAlpha) {
          value = range / defEnd * value;
        }
        target[pos] = value;
      } else {
        index++;
      }
    }

    if (rows > 1) {
      var _target = new List.from(target);
      while (rows-- > 1) {
        target.addAll(_target);
      }
    }

    return target;
  }

  /// Output color as [Map] object
  /// By default, the map will be output with the keys "red", "green" and
  /// "blue". "alpha" will be displayed depending on the format of the object.
  /// You can also specify an arbitrary number of components of said [template].
  /// Default values rgb component output as int. You can change this by
  /// passing a true argument [asDouble]. All rgb components of the default set
  /// in the range of 0-255, but you can change this by specifying a [range]
  /// argument needs range from 0-range (eg from 0 to 1).
  Map toMap({Map template, bool asDouble: false, int range}) {

    var defKeys = ["red", "green", "blue", "alpha"],
        comps = template == null && alpha == null ? [RED, GREEN, BLUE] :
          [RED, GREEN, BLUE, ALPHA],
        target = template is Map ? template :
          new Map.fromIterables(defKeys.sublist(0, comps.length), comps);

    return new Map.fromIterables(target.keys,
        toList(template: target.values.toList(),
               asDouble: asDouble,
               range: range));
  }

}
