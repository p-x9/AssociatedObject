# AssociatedObject
Swift Macro for allowing variable declarations even in class extensions.
It is implemented by wrapping `objc_getAssociatedObject`/`objc_setAssociatedObject`.

<!-- # Badges -->

[![Github issues](https://img.shields.io/github/issues/p-x9/AssociatedObject)](https://github.com/p-x9/AssociatedObject/issues)
[![Github forks](https://img.shields.io/github/forks/p-x9/AssociatedObject)](https://github.com/p-x9/AssociatedObject/network/members)
[![Github stars](https://img.shields.io/github/stars/p-x9/AssociatedObject)](https://github.com/p-x9/AssociatedObject/stargazers)
[![Github top language](https://img.shields.io/github/languages/top/p-x9/AssociatedObject)](https://github.com/p-x9/AssociatedObject/)

## Usage
For example, you can add a new stored property to `UIViewController` by declaring the following
```swift
import AssociatedObject

extension UIViewController {
    @AssociatedObject(.retain(nonatomic))
    var text = "text"

    /* OR */

    @AssociatedObject(.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    var text = "text"

    static var customKey = ""
    @AssociatedObject(.OBJC_ASSOCIATION_RETAIN_NONATOMIC, key: customKey)
    var somevar = "text"
}
```

Declared properties can be used as follows
```swift
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        print(text) // => "text"

        text = "hello"
        print(text) // => "hello"
    }

}
```
### willSet/didSet
Properties defined using `@AssociatedObject` can implement willSet and didSet.
In swift, it is not possible to implement `willSet` and `didSet` at the same time as setter, so they are expanded as follows.

```swift
@AssociatedObject(.copy(nonatomic))
public var hello: String = "こんにちは" {
    didSet {
        print("didSet")
    }
    willSet {
        print("willSet: \(newValue)")
    }
}

// ↓↓↓ expand to ... ↓↓↓
public var hello: String = "こんにちは" {
    get {
        objc_getAssociatedObject(
            self,
            &Self.__associated_helloKey
        ) as? String
        ?? "こんにちは"
    }

    set {
        let willSet: (String) -> Void = { [self] newValue in
            print("willSet: \(newValue)")
        }
        willSet(newValue)

        let oldValue = hello

        objc_setAssociatedObject(
            self,
            &Self.__associated_helloKey,
            newValue,
            .copy(nonatomic)
        )

        let didSet: (String) -> Void = { [self] oldValue in
            print("didSet")
        }
        didSet(oldValue)
    }
}
```

## License
AssociatedObject is released under the MIT License. See [LICENSE](./LICENSE)
