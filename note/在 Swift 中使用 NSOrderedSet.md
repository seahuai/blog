#### NSOrderedSet

`NSOrderedSet` 是个优秀的集合类，结合了数组和集合的特点，它有着很优秀的查找速度，又能够通过索引进行随机访问。

它提供了 `NSSet` 中复杂度仅为 O(1) 的关系查找和 `NSArray` 的 O(1) 时间复杂度的随机访问。但也因此有着 O(n) 时间的插入操作。`NSOrderedSet` 是通过封装 `NSArray` 和 `NSSet` 实现的，所以相比这两个类占用更多的内存。

性能特征（数据来源）：

```markdown
类 / 时间 [ms]	1.000.000 elements
NSMutableOrderedSet, adding	3190.52
NSMutableSet, adding	2511.96
NSMutableArray, adding	1423.26
NSMutableOrderedSet, random access	10.74
NSMutableSet, random access	4.47
NSMutableArray, random access	8.08
```

#### 问题

在 Objective-c 中，大部分基础集合类，如 `NSArray`、`NSDictionary`、`NSSet`，这些类在 Swift 中也都有其对应的“替身”：`Array`、`Dictionary`、`Set`。但 `NSOrderedSet` 并没有对应的 Swift 版本，在 Swift 中使用起来并不方便。

* 问题一：NSOrderedSet 是一个类，因此它的实例是引用类型，在 Swift 中集合类型都是值类型。

```swift
let set = NSMutableOrderedSet()
set.add(1)
// set: [1]

let other = set
other.add(2)
// set: [1, 2]
// other: [1, 2]
```

* 问题二：NSOrderedSet 是一个混合类型的序列，它接受 Any 类型的成员。其API不可以指定元素的类型，无法约束其存储的成员。

```swift
struct Model {}
let set = NSMutableOrderedSet()

set.add("Test")
set.contains("Test") // true

let model = Model()
set.add(model)
set.contains(model) // false
```

为何 String 和自己实现的 Model 类型都为结构体，但二者存在差异呢？

1. NSOrderedSet 使用 NSObject 的 hash 来提高查找操作，每一个 NSObject 类型都有默认实现的哈希方法，NSOrderedSet 的 API 接受一个 NSObject 对象。

2. 在 Swift 中的值桥接到 OC 中，编译器会自动将 Swift 的类型包装（box）成 NSObject 的子类，如该 Swift 的类型实现了 Hashable 协议，Box对象会使用其对应的方法来实现 NSObject 对应的 hash 方法，因此代码中使用同样为值类型的 String 不会有问题。而没有实现 Hashable 协议的话，NSObject 的哈希值的默认实现都将基于其实例的地址，对于值类型的实例，实例的地址就不可靠了。

#### 解决方法

定义一个泛型的封装结构体，它的内部使用 NSOrderedSet 的实例作为存储，并实现对应的协议方法。

1. 使用结构体，并且限制成员类型

```Swift
struct OrderedSet<Element> where Element: Hashable {
    private var store = NSMutableOrderedSet()
}
```

2. 实现ExpressibleByArrayLiteral、CustomStringConvertible 协议

```swift
extension OrderedSet: ExpressibleByArrayLiteral, CustomStringConvertible {
    typealias ArrayLiteralElement = Element
    
    init(arrayLiteral elements: ArrayLiteralElement...) {
        elements.forEach { store.add($0) }
    }
    
    var description: String {
        let members = store.map {
            return "\($0)"
        }
        return "[\(members.joined(separator: ","))]"
    }
}
```

实现 ExpressibleByArrayLiteral 协议，就可以通过数组直接创建实例。实现 CustomStringConvertible 方便通过打印来查看成员值。

```swift
let orderedSet: OrderedSet<Int> = [1, 1, 2, 3]
print(orderedSet) // [1,2,3]
```

3. 实现 Collection 协议，Collection 协议继承自 Sequence 协议。Collection 协议一共有五个关联类型，十来个实例方法。但庆幸的是，该协议大部分关联类型和方法都有默认的实现，如果没有特殊的定制需求，满足该协议只需要实现：
   1.  startIndex 和 endIndex 属性
   2. 下标读取方法
   3. 索引计算方法

```swift
extension OrderedSet: Collection {
    typealias Element = Element
    typealias Index = Int
    
    var startIndex: Int {
        return 0
    }
    var endIndex: Int {
        return store.count
    }
    
    func index(after i: Int) -> Int {
        return i + 1
    }
    
    subscript(position: Int) -> Element {
        return store[position] as! Element
    }
}
```

4. 实现 RangeReplaceableCollection 协议提供插入和删除方法，该协议大部分方法都提供了默认的实现，因此只需要实现插入和删除方法即可。

```swift
extension OrderedSet: RangeReplaceableCollection {
    func insert(_ newElement: Element, at i: Int) {
        store.insert(newElement, at: i)
    }
    
    func remove(at position: Int) -> Element {
        let object = store.object(at: position)
        store.remove(object)
        return object as! Element
    }
}
```



至此，OrderedSet 已经几乎满足基本使用了。

```swift
var orderedSet: OrderedSet<Int> = []
orderedSet.append(1)
orderedSet.append(1)
orderedSet.append(2)
// [1, 2]
if let index = orderedSet.firstIndex(of: 2) {
    orderedSet.remove(at: index)
	  // [1]
}
```

4. 满足值语义

OrderedSet 中包一个指向 NSMutableOrderSet 的实例的引用，因此每次拷贝 OrderedSet 的值只会增加该实例的引用计数。

Swift 标准库提供了一个名为 isKnownUniquelyReferenced 的函数，可以调用它来判断一个指向对象的特定引用是否唯一。但该方法无法用于 NSObject 的子类，对于 NSObject 的子类，该方法永远返回 true。因此我们重新定义一个类，并创建对应的实例，用于判断替代 NSMutableOrderSet。

```swift
struct OrderedSet<Element> where Element: Hashable {
	  fileprivate class ReferenceFlag {}
    fileprivate var flag = ReferenceFlag()
}
```

提供 `makeUnique` 实例方法，用于判断是否需要重新生成 NSMutableOrderedSet 实例。

```swift
fileprivate mutating func makeUnique() {
    if !isKnownUniquelyReferenced(&flag) {
        store = store.mutableCopy() as! NSMutableOrderedSet
        flag = ReferenceFlag()
    }
}
```

在插入和删除的方法中调用该方法，实现写时复制，但因为需要修改变量，方法需要使用 mutating 进行声明：

```swift
mutating func insert(_ newElement: Element, at i: Int) {
    makeUnique()
    /.../
}
mutating func remove(at position: Int) -> Element {
    makeUnique()
    /.../
}
```

```swift
var orderedSet: OrderedSet<Int> = []
orderedSet.append(1)
orderedSet.append(2)

var other = orderedSet
other.append(3)

print(orderedSet) // [1, 2]
print(other)      // [1, 2, 3]
```

至此，在 Swift 中使用 NSOrderedSet 的问题都已经得到了解决。

#### 总结

1. 在 Swift 中使用 OC 中的方法和类，OC 的方法相比 Swift 宽容许多，需要注意值类型作为参数的使用情况。
2. 使用 Swift 封装 OC 的类进行使用，在 Swift 中是非常常见的场景，虽然增加了编码的成本，但带来的收益也是可观的。
3. OrderedSet 还不够健全，没有提供集合代数的相关方法，更进一步可以实现协议 SetAlgebra。



参考：

1. https://objccn.io/issue-7-1/
2. https://academy.realm.io/cn/posts/try-swift-soroush-khanlou-sequence-collection/
3. 《Swift 集合类型优化》王巍，陈聿菡

