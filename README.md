# fff

Dart package for convenient work with color.

## Usage

### A simple usage Color:

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
    
    
        
In addition and subtraction of colors, the left is the main color. That is, in the end will be the color of the same size as the left color. For color in rgb format value of alpha is 1.0
    
    print(new Color(100, 0, 0) + new Color(50, 0, 0)); // rgb(150, 0, 0)
    print(new Color(100, 0, 0) - new Color(50, 0, 0)); // rgb(50, 0, 0)

    print(new Color(100, 0, 0) + new Color(50, 0, 0, .1)); // rgb(150, 0, 0)
    print(new Color(100, 0, 0) - new Color(50, 0, 0, .1)); // rgb(50, 0, 0)
    
    print(new Color(100, 0, 0, .5) + new Color(50, 0, 0)); // rgba(150, 0, 0, 1.0)
    print(new Color(100, 0, 0, .5) - new Color(50, 0, 0)); // rgba(50, 0, 0, 0.0)
    
    print(new Color(100, 0, 0, .5) + new Color(50, 0, 0, .3)); // rgba(150, 0, 0, 0.8)
    print(new Color(100, 0, 0, .5) - new Color(50, 0, 0, .3)); // rgba(50, 0, 0, 0.2)

### Color presets

Presets library contains 275 constants of colors from [Material design](http://www.google.com/design/spec/style/color.html)

    import 'package:fff/presets.dart';
    
    main() {
        print(red + green); // rgb(255, 242, 134)
    }
    
### Parse color

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

### List convention

    import 'package:fff/parser.dart';

    main() {

        // wrong list of color components
        // but need rgb(10, 20, 30)
        var brg = [30, 10, 20];

        // change list convention
        listConvention = [Color.BLUE, Color.RED, Color.GREEN, Color.ALPHA];

        print(ColorParser(brg)); // rgb(10, 20, 30)

    }
    
### Map conventions

    import 'package:fff/parser.dart';

    main() {
    
        // by default set [rgba] and [xyza] conventions
        
        // add new          red   green  blue  alpha
        mapConventions.add(["A",  "B",   "C",  "D"]);
        
        print(ColorParser({"A": 10, "B": 20, "C": 30, "D": .9})); // rgba(10, 20, 30, 0.9)
        
        // Attention! Of all the conventions will be applied first best match.
        // Example:
        
        // remove all conventions
        mapConventions.clear();
        
        // add new
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

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
