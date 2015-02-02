// Copyright (c) 2015, Viktor Dakalov. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library fff.test.color;

import 'package:unittest/unittest.dart';
import 'package:fff/color.dart';

main() {

  test("Constructor without arguments",(){
    expect(new Color().toString(), "rgb(0, 0, 0)");
  });

  test("Constructor with arguments", (){
    expect(new Color(255).toString(), "rgb(255, 0, 0)");
    expect(new Color(0, 255).toString(), "rgb(0, 255, 0)");
    expect(new Color(0, 0, 255).toString(), "rgb(0, 0, 255)");
    expect(new Color(0, 0, 0, .3).toString(), "rgba(0, 0, 0, 0.3)");
    expect(new Color(1, 2, 3, 0.4).toString(), "rgba(1, 2, 3, 0.4)");
  });

  test("Output format", (){

    expect(new Color(255).toString(), "rgb(255, 0, 0)");
    expect(new Color(255).toRgbString(), "rgb(255, 0, 0)");

    expect(new Color(255, 0, 0, 1.0).toString(), "rgba(255, 0, 0, 1.0)");
    expect(new Color(255, 0, 0, 1.0).toRgbaString(), "rgba(255, 0, 0, 1.0)");

    expect(new Color(255, 0, 0).toHexString(), "ff0000");

  });

  test("Arithmetics", (){

    expect(new Color(255) + new Color(0, 255), new Color(255, 255));
    expect(new Color(255) - new Color(100), new Color(155, 0, 0));

  });

}
