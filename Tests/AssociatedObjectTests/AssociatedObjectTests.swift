import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
@testable import AssociatedObjectPlugin
@testable import AssociatedObject

final class AssociatedObjectTests: XCTestCase {
    let macros: [String: Macro.Type] = [
        "AssociatedObject": AssociatedObjectMacro.self
    ]
    
    func testString() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var string: String = "text"
            """,
            expandedSource:
            """
            var string: String = "text" {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        &Self.__associated_stringKey
                    ) as? String {
                        return value
                    }
                    let value: String = "text"
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_stringKey,
                        value,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                    return value
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
            """,
            macros: macros
        )
    }

    func testInt() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var int: Int = 5
            """,
            expandedSource:
            """
            var int: Int = 5 {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        &Self.__associated_intKey
                    ) as? Int {
                        return value
                    }
                    let value: Int = 5
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_intKey,
                        value,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                    return value
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
            """,
            macros: macros
        )
    }

    func testFloat() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var float: Float = 5.0
            """,
            expandedSource:
            """
            var float: Float = 5.0 {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        &Self.__associated_floatKey
                    ) as? Float {
                        return value
                    }
                    let value: Float = 5.0
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_floatKey,
                        value,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                    return value
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
            """,
            macros: macros
        )
    }

    func testDouble() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var double: Double = 5.0
            """,
            expandedSource:
            """
            var double: Double = 5.0 {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        &Self.__associated_doubleKey
                    ) as? Double {
                        return value
                    }
                    let value: Double = 5.0
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_doubleKey,
                        value,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                    return value
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
            """,
            macros: macros
        )
    }

    func testStringWithOtherPolicy() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_COPY)
            var string: String = "text"
            """,
            expandedSource:
            """
            var string: String = "text" {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        &Self.__associated_stringKey
                    ) as? String {
                        return value
                    }
                    let value: String = "text"
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_stringKey,
                        value,
                        .OBJC_ASSOCIATION_COPY
                    )
                    return value
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
            """,
            macros: macros
        )
    }

    func testOptionalString() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var string: String?
            """,
            expandedSource:
            """
            var string: String? {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        &Self.__associated_stringKey
                    ) as? String {
                        return value
                    }
                    return nil
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
            """,
            macros: macros
        )
    }
    
    func testImplicitlyUnwrappedOptionalString() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var string: String!
            """,
            expandedSource:
            """
            var string: String! {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        &Self.__associated_stringKey
                    ) as? String {
                        return value
                    }
                    return nil
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
            """,
            macros: macros
        )
    }

    func testOptionalGenericsString() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var string: Optional<String>
            """,
            expandedSource:
            """
            var string: Optional<String> {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        &Self.__associated_stringKey
                    ) as? Optional<String> {
                        return value
                    }
                    return nil
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
            """,
            macros: macros
        )
    }

    func testBool() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var bool: Bool = false
            """,
            expandedSource:
            """
            var bool: Bool = false {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        &Self.__associated_boolKey
                    ) as? Bool {
                        return value
                    }
                    let value: Bool = false
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_boolKey,
                        value,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                    return value
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
            """,
            macros: macros
        )
    }

    func testIntArray() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var intArray: [Int] = [1, 2, 3]
            """,
            expandedSource:
            """
            var intArray: [Int] = [1, 2, 3] {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        &Self.__associated_intArrayKey
                    ) as? [Int] {
                        return value
                    }
                    let value: [Int] = [1, 2, 3]
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_intArrayKey,
                        value,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                    return value
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
            """,
            macros: macros
        )
    }

    func testOptionalBool() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var bool: Bool?
            """,
            expandedSource:
            """
            var bool: Bool? {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        &Self.__associated_boolKey
                    ) as? Bool {
                        return value
                    }
                    return nil
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
            """,
            macros: macros
        )
    }

    func testDictionary() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var dic: [String: String] = ["t": "a"]
            """,
            expandedSource:
            """
            var dic: [String: String] = ["t": "a"] {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        &Self.__associated_dicKey
                    ) as? [String: String] {
                        return value
                    }
                    let value: [String: String] = ["t": "a"]
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_dicKey,
                        value,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                    return value
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
            """,
            macros: macros
        )
    }

    func testWillSet() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var string: String = "text" {
                willSet {
                    print("willSet: old", string)
                    print("willSet: new", newValue)
                }
            }
            """,
            expandedSource:
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
                    }
                    let value: String = "text"
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_stringKey,
                        value,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                    return value
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
            """,
            macros: macros
        )
    }

    func testDidSet() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var string: String = "text" {
                didSet {
                    print("didSet: old", oldValue)
                }
            }
            """,
            expandedSource:
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
                    }
                    let value: String = "text"
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_stringKey,
                        value,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                    return value
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
            """,
            macros: macros
        )
    }

    func testWillSetAndDidSet() throws {
        assertMacroExpansion(
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
            """,
            expandedSource:
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
                    }
                    let value: String = "text"
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_stringKey,
                        value,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                    return value
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
            """,
            macros: macros
        )
    }

    func testWillSetWithArgument() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var string: String = "text" {
                willSet(new) {
                    print("willSet: old", string)
                    print("willSet: new", new)
                }
            }
            """,
            expandedSource:
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
                    }
                    let value: String = "text"
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_stringKey,
                        value,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                    return value
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
            """,
            macros: macros
        )
    }

    func testDidSetWithArgument() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var string: String = "text" {
                didSet(old) {
                    print("didSet: old", old)
                }
            }
            """,
            expandedSource:
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
                    }
                    let value: String = "text"
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_stringKey,
                        value,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                    return value
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
            """,
            macros: macros
        )
    }

    func testModernWritingStyle() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.copy(.nonatomic))
            var string: String = "text"
            """,
            expandedSource:
            """
            var string: String = "text" {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        &Self.__associated_stringKey
                    ) as? String {
                        return value
                    }
                    let value: String = "text"
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_stringKey,
                        value,
                        .copy(.nonatomic)
                    )
                    return value
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
            """,
            macros: macros
        )
    }

    // MARK: Diagnostics test
    func testDiagnosticsDeclarationType() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            struct Item {}
            """,
            expandedSource:
            """
            struct Item {}
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: AssociatedObjectMacroDiagnostic
                        .requiresVariableDeclaration
                        .message,
                    line: 1,
                    column: 1
                )
            ],
            macros: macros
        )
    }

    func testDiagnosticsGetterAndSetter() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var string: String? {
                get { "" }
                set {}
            }
            """,
            expandedSource:
            """
            var string: String? {
                get { "" }
                set {}
            }

            static var __associated_stringKey: UInt8 = 0
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: AssociatedObjectMacroDiagnostic
                        .getterAndSetterShouldBeNil
                        .message,
                    line: 4,
                    column: 5
                )
            ],
            macros: macros
        )
    }

    func testDiagnosticsInitialValue() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var string: String
            """,
            expandedSource:
            """
            var string: String

            static var __associated_stringKey: UInt8 = 0
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: AssociatedObjectMacroDiagnostic
                        .requiresInitialValue
                        .message,
                    line: 1,
                    column: 1
                )
            ],
            macros: macros
        )
    }

    func testDiagnosticsSpecifyType() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var string = ["text", 123]
            """,
            expandedSource:
            """
            var string = ["text", 123]

            static var __associated_stringKey: UInt8 = 0
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: AssociatedObjectMacroDiagnostic
                        .specifyTypeExplicitly
                        .message,
                    line: 2,
                    column: 5
                )
            ],
            macros: macros
        )
    }
}
