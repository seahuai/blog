### register
`X86_64`架构主要用于`macOs`系统，`ARM64	`则用于移动平台`iOS`上。
`x64`有`RAX` `RBX` `RCX` `RDX` `RDI` `RSI` `RSP` `RBP` 和 `R18` 到 `R15`，一共16个寄存器，当在`x64`架构下运行代码并调用函数的话寄存器将会被用于存放函数的参数值。

* `Objective-C`的方法被调用的时候，会调用`objc_msgSend`方法
* 该方法接收调用对象和方法名为`objc_msgSend`方法第一个和第二个参数
* `objc_msgSend(receiver, selector, arg1, arg2, ...)`
* `objc_msgSend(RDI, RSI, RDX, RCX, R8, R9, ...)`
* 方法的参数如果大于6个，则多余的参数放入栈中而不是直接存放在寄存器中
* `register read`可以查看当前的寄存器的情况
* 一旦方法执行后，寄存器的值很可能会被其它的方法所修改，所以看到的值不一定是我们所期望的结果。
* 方法有返回值的话，返回值的结果将会存放在`RAX`寄存器中。

在`lldb`可以直接使用寄存器里面的值，如`po $rdi`

#### Objecive-C和swift方法调用的异同
1. 在`Objecive-C`中，`RDI`, `RSI`, `RDX`分别代表方法调用的对象和方法名（Selector）和第一个参数。
2. 在`swift`的中，`RDI`为函数的第一个参数，`RSI`是第二个。
3. 方法若有返回值都存放在RAX中
