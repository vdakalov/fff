// Copyright (c) 2015, Viktor Dakalov. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library fff.test.color_parser;

import 'package:test/test.dart';
import 'package:fff/parser.dart';
import 'package:fff/color.dart';

main() {

  test("ColorParser from HEX", (){
    expect(ColorParser("#fff").toString(), "rgb(255, 255, 255)");
    expect(ColorParser("#FFF").toString(), "rgb(255, 255, 255)");
    expect(ColorParser("#fafafa").toString(), "rgb(250, 250, 250)");
    expect(ColorParser("#FAFAFA").toString(), "rgb(250, 250, 250)");
  });

  test("ColorParser fromList", (){
    expect(ColorParser([1]).toString(), "rgb(1, 0, 0)");
    expect(ColorParser([1,2]).toString(), "rgb(1, 2, 0)");
    expect(ColorParser([1,2,3]).toString(), "rgb(1, 2, 3)");
    expect(ColorParser([1,2,3,.4]).toString(), "rgba(1, 2, 3, 0.4)");

    expect(ColorParser([10, null, null, null]).toString(), "rgb(10, 0, 0)");
    expect(ColorParser([null, 10, null, null]).toString(), "rgb(0, 10, 0)");
    expect(ColorParser([null, null, 10, null]).toString(), "rgb(0, 0, 10)");
    expect(ColorParser([null, null, null, .1]).toString(), "rgba(0, 0, 0, 0.1)");
  });

  test("ColorParser fromMap", (){
    expect(ColorParser({"r": 1}).toString(), "rgb(1, 0, 0)");
    expect(ColorParser({"g": 2}).toString(), "rgb(0, 2, 0)");
    expect(ColorParser({"b": 3}).toString(), "rgb(0, 0, 3)");
    expect(ColorParser({"a": .4}).toString(), "rgba(0, 0, 0, 0.4)");
    expect(ColorParser({"r": 1, "g": 2, "b": 3, "a": .4}).toString(), "rgba(1, 2, 3, 0.4)");
  });

  test("List convention", (){
    var def = listConvention;

    listConvention = [Component.ALPHA, Component.BLUE, Component.GREEN, Component.RED];
    expect(ColorParser([.1, 3, 2, 1]).toString(), "rgba(1, 2, 3, 0.1)");

    listConvention = [Component.BLUE, Component.ALPHA];
    expect(ColorParser([3, .2]).toString(), "rgba(0, 0, 3, 0.2)");

    listConvention = def;
  });

  test("Map convensions",  (){
    var def = mapConventions;

    mapConventions.clear();
    expect(() => ColorParser({"R":1, "G": 2, "B": 3, "A": .1}), throwsA(isException));

    mapConventions.add(["X", "Y", "Z"]);
    mapConventions.add(["A", "B", "C", "D"]);
    mapConventions.add(["X", "Y", "Z", "A"]);
    mapConventions.add(["R", "G", "B", "A"]);

    expect(ColorParser({"X": 1, "Y": 2, "Z": 3, "T": .4}).toString(), "rgb(1, 2, 3)");
    expect(ColorParser({"A": 2, "B": 4, "C": 6, "D": .8}).toString(), "rgba(2, 4, 6, 0.8)");
    expect(ColorParser({"X": 1, "Y": 2, "Z": 3, "A": .4}).toString(), "rgba(1, 2, 3, 0.4)");
    expect(ColorParser({"R": 1, "G": 2, "B": 3, "A": .4}).toString(), "rgba(1, 2, 3, 0.4)");

    mapConventions = def;
  });

  test("Parse color", (){
    var rgb = "rgb(240, 240, 240)",
        rgba = "rgba(240, 240, 240, 1.0)",
        hex = "#f0f0f0", hex2 = "f0f0f0";

    expect(ColorParser(rgb).toRgbString(), rgb);
    expect(ColorParser(rgb).toRgbaString(), rgba);
    expect(ColorParser(rgb).toHexString(), hex2);

    expect(ColorParser(rgba).toRgbString(), rgb);
    expect(ColorParser(rgba).toRgbaString(), rgba);
    expect(ColorParser(rgba).toHexString(), hex2);

    expect(ColorParser(hex).toRgbString(), rgb);
    expect(ColorParser(hex).toRgbaString(), rgba);
    expect(ColorParser(hex).toHexString(), hex2);
  });

  test("Default values for ColorParser", (){
    DEF_RED = 50;
    DEF_GREEN = 50;
    DEF_BLUE = 50;
    DEF_ALPHA = .5;

    expect(() => ColorParser(), throwsA(isException));
    expect(ColorParser(100).toString(), "rgba(100, 50, 50, 0.5)");
    expect(ColorParser(null, 100).toString(), "rgba(50, 100, 50, 0.5)");
    expect(ColorParser(null, null, 100).toString(), "rgba(50, 50, 100, 0.5)");
    expect(ColorParser(null, null, null, .6).toString(), "rgba(50, 50, 50, 0.6)");

    DEF_RED = 0;
    DEF_GREEN = 0;
    DEF_BLUE = 0;
    DEF_ALPHA = null;
  });

  test("Arithmetics", (){
    expect(new Color(255) == ColorParser("#f00"), isTrue);
    expect(new Color(255, 255, 255) == ColorParser("rgb(255, 255, 255)"), isTrue);

    expect(new Color(255, 255, 255) == ColorParser("rgba(255, 255, 255, 1.0)"), isFalse);
    expect(new Color(255, 255, 255, 1.0) == ColorParser("#FFF"), isFalse);
  });

  test("Restrictions", (){
    expect(ColorParser(512), new Color(255));
    expect(ColorParser(-1024), new Color(0));
  });
}
