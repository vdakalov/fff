// Copyright (c) 2015, Viktor Dakalov. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library fff.example;

import 'package:fff/fff.dart';

main() {

  Color.mapConventions.clear();
  Color.mapConventions.add(["a", "b", "c"]);
  Color.mapConventions.add(["x", "y", "z"]);

  print(new Color.fromMap({"a": 10, "b": 20, "c": 30}));
  print(new Color.fromMap({"x": 10, "y": 20, "z": 30}));
  print(new Color.fromMap({"a": 10, "b": 20, "z": 30}));

  // black
  print("BLACK COLORS");
  print(new Color());
  print(Color.black());
  print(Color.parse("#000000"));
  print(Color.parse("rgb(0, 0, 0)"));
  print(Color.parse("rgba(0, 0, 0, 1)"));

  // red
  print("RED COLORS");
  print(new Color(255));
  print(Color.red());
  print(Color.parse("#F00"));
  print(Color.parse("rgb(255, 0, 0)"));
  print(Color.parse("rgba(255, 0, 0, 1)"));

  // green
  print("GREEN COLORS");
  print(new Color(null, 255));
  print(Color.green());
  print(Color.parse("#0F0"));
  print(Color.parse("rgb(0, 255, 0)"));
  print(Color.parse("rgba(0, 255, 0, 1)"));

  // blue
  print("BLUE COLORS");
  print(new Color(null, null, 255));
  print(Color.blue());
  print(Color.parse("#00F"));
  print(Color.parse("rgb(0, 0, 255)"));
  print(Color.parse("rgba(0, 0, 255, 1)"));

  print("COMPARISON");
  print(new Color() == Color.black());
  print(Color.parse("rgb(0,0,0)") == Color.parse("#000000"));

  print("ADD");
  print(Color.parse("#F00") + Color.parse("#0F0"));

}