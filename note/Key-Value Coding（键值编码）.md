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
