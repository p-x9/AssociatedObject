import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MacroTesting
@testable import AssociatedObjectPlugin
@testable import AssociatedObject

final class AssociatedObjectTests: XCTestCase {

    override func invokeTest() {
        withMacroTesting(
            macros: ["AssociatedObject": AssociatedObjectMacro.self]
        ) {
            super.invokeTest()
        }
    }

    func testString() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var string: String = "text"
            """
        } expansion: {
            """
            var string: String = "text" {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        &Self.__associated_stringKey
                    ) as? String {
                        return value
                    } else {
                        let value: String = "text"
                        objc_setAssociatedObject(
                            self,
                            &Self.__associated_stringKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_stringKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            static var __associated_stringKey: UInt8 = 0
            """
        }
    }

    func testInt() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var int: Int = 5
            """
        } expansion: {
            """
            var int: Int = 5 {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        &Self.__associated_intKey
                    ) as? Int {
                        return value
                    } else {
                        let value: Int = 5
                        objc_setAssociatedObject(
                            self,
                            &Self.__associated_intKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_intKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            static var __associated_intKey: UInt8 = 0
            """
        }
    }

    func testFloat() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var float: Float = 5.0
            """
        } expansion: {
            """
            var float: Float = 5.0 {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        &Self.__associated_floatKey
                    ) as? Float {
                        return value
                    } else {
                        let value: Float = 5.0
                        objc_setAssociatedObject(
                            self,
                            &Self.__associated_floatKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_floatKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            static var __associated_floatKey: UInt8 = 0
            """
        }
    }

    func testDouble() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var double: Double = 5.0
            """
        } expansion: {
            """
            var double: Double = 5.0 {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        &Self.__associated_doubleKey
                    ) as? Double {
                        return value
                    } else {
                        let value: Double = 5.0
                        objc_setAssociatedObject(
                            self,
                            &Self.__associated_doubleKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_doubleKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            static var __associated_doubleKey: UInt8 = 0
            """
        }
    }

    func testStringWithOtherPolicy() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_COPY)
            var string: String = "text"
            """
        } expansion: {
            """
            var string: String = "text" {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        &Self.__associated_stringKey
                    ) as? String {
                        return value
                    } else {
                        let value: String = "text"
                        objc_setAssociatedObject(
                            self,
                            &Self.__associated_stringKey,
                            value,
                            .OBJC_ASSOCIATION_COPY
                        )
                        return value
                    }
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_stringKey,
                        newValue,
                        .OBJC_ASSOCIATION_COPY
                    )
                }
            }

            static var __associated_stringKey: UInt8 = 0
            """
        }
    }

    func testOptionalString() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var string: String?
            """
        } expansion: {
            """
            var string: String? {
                get {
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_stringKey
                    ) as? String?
                    ?? nil
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_stringKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            static var __associated_stringKey: UInt8 = 0
            """
        }
    }

    func testOptionalGenericsString() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var string: Optional<String>
            """
        } expansion: {
            """
            var string: Optional<String> {
                get {
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_stringKey
                    ) as? Optional<String>
                    ?? nil
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_stringKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            static var __associated_stringKey: UInt8 = 0
            """
        }
    }

    func testImplicitlyUnwrappedOptionalString() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var string: String!
            """
        } expansion: {
            """
            var string: String! {
                get {
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_stringKey
                    ) as? String
                    ?? nil
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_stringKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            static var __associated_stringKey: UInt8 = 0
            """
        }
    }

    func testOptionalStringWithInitialValue() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var string: String? = "hello"
            """
        } expansion: {
            """
            var string: String? = "hello" {
                get {
                    if !self.__associated_stringIsSet {
                        let value: String? = "hello"
                        objc_setAssociatedObject(
                            self,
                            &Self.__associated_stringKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        self.__associated_stringIsSet = true
                        return value
                    } else {
                        return objc_getAssociatedObject(
                            self,
                            &Self.__associated_stringKey
                        ) as! String?
                    }
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_stringKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            static var __associated_stringKey: UInt8 = 0

            @_AssociatedObject(.OBJC_ASSOCIATION_ASSIGN) var __associated_stringIsSet: Bool = false

            static var __associated___associated_stringIsSetKey: UInt8 = 0
            """
        }
    }

    func testBool() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var bool: Bool = false
            """
        } expansion: {
            """
            var bool: Bool = false {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        &Self.__associated_boolKey
                    ) as? Bool {
                        return value
                    } else {
                        let value: Bool = false
                        objc_setAssociatedObject(
                            self,
                            &Self.__associated_boolKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_boolKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            static var __associated_boolKey: UInt8 = 0
            """
        }
    }

    func testIntArray() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var intArray: [Int] = [1, 2, 3]
            """
        } expansion: {
            """
            var intArray: [Int] = [1, 2, 3] {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        &Self.__associated_intArrayKey
                    ) as? [Int] {
                        return value
                    } else {
                        let value: [Int] = [1, 2, 3]
                        objc_setAssociatedObject(
                            self,
                            &Self.__associated_intArrayKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_intArrayKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            static var __associated_intArrayKey: UInt8 = 0
            """
        }
    }

    func testOptionalBool() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var bool: Bool?
            """
        } expansion: {
            """
            var bool: Bool? {
                get {
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_boolKey
                    ) as? Bool?
                    ?? nil
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_boolKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            static var __associated_boolKey: UInt8 = 0
            """
        }
    }

    func testDictionary() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var dic: [String: String] = ["t": "a"]
            """
        } expansion: {
            """
            var dic: [String: String] = ["t": "a"] {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        &Self.__associated_dicKey
                    ) as? [String: String] {
                        return value
                    } else {
                        let value: [String: String] = ["t": "a"]
                        objc_setAssociatedObject(
                            self,
                            &Self.__associated_dicKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_dicKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            static var __associated_dicKey: UInt8 = 0
            """
        }
    }

    func testWillSet() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var string: String = "text" {
                willSet {
                    print("willSet: old", string)
                    print("willSet: new", newValue)
                }
            }
            """
        } expansion: {
            """
            var string: String = "text" {
                willSet {
                    print("willSet: old", string)
                    print("willSet: new", newValue)
                }
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        &Self.__associated_stringKey
                    ) as? String {
                        return value
                    } else {
                        let value: String = "text"
                        objc_setAssociatedObject(
                            self,
                            &Self.__associated_stringKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }

                set {
                    let willSet: (String) -> Void = { [self] newValue in
                        print("willSet: old", string)
                        print("willSet: new", newValue)
                    }
                    willSet(newValue)

                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_stringKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            static var __associated_stringKey: UInt8 = 0
            """
        }
    }

    func testDidSet() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var string: String = "text" {
                didSet {
                    print("didSet: old", oldValue)
                }
            }
            """
        } expansion: {
            """
            var string: String = "text" {
                didSet {
                    print("didSet: old", oldValue)
                }
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        &Self.__associated_stringKey
                    ) as? String {
                        return value
                    } else {
                        let value: String = "text"
                        objc_setAssociatedObject(
                            self,
                            &Self.__associated_stringKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }

                set {
                    let oldValue = string
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_stringKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )

                    let didSet: (String) -> Void = { [self] oldValue in
                        print("didSet: old", oldValue)
                    }
                    didSet(oldValue)
                }
            }

            static var __associated_stringKey: UInt8 = 0
            """
        }
    }

    func testWillSetAndDidSet() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var string: String = "text" {
                willSet {
                    print("willSet: old", string)
                    print("willSet: new", newValue)
                }
                didSet {
                    print("didSet: old", oldValue)
                }
            }
            """
        } expansion: {
            """
            var string: String = "text" {
                willSet {
                    print("willSet: old", string)
                    print("willSet: new", newValue)
                }
                didSet {
                    print("didSet: old", oldValue)
                }
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        &Self.__associated_stringKey
                    ) as? String {
                        return value
                    } else {
                        let value: String = "text"
                        objc_setAssociatedObject(
                            self,
                            &Self.__associated_stringKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }

                set {
                    let willSet: (String) -> Void = { [self] newValue in
                        print("willSet: old", string)
                        print("willSet: new", newValue)
                    }
                    willSet(newValue)

                    let oldValue = string
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_stringKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )

                    let didSet: (String) -> Void = { [self] oldValue in
                        print("didSet: old", oldValue)
                    }
                    didSet(oldValue)
                }
            }

            static var __associated_stringKey: UInt8 = 0
            """
        }
    }

    func testWillSetWithArgument() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var string: String = "text" {
                willSet(new) {
                    print("willSet: old", string)
                    print("willSet: new", new)
                }
            }
            """
        } expansion: {
            """
            var string: String = "text" {
                willSet(new) {
                    print("willSet: old", string)
                    print("willSet: new", new)
                }
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        &Self.__associated_stringKey
                    ) as? String {
                        return value
                    } else {
                        let value: String = "text"
                        objc_setAssociatedObject(
                            self,
                            &Self.__associated_stringKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }

                set {
                    let willSet: (String) -> Void = { [self] new in
                        print("willSet: old", string)
                        print("willSet: new", new)
                    }
                    willSet(newValue)

                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_stringKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            static var __associated_stringKey: UInt8 = 0
            """
        }
    }

    func testDidSetWithArgument() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var string: String = "text" {
                didSet(old) {
                    print("didSet: old", old)
                }
            }
            """
        } expansion: {
            """
            var string: String = "text" {
                didSet(old) {
                    print("didSet: old", old)
                }
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        &Self.__associated_stringKey
                    ) as? String {
                        return value
                    } else {
                        let value: String = "text"
                        objc_setAssociatedObject(
                            self,
                            &Self.__associated_stringKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }

                set {
                    let oldValue = string
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_stringKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )

                    let didSet: (String) -> Void = { [self] old in
                        print("didSet: old", old)
                    }
                    didSet(oldValue)
                }
            }

            static var __associated_stringKey: UInt8 = 0
            """
        }
    }

    func testModernWritingStyle() throws {
        assertMacro {
            """
            @AssociatedObject(.copy(.nonatomic))
            var string: String = "text"
            """
        } expansion: {
            """
            var string: String = "text" {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        &Self.__associated_stringKey
                    ) as? String {
                        return value
                    } else {
                        let value: String = "text"
                        objc_setAssociatedObject(
                            self,
                            &Self.__associated_stringKey,
                            value,
                            .copy(.nonatomic)
                        )
                        return value
                    }
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_stringKey,
                        newValue,
                        .copy(.nonatomic)
                    )
                }
            }

            static var __associated_stringKey: UInt8 = 0
            """
        }
    }

    // MARK: Diagnostics test
    func testDiagnosticsDeclarationType() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            struct Item {}
            """
        } diagnostics: {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            ╰─ 🛑 `@AssociatedObject` must be attached to the property declaration.
            struct Item {}
            """
        }
    }

    func testDiagnosticsGetterAndSetter() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var string: String? {
                get { "" }
                set {}
            }
            """
        } diagnostics: {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var string: String? {
                get { "" }
                set {}
                ┬─────
                ╰─ 🛑 getter and setter must not be implemented when using `@AssociatedObject`.
            }
            """
        }
    }

    func testDiagnosticsInitialValue() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var string: String
            """
        } diagnostics: {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            ╰─ 🛑 Initial values must be specified when using `@AssociatedObject`.
            var string: String
            """
        }
    }

    func testDiagnosticsSpecifyType() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var string = ["text", 123]
            """
        } diagnostics: {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var string = ["text", 123]
                ┬─────
                ├─ 🛑 Specify a type explicitly when using `@AssociatedObject`.
                ╰─ 🛑 Specify a type explicitly when using `@AssociatedObject`.
            """
        }
    }
}

extension AssociatedObjectTests {
    func testCustomStoreKey() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN, key: key)
            var string: String = "text"
            """
         } expansion: {
            """
            var string: String = "text" {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        &Self.__associated_stringKey
                    ) as? String {
                        return value
                    } else {
                        let value: String = "text"
                        objc_setAssociatedObject(
                            self,
                            &key,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        &key,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }
            """
        }
    }
}

extension AssociatedObjectTests {
    func testOptional() {
        let item = ClassType()
        XCTAssertEqual(item.optionalDouble, 123.4)

        item.optionalDouble = nil
        XCTAssertEqual(item.optionalDouble, nil)

        item.implicitlyUnwrappedString = "hello"
        XCTAssertEqual(item.implicitlyUnwrappedString, "hello")
    }

    func testSetDefaultValue() {
        let item = ClassType()
        XCTAssertTrue(item.classType === item.classType)
    }
}
