# fff

Dart package for convenient work with color.

## Usage

A simple usage example:

    // without arguments
    print(new Color()); // rgba(0, 0, 0, 1.0)
    
    // red
    print(new Color(255)); // rgba(255, 0, 0, 1.0)
    
    // yellow
    print(new Color(255, 255)); // rgba(255, 255, 0, 1.0)
    
    // all arguments
    print(new Color(10, 20, 30, .5)); // rgba(10, 20, 30, 0.5)
    
    // color presets (exist: red, green, blue, gray, black and white)
    print(Color.red()); // rgba(255, 0, 0, 1.0)
    
    print(Color.red().r); // 255
    print(Color.red().a); // 1.0
    
    // int 0-255 and can not be in a hex format
    Color.red().r = 100;
    
    // int or double 0-1
    Color.red().a = .4;
    
    // only in rgba format
    print(Color.red().components); // [255, 0, 0, 1.0]
    
Parse color

    // from rgb
    print(Color.parse("rgb(100, 100, 100)")); // rgba(100, 100, 100, 1.0)
    
    // from rgba
    print(Color.parse("rgb(50, 50, 50, .4)")); // rgba(50, 50, 50, 0.4)
    
    // from hex
    print(Color.parse("#f00")); // rgba(255, 0, 0, 1.0)

Arithmetics

    print(Color.red() + Color.green()); // rgba(255, 255, 0, 1.0)
    print(Color.red() - new Color(100)); // rgba(100, 0, 0, 1.0)
    print(Color.black() == new Color()); // true

Create Color object from List

    print(new Color.fromList([10, 20, 30])); // rgba(10, 20, 30, 1.0)
    
Create Color object from Map

    print(new Color.fromMap({"r": 10, "g": 20, "b": 30, "a": .2})); // rgba(10, 20, 30, 0.2)
    print(new Color.fromMap({"x": 10, "y": 20, "z": 30, "a": .2})); // rgba(10, 20, 30, 0.2)

Output format

    // exist RGB, RGBA and HEX (by default RGBA)
    Color.outputFormat = Color.HEX;
    
    print(new Color()); // 000000
    print(Color.white()); // ffffff
    print(Color.red().r); // ff
    
    Color.outputFormat = Color.RGB;
    
    print(Color.blue()); // rgb(0, 0, 255)
    print(Color.blue().b); // 255

List convetion

    // wrong list of color components
    // but need rgb(10, 20, 30)
    var brg = [30, 10, 20];
    
    // change list convention
    Color.listConvention = [Color.BLUE, Color.RED, Color.GREEN, Color.ALPHA];
    
    // 
    print(new Color.fromList(brg)); // rgba(10, 20, 30)

Map conventions

    // by default set [rgba] and [xyza] conventions
    
    // add new                 red  green  blue  alpha
    Color.mapConventions.add(["A",  "B",   "C",  "D"]);
    
    print(new Color.fromMap({"A": 10, "B": 20, "C": 30, "D": .9})); // rgba(10, 20, 30, 0.9)
    
    // Attention! Of all the conventions will be applied first best match
    // example:
    
    // remove all conventions
    Color.mapConventions.clear();
    
    // add new
    Color.mapConventions.add(["a", "b", "c"]);
    Color.mapConventions.add(["x", "y", "z"]);
    
    // apply first convention (match "a", "b" and "c")
    print(new Color.fromMap({"a": 10, "b": 20, "c": 30})); // rgba(10, 20, 30, 1.0)
    
    // apply second convention (match "x", "y" and "z")
    print(new Color.fromMap({"x": 10, "y": 20, "z": 30})); // rgba(10, 20, 30, 1.0)
    
    // apply first convention (math "a" and "b")
    // "c" component is not found
    print(new Color.fromMap({"a": 10, "b": 20, "z": 30})); // rgba(10, 20, 0, 1.0)

    // apply second convention (math "y" and "z")
    // "x" component is not found
    print(new Color.fromMap({"a": 10, "y": 20, "z": 30})); // rgba(0, 20, 30, 1.0)
    
    // if the number of matches in several conventions is identical, then will be applied first
    

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
