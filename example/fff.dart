// Copyright (c) 2015, Viktor Dakalov. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library fff.example;

import 'package:fff/fff.dart' hide color;

main() {

  var input = "fcabce";

  var color = new Color.fromHex(input);
  print("hex => rgb: $color");

  var rgb = Color.parse(color.toRGBString());
  print("parse rgb: $rgb");

  print("rgb => hex: ${rgb.toHEXString()}");

  print(rgb.toHEXString() == "#$input");

}
