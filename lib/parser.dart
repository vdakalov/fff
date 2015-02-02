library color_parser;

import 'package:fff/color.dart';
import 'package:fff/utils.dart';

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

List<num> _parseComponents(String input, String prefix, [String postfix = ")"]) {
  if (input.startsWith(prefix) && input.contains(postfix)) {
    return new List<num>.from(
        input.substring(prefix.length, input.indexOf(postfix)).split(",")
        .map(fromnum).toList());
  }
  return <num>[];
}

List<num> _parseRgb(String input) => _parseComponents(input, "rgb(");

List<num> _parseRgba(String input) => _parseComponents(input, "rgba(");

List<num> _parseHex(String input) {

  if (input.length == 3) {
    return [input.substring(0, 1),
            input.substring(1, 2),
            input.substring(2, 3)].map(fromhex).toList();
  }

  if (input.length == 6) {
    return [input.substring(0, 2),
            input.substring(2, 4),
            input.substring(4, 6)].map(fromhex).toList();
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

Color ColorParser([dynamic red, num green, num blue, num alpha]) {

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

  return new Color(args[0], args[1], args[2], args[3]);
}