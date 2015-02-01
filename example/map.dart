// Copyright (c) 2015, Viktor Dakalov. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library fff.example.map;
import 'package:fff/fff.dart';

main() {

  // source color data
  var abc = {"B": 11, "A": 12, "C": 13, "Z": .14},
      xyz = {"x": 21, "y": 22, "z": 23, "a": .24},
      rgb = {"r": 31, "g": 32, "b": 33, "a": .34};

  // add new convention
  // existing default [r, g, b, a] and [x, y, z, a]
  Color.mapConventions.add(["B", "A", "C", "Z"]);

  print(new Color.fromMap(abc));
  print(new Color.fromMap(xyz));
  print(new Color.fromMap(rgb));

}