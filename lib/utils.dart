// Copyright (c) 2015, Viktor Dakalov. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library utils;

/// Return fewer
min(num a, num b) => a <= b ? a : b;

/// Return greater number
max(num a, num b) => a >= b ? a : b;

/// Correct hex component for input (f -> ff)
hexin(String comp) => comp.length == 1 ? comp + comp : comp;

/// Correct hex component for output
hexout(String comp) => comp.length == 1 ? "0$comp" : comp;

/// dec to hex
tohex(num comp) => hexout(comp.toInt().toRadixString(16));

/// hex to dec
fromhex(String comp) => int.parse(hexin(comp), radix: 16);