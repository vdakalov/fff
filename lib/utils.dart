// Copyright (c) 2015, Viktor Dakalov. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library utils;

/// Return fewer
min(num a, num b) => a <= b ? a : b;

/// Return greater number
max(num a, num b) => a >= b ? a : b;

/// Correct hex component for input (f -> ff)
String hexin(String comp) => comp.length == 1 ? comp + comp : comp;

/// Correct hex component for output
String hexout(String comp) => comp.length == 1 ? "0$comp" : comp;

/// Convert dec component to hex
String tohex(num comp) => hexout(comp.toInt().toRadixString(16));

/// Convert hex component to dec
int fromhex(String comp) => int.parse(hexin(comp), radix: 16);
