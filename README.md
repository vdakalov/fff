# fff

Dart package for convenient work with color. It will allow you to convert
colors between rgb, rgba and hex formats. Also it can parse color from
strings specified formats and from list of color components or map.

## Usage

### A simple usage Color:

```dart
import 'package:fff/color.dart';

main() {

    // create black color in rgb format
    const black = const Color();

    // or
    const black = const Color(0, 0, 0);

    // output it
    print(black); // rgb(0, 0, 0)
    print(black.toHexString()); // 000000
    print(black.toRgbString()); // rgb(0, 0, 0)
    print(black.toRgbaString()); // rgba(0, 0, 0, 1.0)

    // create red color in rgba format
    const red = const Color(255, 0, 0, 1.0);
}
```

Output color components as List object

```dart
import 'package:fff/color.dart';

main() {

    // create red color
    var red = const Color(255);

    // output simple list
    print(red.toList()); // [255, 0, 0]

    // output by template
    print(
      red.toList(template: [
        Component.ALPHA,
        Component.BLUE,
        Component.GREEN,
        Component.RED
      ])
    );
    // [1.0, 0, 0, 255]

    // value of the alpha channel always output as double and range is
    // set from 0 to 1 rgb components are always output as int. But
    // this can be changed by setting the parameter to true asDouble
    print(red.toList(asDouble: true)); // [255.0, 0.0, 0.0]

    // change of range of color components
    print(red.toList(range: 1)); // [1, 0, 0]

    // You can specify the number of times the output. For example it
    // may be useful to specify the color of each vertex polygon model
    print(red.toList(rows: 2, range: 1));
    // [1.0, 0.0, 0.0, 1.0, 0.0, 0.0]
}
```

Output color components as Map object

```dart
import 'package:fff/color.dart';

main() {

    var temp = {
      "A": Component.RED,
      "B": Component.GREEN,
      "C": Component.BLUE
    };

    // are all exactly the same as in the first case, with the only
    // exception that here there is no parameter rows and default
    // template {"red": RED, "green": GREEN, "blue": BLUE, "alpha":
    // ALPHA}
    print( Color(255, 100, 50).toMap(template: temp, range: 1));
    // {A: 1.0, B: 0.39215686274509803, C: 0.19607843137254902}

}
```

In addition and subtraction of colors, the left is the main color. That is, in the end will be the color of the same size as the left color. For color in rgb format value of alpha is 1.0
 
 ```dart
print( Color(100, 0, 0) +  Color(50, 0, 0)); // rgb(150, 0, 0)
print( Color(100, 0, 0) -  Color(50, 0, 0)); // rgb(50, 0, 0)

print( Color(100, 0, 0) +  Color(50, 0, 0, .1)); // rgb(150, 0, 0)
print( Color(100, 0, 0) -  Color(50, 0, 0, .1)); // rgb(50, 0, 0)

print( Color(100, 0, 0, .5) +  Color(50, 0, 0)); // rgba(150, 0, 0, 1.0)
print( Color(100, 0, 0, .5) -  Color(50, 0, 0)); // rgba(50, 0, 0, 0.0)

print( Color(100, 0, 0, .5) +  Color(50, 0, 0, .3)); // rgba(150, 0, 0, 0.8)
print( Color(100, 0, 0, .5) -  Color(50, 0, 0, .3)); // rgba(50, 0, 0, 0.2)
```

### Color presets

Presets library contains 275 constants of colors from [Material design](http://www.google.com/design/spec/style/color.html)

```dart
import 'package:fff/presets.dart';

main() {
    print(red + green); // rgb(255, 242, 134)
}
```

### Parse color

```dart
import 'package:fff/parser.dart';

main() {

    print(ColorParser("#FFF")); // rgb(255, 255, 255)
    print(ColorParser("#000000")); // rgb(0, 0, 0)
    print(ColorParser("#AAA") is Color); // true

    print(ColorParser("rgb(255, 255, 255)")); // rgb(255, 255, 255)
    print(ColorParser("rgba(255, 255, 255, 1.0)")); // rgba(255, 255, 255, 1.0)

    print(ColorParser([10, 20, 30])); // rgb(10, 20, 30)
    print(ColorParser([10, 20, 30, .4])); // rgba(10, 20, 30, 0.4)

    print(ColorParser({"r": 10, "g": 20, "b": 30, "a": .4})); // rgba(10, 20, 30, 0.4)
    print(ColorParser({"x": 10, "y": 20, "z": 30, "a": .4})); // rgba(10, 20, 30, 0.4)

}
```

### List convention

```dart
import 'package:fff/parser.dart';

main() {

    // wrong list of color components
    // but need rgb(10, 20, 30)
    var brg = [30, 10, 20];

    // change list convention
    listConvention = [
      Component.BLUE,
      Component.RED,
      Component.GREEN,
      Component.ALPHA
    ];

    print(ColorParser(brg)); // rgb(10, 20, 30)

}
```

### Map conventions

```dart
import 'package:fff/parser.dart';

main() {

    // by default set [rgba] and [xyza] conventions

    // add           red   green  blue  alpha
    mapConventions.add(["A",  "B",   "C",  "D"]);

    print(ColorParser({"A": 10, "B": 20, "C": 30, "D": .9})); // rgba(10, 20, 30, 0.9)

    // Attention! Of all the conventions will be applied first best match.
    // Example:

    // remove all conventions
    mapConventions.clear();

    // add
    mapConventions.add(["a", "b", "c", "A"]);
    mapConventions.add(["x", "y", "z", "A"]);
    mapConventions.add(["1", "2", "3", "A"]);

    // Notice: Need specify all four components (rgba).
    // Convention with the number of components other than the four will be ignored.

    // apply first convention (match "a", "b" and "c")
    print(ColorParser({"a": 10, "b": 20, "c": 30})); // rgb(10, 20, 30)

    // apply second convention (match "x", "y" and "z")
    print(ColorParser({"x": 10, "y": 20, "z": 30})); // rgb(10, 20, 30)

    // apply first convention (math "a" and "b")
    // "c" component is not found
    print(ColorParser({"a": 10, "b": 20, "z": 30})); // rgb(10, 20, 0)

    // apply second convention (math "y" and "z")
    // "x" component is not found
    print(ColorParser({"a": 10, "y": 20, "z": 30})); // rgb(0, 20, 30)

    print(ColorParser({"1": 10, "x": 20, "a": 30})); // rgb(30, 0, 0)

    // if the number of matches in several conventions is identical, then will be applied first

}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/vdakalov/fff/issues
