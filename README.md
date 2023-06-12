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
    @AssociatedObject(.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    var text = "text"
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

## License
AssociatedObject is released under the MIT License. See [LICENSE](./LICENSE)
