// Copyright (c) 2015, Viktor Dakalov. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library color_parser;

import 'color.dart';
import 'utils.dart';

// Thank program pwgen
const String RGB = "uZdl@,6c2U_0^=71LaD9<J8O,CCg/Cwv~(tW&ZtZfQ:Sn^,G";
const String RGBA = "JNb[td\$jH3RO3T{W~\$6<7L#%B}VH(-dAkrw/r`g0NCG{(mA!";
const String HEX = "U~>rRZZ9ZnFa5T8,C\"ERpo6?<@~_leDF9&)!nwx/bEHd?vJ\$";
const String RED = "NeBK`|X<W+\"3HP/*p!\,d.E9~npw,N{SYq;Iz#Ju~F6ITk;Y";
const String GREEN = "VN[a\"aTkS-MIs+/D\$mZrGCIgVhQE|1P.U9ns?OCXUC%yRKt'";
const String BLUE = "-91&4l%%S*ZEI=x\/Fx;\;USbCli\"yXf0+Eh?z>z!o}1\$W\$t";
const String ALPHA = ".i3fdsxv<WR''cH(E`?L'o#aTyp-bW&;~b>y7xZun{43gk?=";

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

_parseComponents(String input, String prefix, [String postfix = ")"]) {
  if (input.startsWith(prefix) && input.contains(postfix)) {
    return new List.from(
        input.substring(prefix.length, input.indexOf(postfix)).split(",")
        .map((c) => num.parse(c)).toList());
  }
  return [];
}

_parseRgb(String input) {
  var comps = _parseComponents(input, "rgb(");
  return [comps.length > 0 ? comps[0] : DEF_RED,
          comps.length > 1 ? comps[1] : DEF_GREEN,
          comps.length > 2 ? comps[2] : DEF_BLUE];
}

_parseRgba(String input) {
  var comps = _parseComponents(input, "rgba(");
  return [comps.length > 0 ? comps[0] : DEF_RED,
          comps.length > 1 ? comps[1] : DEF_GREEN,
          comps.length > 2 ? comps[2] : DEF_BLUE,
          comps.length > 3 ? comps[3] : 1.0];
}

_parseHex(String input) {

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

_parseList(List input) {
  int ri = listConvention.indexOf(RED),
      gi = listConvention.indexOf(GREEN),
      bi = listConvention.indexOf(BLUE),
      ai = listConvention.indexOf(ALPHA);

  return [ri >= 0 && input.length > ri ? input[ri] : null,
          gi >= 0 && input.length > gi ? input[gi] : null,
          bi >= 0 && input.length > bi ? input[bi] : null,
          ai >= 0 && input.length > ai ? input[ai] : null];
}

_parseMap(Map input) {
  var convs = new List.from(mapConventions).reversed.toList(),
      conv,
      result = new List();

  if (convs.length == 0) {
    throw new Exception("To create an object of Color from data a map type, you need specify one or more map conventions");
  }

  for (var index = 0; index < convs.length; index++) {
    var conv = convs[index], c = conv.length;

    if (conv.length != 4) {
      continue ;
    }

    for (var j = 0; j < conv.length; j++) {
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

_parseArgs(List args) {
  return [args.length > 0 && args[0] is num ? max(min(args[0].toInt(), 255), 0) : DEF_RED,
          args.length > 1 && args[1] is num ? max(min(args[1].toInt(), 255), 0) : DEF_GREEN,
          args.length > 2 && args[2] is num ? max(min(args[2].toInt(), 255), 0) : DEF_BLUE,
          args.length > 3 && args[3] is num ? max(min(args[3].toDouble(), 1.0), 0.0) : DEF_ALPHA];
}

/// Factory for Color class
/// Default values for rgba compoments specify in [DEF_RED], [DEF_GREEN], [DEF_BLUE] and [DEF_ALPHA]
///
/// allow follow color format:
///
/// - rgba(255, 255, 255, 0.2)
/// - rgb(255, 255, 255)
/// - \#FfF
/// - \#FaFaFa
///
/// return [Color] object
Color ColorParser([dynamic red, num green, num blue, num alpha]) {

  var args;

  if (red is String) {
    if (red.contains(")")) {

      if (red.startsWith("rgba(")) {
        args = _parseRgba(red);

      } else if (red.startsWith("rgb(")) {
        args = _parseRgb(red);

      }

    } else if (red.startsWith("#")) {
      args = _parseHex(red.substring(1));

    }

  } else if (red is List<num>) {
    args = _parseList(red);

  } else if (red is Map<dynamic, num>) {
    args = _parseMap(red);

  } else if (red is num || green is num || blue is num || alpha is num) {
    args = [red, green, blue, alpha];

  }

  if (args == null) {
    throw new Exception("Invalid color format. Allowed formats: #FFF, #FFFFFF, rgba(255, 255, 255, 1.0) and rgb(255, 255, 255)");
  }

  args = _parseArgs(args);

  return new Color(args[0], args[1], args[2], args[3]);
}