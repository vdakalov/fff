// Copyright (c) 2015, Viktor Dakalov. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library fff.test.color;

import 'package:test/test.dart';
import 'package:fff/color.dart';

main() {
  test("Constructor without arguments", () {
    expect(new Color().toString(), "rgb(0, 0, 0)");
  });

  test("Constructor with arguments", () {
    expect(new Color(255).toString(), "rgb(255, 0, 0)");
    expect(new Color(0, 255).toString(), "rgb(0, 255, 0)");
    expect(new Color(0, 0, 255).toString(), "rgb(0, 0, 255)");
    expect(new Color(0, 0, 0, .3).toString(), "rgba(0, 0, 0, 0.3)");
    expect(new Color(1, 2, 3, 0.4).toString(), "rgba(1, 2, 3, 0.4)");
  });

  test("Output format", () {
    expect(new Color(255).toString(), "rgb(255, 0, 0)");
    expect(new Color(255).toRgbString(), "rgb(255, 0, 0)");

    expect(new Color(255, 0, 0, 1.0).toString(), "rgba(255, 0, 0, 1.0)");
    expect(new Color(255, 0, 0, 1.0).toRgbaString(), "rgba(255, 0, 0, 1.0)");

    expect(new Color(255, 0, 0).toHexString(), "ff0000");

    expect(new Color(255, 255, 255).toString('red: %r, green: %g, blue: %B'),
        'red: 255, green: 255, blue: 255');

    expect(
        new Color(255, 255, 255, .5)
            .toString('red: %r, green: %g, blue: %B, alpha: %A'),
        'red: 255, green: 255, blue: 255, alpha: 0.5');

    expect(new Color(255, 255, 255, .5).toHexString('#%R%g%b'), '#FFffff');

    // === toList ===

    // simple
    expect(new Color(0, 0, 0).toList(), equals([0, 0, 0]));
    expect(new Color(255, 255, 255).toList(), equals([255, 255, 255]));
    expect(new Color(0, 0, 0, 0.0).toList(), equals([0, 0, 0, 0.0]));
    expect(
        new Color(255, 255, 255, 1.0).toList(), equals([255, 255, 255, 1.0]));

    // as double
    expect(new Color(10, 20, 30).toList(asDouble: true),
        equals([10.0, 20.0, 30.0]));
    expect(new Color(10, 20, 30, 0.4).toList(asDouble: true),
        equals([10.0, 20.0, 30.0, 0.4]));

    // template
    expect(
        new Color(10, 20, 30, 0.4).toList(template: [
          "A",
          Component.RED,
          "B",
          Component.GREEN,
          "C",
          Component.BLUE,
          "D",
          Component.ALPHA
        ]),
        equals(["A", 10.0, "B", 20.0, "C", 30.0, "D", 0.4]));

    expect(new Color(10, 20, 30).toList(template: ["A", "B", "C"]),
        equals(["A", "B", "C"]));

    expect(
        new Color(10, 20, 30).toList(
            template: [Component.ALPHA, Component.ALPHA, Component.ALPHA]),
        equals([1.0, 1.0, 1.0]));

    expect(
        new Color(10, 20, 30)
            .toList(template: [Component.BLUE, Component.BLUE, Component.BLUE]),
        equals([30, 30, 30]));

    // range
    expect(
        new Color(50, 255, 100, 0.4)
            .toList(asDouble: false, range: 1, template: [
          Component.RED,
          Component.GREEN,
          Component.BLUE,
          Component.ALPHA,
          "A",
          Component.RED,
          "B",
          Component.GREEN,
          "C",
          Component.BLUE,
          "D",
          Component.ALPHA
        ]),
        equals([
          0.19607843137254902,
          1.0,
          0.39215686274509803,
          0.4,
          "A",
          0.19607843137254902,
          "B",
          1.0,
          "C",
          0.39215686274509803,
          "D",
          0.4
        ]));

    expect(new Color(10, 20, 30).toList(rows: 3),
        equals([10, 20, 30, 10, 20, 30, 10, 20, 30]));

    // === toMap ===

    expect(new Color(10, 20, 30).toMap(),
        equals({"red": 10, "green": 20, "blue": 30}));
    expect(new Color(10, 20, 30, 0.0).toMap(),
        equals({"red": 10, "green": 20, "blue": 30, "alpha": 0.0}));

    // as double
    expect(new Color(10, 20, 30).toMap(asDouble: true),
        equals({"red": 10.0, "green": 20.0, "blue": 30.0}));
    expect(new Color(10, 20, 30, 0.6).toMap(asDouble: true),
        equals({"red": 10.0, "green": 20.0, "blue": 30.0, "alpha": 0.6}));

    // template
    expect(
        new Color(10, 20, 30).toMap(template: {
          "a": Component.RED,
          "b": Component.GREEN,
          "c": Component.BLUE
        }),
        equals({"a": 10, "b": 20, "c": 30}));
    expect(new Color(10, 20, 30).toMap(template: {}), equals({}));
    expect(
        new Color(10, 20, 30).toMap(template: {
          "a": Component.RED,
          "A": Component.RED,
          "b": Component.GREEN,
          "B": Component.GREEN,
          "c": Component.BLUE,
          "C": Component.BLUE,
          "D": Component.ALPHA
        }),
        equals(
            {"a": 10, "A": 10, "b": 20, "B": 20, "c": 30, "C": 30, "D": 1.0}));

    // range
    expect(
        new Color(50, 255, 100, 0.4).toMap(template: {
          "a": Component.RED,
          "b": Component.GREEN,
          "c": Component.BLUE
        }, range: 1),
        equals({"a": 0.19607843137254902, "b": 1.0, "c": 0.39215686274509803}));
  });

  test("Arithmetics", () {
    expect(new Color(255) + new Color(0, 255), new Color(255, 255));
    expect(new Color(255) - new Color(100), new Color(155, 0, 0));
  });
}
