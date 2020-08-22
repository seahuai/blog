#### Dynamic Framework

> a dynamic framework is a bundle of code loaded into an executable at runtime. ex, UIKit and Foundation.

Advantage: 

1. using dynamic frameworks, the kernel can map the dynamic framework to multiple processes that depend on the framework. 
2.  The most obvious advantage was that developers could share frameworks across different iOS extensions, such as the Today Extension and Action Extensions.

##### dyld

> dynamic loader

dyld用于加载动态库，当必备的（required）动态库加载失败，系统会杀掉该进程。而可选的（optional）的动态库则加载失败则不会影响程序运行。



##### otool

* otool -L /path，打印出所有加载的libraries
* otool -l /parh，打印出所有加载命令
  *  LC_LOAD_WEAK_DYLIB, which represents an optional framework, while the LC_LOAD_DYLIB load command indicates a required framework.

##### process load

* 将动态库加载到当前的线程中
* dyld 在加载的时候会自己寻找当前动态库的完整路径
  * 使用 process load MessageUI.framework/MessageUI

TODO: 

add lldbinit command