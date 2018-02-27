### lldb command

### breakpoint
* 在指定的代码文件`ViewController.swift`中的所有包含有`if let`的代码处添加断点:
`breakpoint set -p "if let" -f ViewController.swift -f`

* 轻松查看所有断点,使用`-b`参数，`brief flag`:
`breakpoint list 1 -b` 



#### image

* 用于精确的搜索方法或者是标志在framework中的位置
`image lookup -n "-[UIViewController viewDidLoad]"`

* 正则搜索 
 `image lookup App.ClassName.property.setter`
 
* `rlook test` 等价于 `image lookup -rn abc`

	
#### expression
* 使用`po`打印对象输出的是它`debugDescripation`的内容
* `po`所在的语言环境是取决于当前所在的上下文
	* `expression -l objc -O -- test`
	* `expression -l swift -O -- test`
* 在`lldb`中创建属性，使用`$`：

```1
(lldb) po id $test = [NSObject new];
(lldb) po $test
<NSObject: 0x60000001d190>
```

#### command regex
格式：`command regex -- test s/<regex>/<subst>/`
例子：

```2
(lldb) command regex -- tv 's/(.+)/expression -l objc -O -- @import QuartzCore; [%1 setHidden:!(BOOL)[%1 isHidden]]; (void)[CATransaction flush];/”

“Advanced Apple Debugging”
```

