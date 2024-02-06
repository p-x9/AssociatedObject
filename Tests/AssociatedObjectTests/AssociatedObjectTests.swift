import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import MacroTesting

#if canImport(AssociatedObjectPlugin)
@testable import AssociatedObjectPlugin
@testable import AssociatedObject

final class AssociatedObjectTests: XCTestCase {

    override func invokeTest() {
        withMacroTesting(
//            isRecording: true,
            macros: ["AssociatedObject": AssociatedObjectMacro.self]
        ) {
            super.invokeTest()
        }
    }

    func testString() throws {
        assertMacro {
            """
            @AssociatedObject(.retain(.atomic))
            var string: String = "text"
            """
        } expansion: {
            """
            var string: String = "text" {
                get {
                    if let value = getAssociatedObject(
                        self,
                        Self.__associated_stringKey
                    ) as? String {
                        return value
                    } else {
                        let value: String = "text"
                        setAssociatedObject(
                            self,
                            Self.__associated_stringKey,
                            value,
                            .retain(.atomic)
                        )
                        return value
                    }
                }
                set {
                    setAssociatedObject(
                        self,
                        Self.__associated_stringKey,
                        newValue,
                        .retain(.atomic)
                    )
                }
            }

            @inline(never) static var __associated_stringKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }

    func testInt() throws {
        assertMacro {
            """
            @AssociatedObject(.retain(.nonatomic))
            var int: Int = 5
            """
        } expansion: {
            """
            var int: Int = 5 {
                get {
                    if let value = getAssociatedObject(
                        self,
                        Self.__associated_intKey
                    ) as? Int {
                        return value
                    } else {
                        let value: Int = 5
                        setAssociatedObject(
                            self,
                            Self.__associated_intKey,
                            value,
                            .retain(.nonatomic)
                        )
                        return value
                    }
                }
                set {
                    setAssociatedObject(
                        self,
                        Self.__associated_intKey,
                        newValue,
                        .retain(.nonatomic)
                    )
                }
            }

            @inline(never) static var __associated_intKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }

    func testFloat() throws {
        assertMacro {
            """
            @AssociatedObject(.retain(.nonatomic))
            var float: Float = 5.0
            """
        } expansion: {
            """
            var float: Float = 5.0 {
                get {
                    if let value = getAssociatedObject(
                        self,
                        Self.__associated_floatKey
                    ) as? Float {
                        return value
                    } else {
                        let value: Float = 5.0
                        setAssociatedObject(
                            self,
                            Self.__associated_floatKey,
                            value,
                            .retain(.nonatomic)
                        )
                        return value
                    }
                }
                set {
                    setAssociatedObject(
                        self,
                        Self.__associated_floatKey,
                        newValue,
                        .retain(.nonatomic)
                    )
                }
            }

            @inline(never) static var __associated_floatKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }

    func testDouble() throws {
        assertMacro {
            """
            @AssociatedObject(.retain(.nonatomic))
            var double: Double = 5.0
            """
        } expansion: {
            """
            var double: Double = 5.0 {
                get {
                    if let value = getAssociatedObject(
                        self,
                        Self.__associated_doubleKey
                    ) as? Double {
                        return value
                    } else {
                        let value: Double = 5.0
                        setAssociatedObject(
                            self,
                            Self.__associated_doubleKey,
                            value,
                            .retain(.nonatomic)
                        )
                        return value
                    }
                }
                set {
                    setAssociatedObject(
                        self,
                        Self.__associated_doubleKey,
                        newValue,
                        .retain(.nonatomic)
                    )
                }
            }

            @inline(never) static var __associated_doubleKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }

    func testStringWithOtherPolicy() throws {
        assertMacro {
            """
            @AssociatedObject(.retain(.nonatomic))
            var string: String = "text"
            """
        } expansion: {
            """
            var string: String = "text" {
                get {
                    if let value = getAssociatedObject(
                        self,
                        Self.__associated_stringKey
                    ) as? String {
                        return value
                    } else {
                        let value: String = "text"
                        setAssociatedObject(
                            self,
                            Self.__associated_stringKey,
                            value,
                            .retain(.nonatomic)
                        )
                        return value
                    }
                }
                set {
                    setAssociatedObject(
                        self,
                        Self.__associated_stringKey,
                        newValue,
                        .retain(.nonatomic)
                    )
                }
            }

            @inline(never) static var __associated_stringKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }

    func testOptionalString() throws {
        assertMacro {
            """
            @AssociatedObject(.retain(.nonatomic))
            var string: String?
            """
        } expansion: {
            """
            var string: String? {
                get {
                    getAssociatedObject(
                        self,
                        Self.__associated_stringKey
                    ) as? String?
                    ?? nil
                }
                set {
                    setAssociatedObject(
                        self,
                        Self.__associated_stringKey,
                        newValue,
                        .retain(.nonatomic)
                    )
                }
            }

            @inline(never) static var __associated_stringKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }

    func testOptionalGenericsString() throws {
        assertMacro {
            """
            @AssociatedObject(.retain(.nonatomic))
            var string: Optional<String>
            """
        } expansion: {
            """
            var string: Optional<String> {
                get {
                    getAssociatedObject(
                        self,
                        Self.__associated_stringKey
                    ) as? Optional<String>
                    ?? nil
                }
                set {
                    setAssociatedObject(
                        self,
                        Self.__associated_stringKey,
                        newValue,
                        .retain(.nonatomic)
                    )
                }
            }

            @inline(never) static var __associated_stringKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }

    func testImplicitlyUnwrappedOptionalString() throws {
        assertMacro {
            """
            @AssociatedObject(.retain(.nonatomic))
            var string: String!
            """
        } expansion: {
            """
            var string: String! {
                get {
                    getAssociatedObject(
                        self,
                        Self.__associated_stringKey
                    ) as? String
                    ?? nil
                }
                set {
                    setAssociatedObject(
                        self,
                        Self.__associated_stringKey,
                        newValue,
                        .retain(.nonatomic)
                    )
                }
            }

            @inline(never) static var __associated_stringKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }

    func testOptionalStringWithInitialValue() throws {
        assertMacro {
            """
            @AssociatedObject(.retain(.nonatomic))
            var string: String? = "hello"
            """
        } expansion: {
            """
            var string: String? = "hello" {
                get {
                    if !self.__associated_stringIsSet {
                        let value: String? = "hello"
                        setAssociatedObject(
                            self,
                            Self.__associated_stringKey,
                            value,
                            .retain(.nonatomic)
                        )
                        self.__associated_stringIsSet = true
                        return value
                    } else {
                        return getAssociatedObject(
                            self,
                            Self.__associated_stringKey
                        ) as! String?
                    }
                }
                set {
                    setAssociatedObject(
                        self,
                        Self.__associated_stringKey,
                        newValue,
                        .retain(.nonatomic)
                    )
                }
            }

            @inline(never) static var __associated_stringKey: UnsafeRawPointer {
                _associated_object_key()
            }

            @_AssociatedObject(.retain(.nonatomic)) var __associated_stringIsSet: Bool = false

            @inline(never) static var __associated___associated_stringIsSetKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }

    func testBool() throws {
        assertMacro {
            """
            @AssociatedObject(.retain(.nonatomic))
            var bool: Bool = false
            """
        } expansion: {
            """
            var bool: Bool = false {
                get {
                    if let value = getAssociatedObject(
                        self,
                        Self.__associated_boolKey
                    ) as? Bool {
                        return value
                    } else {
                        let value: Bool = false
                        setAssociatedObject(
                            self,
                            Self.__associated_boolKey,
                            value,
                            .retain(.nonatomic)
                        )
                        return value
                    }
                }
                set {
                    setAssociatedObject(
                        self,
                        Self.__associated_boolKey,
                        newValue,
                        .retain(.nonatomic)
                    )
                }
            }

            @inline(never) static var __associated_boolKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }

    func testIntArray() throws {
        assertMacro {
            """
            @AssociatedObject(.retain(.nonatomic))
            var intArray: [Int] = [1, 2, 3]
            """
        } expansion: {
            """
            var intArray: [Int] = [1, 2, 3] {
                get {
                    if let value = getAssociatedObject(
                        self,
                        Self.__associated_intArrayKey
                    ) as? [Int] {
                        return value
                    } else {
                        let value: [Int] = [1, 2, 3]
                        setAssociatedObject(
                            self,
                            Self.__associated_intArrayKey,
                            value,
                            .retain(.nonatomic)
                        )
                        return value
                    }
                }
                set {
                    setAssociatedObject(
                        self,
                        Self.__associated_intArrayKey,
                        newValue,
                        .retain(.nonatomic)
                    )
                }
            }

            @inline(never) static var __associated_intArrayKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }

    func testOptionalBool() throws {
        assertMacro {
            """
            @AssociatedObject(.retain(.nonatomic))
            var bool: Bool?
            """
        } expansion: {
            """
            var bool: Bool? {
                get {
                    getAssociatedObject(
                        self,
                        Self.__associated_boolKey
                    ) as? Bool?
                    ?? nil
                }
                set {
                    setAssociatedObject(
                        self,
                        Self.__associated_boolKey,
                        newValue,
                        .retain(.nonatomic)
                    )
                }
            }

            @inline(never) static var __associated_boolKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }

    func testDictionary() throws {
        assertMacro {
            """
            @AssociatedObject(.retain(.nonatomic))
            var dic: [String: String] = ["t": "a"]
            """
        } expansion: {
            """
            var dic: [String: String] = ["t": "a"] {
                get {
                    if let value = getAssociatedObject(
                        self,
                        Self.__associated_dicKey
                    ) as? [String: String] {
                        return value
                    } else {
                        let value: [String: String] = ["t": "a"]
                        setAssociatedObject(
                            self,
                            Self.__associated_dicKey,
                            value,
                            .retain(.nonatomic)
                        )
                        return value
                    }
                }
                set {
                    setAssociatedObject(
                        self,
                        Self.__associated_dicKey,
                        newValue,
                        .retain(.nonatomic)
                    )
                }
            }

            @inline(never) static var __associated_dicKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }

    func testWillSet() throws {
        assertMacro {
            """
            @AssociatedObject(.retain(.nonatomic))
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
                    if let value = getAssociatedObject(
                        self,
                        Self.__associated_stringKey
                    ) as? String {
                        return value
                    } else {
                        let value: String = "text"
                        setAssociatedObject(
                            self,
                            Self.__associated_stringKey,
                            value,
                            .retain(.nonatomic)
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

                    setAssociatedObject(
                        self,
                        Self.__associated_stringKey,
                        newValue,
                        .retain(.nonatomic)
                    )
                }
            }

            @inline(never) static var __associated_stringKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }

    func testDidSet() throws {
        assertMacro {
            """
            @AssociatedObject(.retain(.nonatomic))
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
                    if let value = getAssociatedObject(
                        self,
                        Self.__associated_stringKey
                    ) as? String {
                        return value
                    } else {
                        let value: String = "text"
                        setAssociatedObject(
                            self,
                            Self.__associated_stringKey,
                            value,
                            .retain(.nonatomic)
                        )
                        return value
                    }
                }

                set {
                    let oldValue = string
                    setAssociatedObject(
                        self,
                        Self.__associated_stringKey,
                        newValue,
                        .retain(.nonatomic)
                    )

                    let didSet: (String) -> Void = { [self] oldValue in
                        print("didSet: old", oldValue)
                    }
                    didSet(oldValue)
                }
            }

            @inline(never) static var __associated_stringKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }

    func testWillSetAndDidSet() throws {
        assertMacro {
            """
            @AssociatedObject(.retain(.nonatomic))
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
                    if let value = getAssociatedObject(
                        self,
                        Self.__associated_stringKey
                    ) as? String {
                        return value
                    } else {
                        let value: String = "text"
                        setAssociatedObject(
                            self,
                            Self.__associated_stringKey,
                            value,
                            .retain(.nonatomic)
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
                    setAssociatedObject(
                        self,
                        Self.__associated_stringKey,
                        newValue,
                        .retain(.nonatomic)
                    )

                    let didSet: (String) -> Void = { [self] oldValue in
                        print("didSet: old", oldValue)
                    }
                    didSet(oldValue)
                }
            }

            @inline(never) static var __associated_stringKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }

    func testWillSetWithArgument() throws {
        assertMacro {
            """
            @AssociatedObject(.retain(.nonatomic))
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
                    if let value = getAssociatedObject(
                        self,
                        Self.__associated_stringKey
                    ) as? String {
                        return value
                    } else {
                        let value: String = "text"
                        setAssociatedObject(
                            self,
                            Self.__associated_stringKey,
                            value,
                            .retain(.nonatomic)
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

                    setAssociatedObject(
                        self,
                        Self.__associated_stringKey,
                        newValue,
                        .retain(.nonatomic)
                    )
                }
            }

            @inline(never) static var __associated_stringKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }

    func testDidSetWithArgument() throws {
        assertMacro {
            """
            @AssociatedObject(.retain(.nonatomic))
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
                    if let value = getAssociatedObject(
                        self,
                        Self.__associated_stringKey
                    ) as? String {
                        return value
                    } else {
                        let value: String = "text"
                        setAssociatedObject(
                            self,
                            Self.__associated_stringKey,
                            value,
                            .retain(.nonatomic)
                        )
                        return value
                    }
                }

                set {
                    let oldValue = string
                    setAssociatedObject(
                        self,
                        Self.__associated_stringKey,
                        newValue,
                        .retain(.nonatomic)
                    )

                    let didSet: (String) -> Void = { [self] old in
                        print("didSet: old", old)
                    }
                    didSet(oldValue)
                }
            }

            @inline(never) static var __associated_stringKey: UnsafeRawPointer {
                _associated_object_key()
            }
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
                    if let value = getAssociatedObject(
                        self,
                        Self.__associated_stringKey
                    ) as? String {
                        return value
                    } else {
                        let value: String = "text"
                        setAssociatedObject(
                            self,
                            Self.__associated_stringKey,
                            value,
                            .copy(.nonatomic)
                        )
                        return value
                    }
                }
                set {
                    setAssociatedObject(
                        self,
                        Self.__associated_stringKey,
                        newValue,
                        .copy(.nonatomic)
                    )
                }
            }

            @inline(never) static var __associated_stringKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }

    // MARK: Diagnostics test
    func testDiagnosticsDeclarationType() throws {
        assertMacro {
            """
            @AssociatedObject(.retain(.nonatomic))
            struct Item {}
            """
        } diagnostics: {
            """
            @AssociatedObject(.retain(.nonatomic))
            ╰─ 🛑 `@AssociatedObject` must be attached to the property declaration.
            struct Item {}
            """
        }
    }

    func testDiagnosticsGetterAndSetter() throws {
        assertMacro {
            """
            @AssociatedObject(.retain(.nonatomic))
            var string: String? {
                get { "" }
                set {}
            }
            """
        } diagnostics: {
            """
            @AssociatedObject(.retain(.nonatomic))
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
            @AssociatedObject(.retain(.nonatomic))
            var string: String
            """
        } diagnostics: {
            """
            @AssociatedObject(.retain(.nonatomic))
            ╰─ 🛑 Initial values must be specified when using `@AssociatedObject`.
            var string: String
            """
        }
    }

    func testDiagnosticsSpecifyType() throws {
        assertMacro {
            """
            @AssociatedObject(.retain(.nonatomic))
            var string = ["text", 123]
            """
        } diagnostics: {
            """
            @AssociatedObject(.retain(.nonatomic))
            var string = ["text", 123]
                ┬─────
                ├─ 🛑 Specify a type explicitly when using `@AssociatedObject`.
                ╰─ 🛑 Specify a type explicitly when using `@AssociatedObject`.
            """
        }
    }

    func testDiagnosticsInvalidCustomKey() throws {
        assertMacro {
            """
            @AssociatedObject(.retain(.nonatomic), key: "key")
            var string = "string"
            """
        } diagnostics: {
            """
            @AssociatedObject(.retain(.nonatomic), key: "key")
                                                   ┬─────────
                                                   ╰─ 🛑 customKey specification is invalid.
            var string = "string"
            """
        }
    }
}

extension AssociatedObjectTests {
    func testCustomStoreKey() throws {
        assertMacro {
            """
            @AssociatedObject(.retain(.nonatomic), key: key)
            var string: String = "text"
            """
         } expansion: {
            """
            var string: String = "text" {
                get {
                    if let value = getAssociatedObject(
                        self,
                        &key
                    ) as? String {
                        return value
                    } else {
                        let value: String = "text"
                        setAssociatedObject(
                            self,
                            &key,
                            value,
                            .retain(.nonatomic)
                        )
                        return value
                    }
                }
                set {
                    setAssociatedObject(
                        self,
                        &key,
                        newValue,
                        .retain(.nonatomic)
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

        item.implicitlyUnwrappedString = nil
        XCTAssertEqual(item.implicitlyUnwrappedString, nil)

        item.implicitlyUnwrappedString = "modified hello"
        XCTAssertEqual(item.implicitlyUnwrappedString, "modified hello")
    }

    func testSetDefaultValue() {
        let item = ClassType()
        XCTAssertTrue(item.classType === item.classType)
    }

    func testProtocol() {
        let item = ClassType()
        XCTAssertEqual(item.definedInProtocol, "hello")

        item.definedInProtocol = "modified"
        XCTAssertEqual(item.definedInProtocol, "modified")
    }
}
#endif
