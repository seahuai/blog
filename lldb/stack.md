### stack
`x64`和`ARM`的结构中，栈从高地址如`0xFFFFFFFF`向低地址`0x00000000`递减，每个栈的高地址的值由操作系统的内核来分配给各个进程。

```
stack:
 --------   <- HIGH ADDRESS
| frame1 | 
 --------
| frame2 |
 --------
| frame3 |
 --------
|        |
|  ...   | 
|        |
 --------  <- LOW ADDRESS
```

#### RSP & RBP
* `RSP`(stack pointer regsiter)
* `RSP`的值为栈的首部的地址

```
stack:
 --------          
| frame1 | 
 --------
| frame2 |         
 --------  <- RSP
| frame3 |
 --------

```
该进程有新的方法被调用，入栈，`RSP`的值递减：

```
 --------   
| frame1 | 
 --------
| frame2 |         
 --------  
| frame3 |
 --------  <- RSP
| frame4 |
 --------
```

* `RBP`(base pointer register)
* 程序利用局部变量或者是函数的某些参数值与`RBP`的偏移值来对它们来进行访问。
* 栈一开始`RBP`与`RSP`的值是一致的。
* 调用函数时候将`RBP`的值入栈，建立新的frame，并将`RSP`的值赋给`RBP`。
* 函数调用结束后将之前放入栈中的`RBP`值取出，恢复`RBP`的值。
* debugger就是通过对`RBP`与`RSP`值的改变来做到正确的访问正确的局部变量。

#### 与栈有关的操作
* `push 0x01`

```
伪代码如下：
RSP = RSP - 0x8 (地址向下生长）
*RSP = 0x01 (将值赋给RSP所指向的地址)
```

* `pop rdx`

```
伪代码
RDX = *RSP
RSP = RSP + 0x8
```

* `call`
* 当前被调用的函数结束后下一句指令的地址放入栈中

```
例如执行 call 0x01
0x01: call 0x0f
0x02： mov edx, eax
```
此时`RIP`的值为`0x02`，并且入栈，接着`RIP`的值变为`0x0f`(即要执行的函数所在的地址）

* `ret`
* 和`call`指令的操作相反
* 将栈顶的值（即`call`指令时入栈的`RIP`的值）出栈，并赋给`RIP`