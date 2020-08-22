#### Ptrace

> 系统调用

通过系统手册命令`man ptrace`，ptrace函数声明为：

```c++
int  ptrace(int _request, pid_t _pid, caddr_t _addr, int _data);
```

类型 `PT_DENY_ATTACH` 能够阻止进程被其它进程trace，但可以通过lldb跳过其调用ptrace函数的地方，来解除该限制。

1. 通过 lldb -w 的参数等待程序运行
2. 设置断点 rb ptrace -s libsystem_kernel.dylib
3. 断点触发后直接返回 thread return 0
4. 跳过ptrace函数的运行

