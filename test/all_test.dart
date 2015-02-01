// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library fff.test;

import 'package:unittest/unittest.dart';
import 'package:fff/fff.dart';

main() {

  test("Constructor without arguments",(){
    expect(new Color().toString(), "rgba(0, 0, 0, 1.0)");
  });

  test("Constructor with arguments", (){
    expect(new Color(255).toString(), "rgba(255, 0, 0, 1.0)");
    expect(new Color(null, 255).toString(), "rgba(0, 255, 0, 1.0)");
    expect(new Color(null, null, 255).toString(), "rgba(0, 0, 255, 1.0)");
    expect(new Color(null, null, null, .3).toString(), "rgba(0, 0, 0, 0.3)");
    expect(new Color(1, 2, 3, 0.4).toString(), "rgba(1, 2, 3, 0.4)");
  });

  test("Constructor from HEX", (){
    expect(new Color.fromHex("fff").toString(), "rgba(255, 255, 255, 1.0)");
    expect(new Color.fromHex("FFF").toString(), "rgba(255, 255, 255, 1.0)");
    expect(new Color.fromHex("fafafa").toString(), "rgba(250, 250, 250, 1.0)");
    expect(new Color.fromHex("FAFAFA").toString(), "rgba(250, 250, 250, 1.0)");
  });

  test("Constructor fromList", (){
    expect(new Color.fromList([1]).toString(), "rgba(1, 0, 0, 1.0)");
    expect(new Color.fromList([1,2]).toString(), "rgba(1, 2, 0, 1.0)");
    expect(new Color.fromList([1,2,3]).toString(), "rgba(1, 2, 3, 1.0)");
    expect(new Color.fromList([1,2,3,.4]).toString(), "rgba(1, 2, 3, 0.4)");

    expect(new Color.fromList([10, null, null, null]).toString(), "rgba(10, 0, 0, 1.0)");
    expect(new Color.fromList([null, 10, null, null]).toString(), "rgba(0, 10, 0, 1.0)");
    expect(new Color.fromList([null, null, 10, null]).toString(), "rgba(0, 0, 10, 1.0)");
    expect(new Color.fromList([null, null, null, .1]).toString(), "rgba(0, 0, 0, 0.1)");
  });

  test("Constructor fromMap", (){

    expect(new Color.fromMap({"r": 1}).toString(), "rgba(1, 0, 0, 1.0)");
    expect(new Color.fromMap({"g": 2}).toString(), "rgba(0, 2, 0, 1.0)");
    expect(new Color.fromMap({"b": 3}).toString(), "rgba(0, 0, 3, 1.0)");
    expect(new Color.fromMap({"a": .4}).toString(), "rgba(0, 0, 0, 0.4)");

    expect(new Color.fromMap({"r": 1, "g": 2, "b": 3, "a": .4}).toString(), "rgba(1, 2, 3, 0.4)");

  });

  test("List convention", (){
    var def = Color.listConvention;

    Color.listConvention = [Color.ALPHA, Color.BLUE, Color.GREEN, Color.RED];
    expect(new Color.fromList([.1, 3, 2, 1]).toString(), "rgba(1, 2, 3, 0.1)");

    Color.listConvention = [Color.BLUE, Color.ALPHA];
    expect(new Color.fromList([3, .2]).toString(), "rgba(0, 0, 3, 0.2)");

    Color.listConvention = def;
  });

  test("Map convensions",  (){

    var def = Color.mapConventions;

    Color.mapConventions.clear();
    expect(() => new Color.fromMap({"R":1, "G": 2, "B": 3, "A": .1}), throwsA(isException));

    Color.mapConventions.add(["X", "Y", "Z", "T"]);
    Color.mapConventions.add(["A", "B", "C", "D"]);
    Color.mapConventions.add(["X", "Y", "Z", "T"]);
    Color.mapConventions.add(["R", "G", "B", "A"]);

    expect(new Color.fromMap({"X": 1, "Y": 2, "Z": 3, "T": .4}).toString(), "rgba(1, 2, 3, 0.4)");
    expect(new Color.fromMap({"A": 2, "B": 4, "C": 6, "D": .8}).toString(), "rgba(2, 4, 6, 0.8)");
    expect(new Color.fromMap({"X": 1, "Y": 2, "Z": 3, "T": .4}).toString(), "rgba(1, 2, 3, 0.4)");
    expect(new Color.fromMap({"R": 1, "G": 2, "B": 3, "A": .4}).toString(), "rgba(1, 2, 3, 0.4)");

    Color.mapConventions = def;

  });

  test("Output format", (){

    var def = Color.outputFormat;

    var red = Color.red();
    Color.outputFormat = Color.RGB;
    expect(red.toString(), "rgb(255, 0, 0)");
    expect([red.r, red.g, red.b, red.a], equals([255, 0, 0, 1.0]));

    var green = Color.green();
    Color.outputFormat = Color.RGBA;
    expect(green.toString(), "rgba(0, 255, 0, 1.0)");
    expect([green.r, green.g, green.b, green.a], equals([0, 255, 0, 1.0]));

    var blue = Color.blue();
    Color.outputFormat = Color.HEX;
    expect(blue.toString(), "#0000ff");
    expect([blue.r, blue.g, blue.b, blue.a], equals(["00", "00", "ff", 1.0]));

    Color.outputFormat = def;

  });

  test("Parse color", (){

    var rgb = "rgb(240, 240, 240)",
        rgba = "rgba(240, 240, 240, 1.0)",
        hex = "#f0f0f0";

    expect(Color.parse(rgb).toRGBString(), rgb);
    expect(Color.parse(rgb).toRGBAString(), rgba);
    expect(Color.parse(rgb).toHEXString(), hex);

    expect(Color.parse(rgba).toRGBString(), rgb);
    expect(Color.parse(rgba).toRGBAString(), rgba);
    expect(Color.parse(rgba).toHEXString(), hex);

    expect(Color.parse(hex).toRGBString(), rgb);
    expect(Color.parse(hex).toRGBAString(), rgba);
    expect(Color.parse(hex).toHEXString(), hex);

  });

  test("Clone method", (){
    expect(new Color(255, 255, 255, .5).clone().toString(), "rgba(255, 255, 255, 0.5)");
  });

  test("Default values", (){

    Color.DEF_RED = 50;
    Color.DEF_GREEN = 50;
    Color.DEF_BLUE = 50;
    Color.DEF_ALPHA = .5;

    expect(new Color().toString(), "rgba(50, 50, 50, 0.5)");
    expect(new Color(100).toString(), "rgba(100, 50, 50, 0.5)");
    expect(new Color(null, 100).toString(), "rgba(50, 100, 50, 0.5)");
    expect(new Color(null, null, 100).toString(), "rgba(50, 50, 100, 0.5)");
    expect(new Color(null, null, null, .6).toString(), "rgba(50, 50, 50, 0.6)");

    Color.DEF_RED = 0;
    Color.DEF_GREEN = 0;
    Color.DEF_BLUE = 0;
    Color.DEF_ALPHA = 1.0;

  });

  test("Arithmetics", (){

    expect(Color.red() + Color.green(), new Color(255, 255));
    expect(Color.red() - new Color(100), new Color(155));

  });

}
