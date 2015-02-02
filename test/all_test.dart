// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library fff.test;

import 'package:unittest/unittest.dart';
import 'package:fff/fff.dart';

main() {

  test("Constructor without arguments",(){
    expect(new Color().toString(), "rgb(0, 0, 0)");
  });

  test("Constructor with arguments", (){
    expect(new Color(255).toString(), "rgb(255, 0, 0)");
    expect(new Color(null, 255).toString(), "rgb(0, 255, 0)");
    expect(new Color(null, null, 255).toString(), "rgb(0, 0, 255)");
    expect(new Color(null, null, null, .3).toString(), "rgba(0, 0, 0, 0.3)");
    expect(new Color(1, 2, 3, 0.4).toString(), "rgba(1, 2, 3, 0.4)");
  });

  test("Constructor from HEX", (){
    expect(new Color("#fff").toString(), "rgb(255, 255, 255)");
    expect(new Color("#FFF").toString(), "rgb(255, 255, 255)");
    expect(new Color("#fafafa").toString(), "rgb(250, 250, 250)");
    expect(new Color("#FAFAFA").toString(), "rgb(250, 250, 250)");
  });

  test("Constructor fromList", (){
    expect(new Color([1]).toString(), "rgb(1, 0, 0)");
    expect(new Color([1,2]).toString(), "rgb(1, 2, 0)");
    expect(new Color([1,2,3]).toString(), "rgb(1, 2, 3)");
    expect(new Color([1,2,3,.4]).toString(), "rgba(1, 2, 3, 0.4)");

    expect(new Color([10, null, null, null]).toString(), "rgb(10, 0, 0)");
    expect(new Color([null, 10, null, null]).toString(), "rgb(0, 10, 0)");
    expect(new Color([null, null, 10, null]).toString(), "rgb(0, 0, 10)");
    expect(new Color([null, null, null, .1]).toString(), "rgba(0, 0, 0, 0.1)");
  });

  test("Constructor fromMap", (){

    expect(new Color({"r": 1}).toString(), "rgb(1, 0, 0)");
    expect(new Color({"g": 2}).toString(), "rgb(0, 2, 0)");
    expect(new Color({"b": 3}).toString(), "rgb(0, 0, 3)");
    expect(new Color({"a": .4}).toString(), "rgba(0, 0, 0, 0.4)");

    expect(new Color({"r": 1, "g": 2, "b": 3, "a": .4}).toString(), "rgba(1, 2, 3, 0.4)");

  });

  test("List convention", (){
    var def = listConvention;

    listConvention = [ALPHA, BLUE, GREEN, RED];
    expect(new Color([.1, 3, 2, 1]).toString(), "rgba(1, 2, 3, 0.1)");

    listConvention = [BLUE, ALPHA];
    expect(new Color([3, .2]).toString(), "rgba(0, 0, 3, 0.2)");

    listConvention = def;
  });

  test("Map convensions",  (){

    var def = mapConventions;

    mapConventions.clear();
    expect(() => new Color({"R":1, "G": 2, "B": 3, "A": .1}), throwsA(isException));

    mapConventions.add(["X", "Y", "Z", "T"]);
    mapConventions.add(["A", "B", "C", "D"]);
    mapConventions.add(["X", "Y", "Z", "T"]);
    mapConventions.add(["R", "G", "B", "A"]);

    expect(new Color({"X": 1, "Y": 2, "Z": 3, "T": .4}).toString(), "rgba(1, 2, 3, 0.4)");
    expect(new Color({"A": 2, "B": 4, "C": 6, "D": .8}).toString(), "rgba(2, 4, 6, 0.8)");
    expect(new Color({"X": 1, "Y": 2, "Z": 3, "T": .4}).toString(), "rgba(1, 2, 3, 0.4)");
    expect(new Color({"R": 1, "G": 2, "B": 3, "A": .4}).toString(), "rgba(1, 2, 3, 0.4)");

    mapConventions = def;

  });

  test("Output format", (){

    expect(new Color(255).toString(), "rgb(255, 0, 0)");
    expect(new Color(255).toRgbString(), "rgb(255, 0, 0)");

    expect(new Color(255, 0, 0, 1.0).toString(), "rgba(255, 0, 0, 1.0)");
    expect(new Color(255, 0, 0, 1.0).toRgbaString(), "rgba(255, 0, 0, 1.0)");

    expect(new Color(255, 0, 0).toHexString(), "#ff0000");

  });

  test("Parse color", (){

    var rgb = "rgb(240, 240, 240)",
        rgba = "rgba(240, 240, 240, 1.0)",
        hex = "#f0f0f0";

    expect(new Color(rgb).toRgbString(), rgb);
    expect(new Color(rgb).toRgbaString(), rgba);
    expect(new Color(rgb).toHexString(), hex);

    expect(new Color(rgba).toRgbString(), rgb);
    expect(new Color(rgba).toRgbaString(), rgba);
    expect(new Color(rgba).toHexString(), hex);

    expect(new Color(hex).toRgbString(), rgb);
    expect(new Color(hex).toRgbaString(), rgba);
    expect(new Color(hex).toHexString(), hex);

  });

  test("Clone method", (){
    expect(new Color(255, 255, 255, .5).clone().toString(), "rgba(255, 255, 255, 0.5)");
  });

  test("Default values", (){

    DEF_RED = 50;
    DEF_GREEN = 50;
    DEF_BLUE = 50;
    DEF_ALPHA = .5;

    expect(new Color().toString(), "rgba(50, 50, 50, 0.5)");
    expect(new Color(100).toString(), "rgba(100, 50, 50, 0.5)");
    expect(new Color(null, 100).toString(), "rgba(50, 100, 50, 0.5)");
    expect(new Color(null, null, 100).toString(), "rgba(50, 50, 100, 0.5)");
    expect(new Color(null, null, null, .6).toString(), "rgba(50, 50, 50, 0.6)");

    DEF_RED = 0;
    DEF_GREEN = 0;
    DEF_BLUE = 0;
    DEF_ALPHA = null;

  });

  test("Arithmetics", (){

    expect(new Color(255) + new Color(0, 255), new Color(255, 255));
    expect(new Color(255) - new Color(100), new Color(155, 0, 0));

    expect(new Color(255) == "#f00", isTrue);
    expect(new Color(255, 255, 255) == "rgb(255, 255, 255)", isTrue);

    expect(new Color(255, 255, 255) == "rgba(255, 255, 255, 1.0)", isFalse);
    expect(new Color(255, 255, 255, 1.0) == "#FFF", isFalse);

  });

}
