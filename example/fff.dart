// Copyright (c) 2015, Viktor Dakalov. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library fff.example;

import 'package:fff/fff.dart';

main() {

  output("red full", RGBA, new Color(255, 0, 0, 1.0));
  output("red min", RGBA, new Color(255));

  output("green full", RGBA, new Color(0, 255, 0, 1.0));
  output("green min", RGBA, new Color(null, 255));

}

int i = 1;
output(String color, String mode, Color obj) {
  print("${i++}. $color: $mode[$obj]");
}