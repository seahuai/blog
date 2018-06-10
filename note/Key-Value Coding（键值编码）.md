### 键值编码
> Key-Value Coding键值编码，也就是常说的`KVC`

`KVC`提供了另外一种间接访问对象中属性的机制，作为直接访问属性和`getter``setter`方法的一种补充。
`KVC`这种机制是由`NSKeyValueCoding`协议来保证的，只要遵循该协议，就能采用一种非直接的方式访问对象中的各种属性。`NSObject`遵循了该协议，所以只要继承自`NSObject`的子类都实现了`KVC`这种机制。

```objc

// BankAccount.h
@interface BankAccount : NSObject
@property (nonatomic, strong) NSNumber *balance;
@property (nonatomic, strong) Person *owner;
@end

// Person.h
@interface Person : NSObject
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* address;
@property (nonatomic, copy) NSArray<NSString*>* friendNames;
@end

```
按照典型的做法，可以直接访问对象暴露的属性，或者是调用属性通过自动合成生成的方法，来操作对象的属性值。

```objc
[myAccount setBalance:@100];
 myAccount.balance = @100;
```
或者是通过`KVC`提供的方法

```objc
[myAccount setValue:@100 forKey:@"balance"];
NSNumber *balance = [myAccount valueForKey:@"balance"]; // 100
NSString *ownerName = [myAccount valueForKeyPath:@"owner.name"];
```

#### KVC中获取属性值的方法
* `valueForKey:` 通过一个字符串`key`来获得对象中的与`key`相对应的属性值。
* `valueForKeyPath:` `keyPath`键路径也是一个字符串，但可以通过字符串中的点表达式获取对象中属性的更多属性。
* `dictionaryWithValuesForKeys:` 传入一个`keys`的数组，将会返回一个用`keys`数组中的值作为键属性值作为值的字典。因为集合对象`NSDictionary`不能包含`nil`，该方法会自动将`dictionary`中为`nil`的值转换为`NSNull`对象。

如果对象中没有`key`对应的属性值，则会调用`valueForUndefinedKey:`，该方法`NSObject`提供了默认的实现，会抛出异常导致应用崩溃，子类可以重新该方法。

#### KVC设置属性值的方法
* `setValue:forKey:` 赋值给`key`所对应的属性值。
* `setValue:forKeyPath:`  赋值给`keyPath`键路径所对应的属性值。
* `setValuesForKeysWithDictionary:` 字典中的值赋值给所对应的字典中的键的属性值。

如果对象中没有`key`对应的属性值，则会调用`setValue:forUndefinedKey: `，该方法`NSObject`提供了默认的实现，会抛出异常导致应用崩溃，子类可以重新该方法。

对一个非对象的属性赋`nil`值会调用`setNilValueForKey:`，`NSObject`的默认实现也是抛出一个异常。

#### 访问对象中的集合属性
访问一个对象中的不可变集合属性`NSArray``NSDictionary``NSSet`，可以使用`valueForKey:`，如果要对对象中集合属性做修改，删除、添加等操作的话得结合`setValue:forKey:`来实现

```objc
NSArray *names = [person valueForKey:@"friendNames"];
NSMutableArray *mutableNames = [names mutableCopy];
[mutableNames addObject:@"Curry"];
[person setValue:mutableNames forKey:@"friendNames"];
```

`KVC`提供了几个方法，。

* `mutableArrayValueForKey:` 和 `mutableArrayValueForKeyPath:`
* `mutableSetValueForKey:` 和 `mutableSetValueForKeyPath:`
* `mutableOrderedSetValueForKey:` 和 `mutableOrderedSetValueForKeyPath:`


```objc
NSMutableArray *mutableNames = [person mutableArrayValueForKey:@"friendNames"];
[mutableNames addObject:@"Curry"];
```

使用这些方法将会简单许多。

针对集合的一些操作，可以在键路径中加入集合操作符来对集合中的值做计算。
可以阅读[文档](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueCoding/CollectionOperators.html#//apple_ref/doc/uid/20002176-BAJEAIEE)。

#### KVC寻找属性值的顺序

调用`valueForKey:`时，我们将一个字符串`<key>`作为输入，然后得到对应的输出。

1. 首先，搜索对象中的所有实例方法，按顺序搜索形如`get<Key>`, `<key>`, `is<Key>`, `_<key>`的方法，通过这个方法获得对应的值之后，跳转到5。
2. 寻找对象中符合`countOf<Key>`， `objectIn<Key>AtIndex:` 和 `<key>sAtIndexes:` 格式的方法，只要调用者满足第一个方法和后两个方法的其中之一，将会创建一个集合对象`NSKeyValueArray`，该集合对象可以通过组合上述方法来响应任何`NSArray`的方法，并作为结果，跳转到5。
3. 如果对象同时满足了`countOf<Key>`, `enumeratorOf<Key>`, 和 `memberOf<Key>:`三个方法，将会创建一个集合对象，该集合对象可以响应`NSSet`的方法，并作为结果，跳转到5。
4. 2和3都不满足的话，如果调用者的类方法`accessInstanceVariablesDirectly`返回`YES`，寻找对象中实例变量，形如`_<key>`, `_is<Key>`, `<key>`, `is<Key>`，按顺序找到其中之一，作为结果跳转到5，否则跳转到6。
5. 如果获取的到结果是对象的指针，则直接返回结果。结果为常量的话，且`NSNumber`支持，使用`NSNumber`封装成对象后返回该对象。否则使用`NSValue`封装成对象后返回。

调用`mutableArrayValueForKey:`时，我们将一个字符串`<key>`作为输入，然后得到对应的`NSMutableArray`作为输出。

1. 在对象中找到一对方法`insertObject:in<Key>AtIndex:`和`removeObjectFrom<Key>AtIndex:`，该`mutableArray`对象能够通过组合调用这一对方法来响应`NSMutableArray`的各种方法。
2. 如果该对象没有修改array的方法，且有`set<Key>:`方法，返回对应的属性值，并且每次修改`mutableArray`后，都会调用该方法给对象中的不可变数组重新赋值，效率较低。
3. 如果1和2都不符合条件，且类方法`accessInstanceVariablesDirectly`返回`YES`，按顺序查找`_<key>`或者`<key>`实例变量，若找到则返回一个代理对象，用来转发`NSMutableArray`的消息。该对象会接收到一个`NSMutableArray`的实例（或者是`NSMutableArray`的子类）。
4. 如果所有条件都不符合，返回一个代理对象，向调用者发送`setValue:forUndefinedKey:`消息。

其它`mutable`方法的实现类似。

#### KVC给属性赋值的顺序
调用`setValue:forKey:`时，我们将一个`<value>`和`<key>`作为输入，然后将`<value>`赋值给对象中名为`<key>`的变量。

1. 寻找对象中`<key>`的`setter`方法，`set<Key>:`或者是 `_set<Key>`，按顺序找到后，传入`<value>`作为方法参数，方法返回。否则进行下一步。
2. 没有找到对应的方法，并且调用者的类方法`accessInstanceVariablesDirectly`返回`YES`，寻找对象中实例变量，形如`_<key>`, `_is<Key>`, `<key>`, `is<Key>`，按顺序找到其中之一，对其赋值`<value>`，方法返回。否则进行下一步。
3. 没有找到和`<key>`对应的属性值，调用`setValue:forUndefinedKey:`方法，传入`<value>`和`<key>`。