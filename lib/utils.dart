library utils;

min(num a, num b) => a <= b ? a : b;
max(num a, num b) => a >= b ? a : b;
hexin(String comp) => comp.length == 1 ? comp + comp : comp;
hexout(String comp) => comp.length == 1 ? "0$comp" : comp;
tohex(num comp) => hexout(comp.toInt().toRadixString(16));
fromhex(String comp) => int.parse(hexin(comp), radix: 16);
fromnum(String num) => num.contains(".") ? double.parse(num.trim()) : int.parse(num.trim());
