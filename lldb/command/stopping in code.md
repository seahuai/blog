#### imge command

1. `image lookup` dumps all the implementation address(the offset address of where this method is located within the framework's binary) 
2. 1. `-n` , to exact matches the functions or symbols: `image lookup -n "-[UIViewController viewDidLoad]"`
   2. `-rn`, case-sensitive regex search,:`image lookup -rn test`

3. Swift method name
   1. ModuleName.ClassName.PropertyName.(getter|setter)
   2. ModuleName.ClassName.FunctionName
   3. user `image lookup -rn` to find dump swift method
4. Objective-c categories method name
   1. (-|+)[ClassName(categoryName) method]

#### Breakpoint

1. simple way: `b`
2. regex breakpoints `breakpoint set -r`, or `rbreak` or `rb`
3. use `-f` option to limit the scope of breakpoint
4. use `-s` option to limit the scope of library
5. user `-o 1` option to set a "one-shot" breakpoint
6. use `-L` option to filter source language
7. use `-A` option to set the scope to all source file
8. user `-p` option take a regex, example: create a breakpoint on every source code location than contains *if let*: `breakpoint set -A -p "if let"`
9. ...
10. `breakpoint write -f ../../filename.json/` to record breakpoint session