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
* 处理触摸事件的方法

```touch method
func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)

func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)

func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)

func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
```
* [UITouch](https://developer.apple.com/documentation/uikit/uitouch)有一个触摸的所有信息，触摸的视图、点击的次数等
* 一个事件的传递是从父控件到子控件的（`从上到下`），而一个事件的响应这事从子控件到父控件向上传递的（`从下到上`）
