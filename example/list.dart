// Copyright (c) 2015, Viktor Dakalov. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library fff.example.list;
import 'package:fff/fff.dart';

main() {

  var brg = [3, 1, 2, .4];

  print(new Color.fromList(brg));

  // change list convention
  Color.listConvention = [Color.BLUE, Color.RED, Color.GREEN, Color.ALPHA];

  print(new Color.fromList(brg));

}