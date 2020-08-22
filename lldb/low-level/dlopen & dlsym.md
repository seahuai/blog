

#### dlopen and dlsym

* 链接绑定符号等过程
  * https://time.geekbang.org/column/article/86840
  * 每个函数、全局变量和类都是通过符号的形式定义和使用的，当把目标文件链接成一个 Mach-O 文件时，链接器在目标文件和动态库之间对符号做解析处理。
* 程序链接过程中：
  * dlopen 打开动态库后返回的是引用的指针。
  * dlsym 的作用就是通过 dlopen 返回的动态库指针和函数符号，得到函数的地址然后使用。
* dlopen

  * extern void * dlopen(const char * \__path, int __mode);
  * 输入需要加载的动态库地址和mode
  * 返回一个句柄
* dlsym
  * extern void * dlsym(void * \__handle, const char * __symbol);
  * 输入dlopen返回的句柄和函数的符号
  * 返回函数的地址

#### Hooking C Function

#### Hooking Swift Function

#### Injection III

https://time.geekbang.org/column/article/87188



