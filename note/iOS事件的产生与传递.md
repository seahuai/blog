## iOS事件的产生与传递
> 这里只讨论触摸事件

### 事件的产生

1. 点击产生一个事件，该事件会被添加到UIApplication中的队列中，使用队列来处理能做到先产生的队列先处理。
2. 事件最先被发给应用程序的主窗口，之后事件被分发下去给可以处理触摸事件的控件(UIResponder)，并找到最合适的控件来处理触摸事件。
3. 找到最合适的视图控件后，就会调用对应的UIResponder中的方法。

### 事件的传递
* 触摸事件从父控件传递到子控件
* 若父控件无法响应触摸事件，则它的子控件也不能响应
* 如：`isHidden = true`, `alpha < 0.01`, `isUserInteractionEnabled = false`

### 如何找到处理事件最合适的控件
1. 首先判断主窗口`keyWindow`能否接受触摸事件
2. 判断触摸点是否在控件内
3. 从视图的层级`从外向里`遍历每一个视图控件，对每一个子控件，重复前三步
4. 若没有符合条件的子控件，则自己处理

### 如何寻找最合适的View的方法
* `func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView?`
* 寻找并返回处理该事件最合适的视图
* 返回`nil`则说明没有找到最合适的子控件，则父控件为最合适的视图

## UIResponder
* 继承自UIResponder的对象才可以响应事件
* 处理触摸事件的方法

```touch method
func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)

func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)

func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)

func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
```
* [UITouch](https://developer.apple.com/documentation/uikit/uitouch)有一个触摸的所有信息，触摸的视图、点击的次数等
* 一个事件的传递是从父控件到子控件的（`从上到下`），而一个事件的响应这事从子控件到父控件向上传递的（`从下到上`）

### 总结
> 一个事件的处理有事件的传递与事件的响应两个过程。

1. 首先，事件发生后，事件会从父控件传递给子控件，也就是寻找最合适的View
2. 接下来是事件的响应，找到最合适的View之后，首先看能否处理这个时间，若不能处理则交给上级视图`superView`，若上级视图也无法处理则继续向上传递，一直传递到`viewController`，若·`viewController`的根视图也无法处理则继续向上传递，如果控制器有父控制器则传递给父控制器，否则交给`window`，若`window`也无法处理则交给`application`，最后`application`也无法处理则丢弃
	* `view -> superView -> viewController ->superViewController -> window -> application`

3. 在事件的响应中，若某个空间实现了`UIResponder`的相关方法，则该事件由该控件来接受


