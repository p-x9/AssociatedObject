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
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_stringKey
                    ) as? String
                    ?? "text"
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
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_intKey
                    ) as? Int
                    ?? 5
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
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_floatKey
                    ) as? Float
                    ?? 5.0
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
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_doubleKey
                    ) as? Double
                    ?? 5.0
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
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_stringKey
                    ) as? String
                    ?? "text"
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
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_boolKey
                    ) as? Bool
                    ?? false
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
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_intArrayKey
                    ) as? [Int]
                    ?? [1, 2, 3]
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
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_dicKey
                    ) as? [String: String]
                    ?? ["t": "a"]
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
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_stringKey
                    ) as? String
                    ?? "text"
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
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_stringKey
                    ) as? String
                    ?? "text"
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
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_stringKey
                    ) as? String
                    ?? "text"
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
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_stringKey
                    ) as? String
                    ?? "text"
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
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_stringKey
                    ) as? String
                    ?? "text"
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
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_stringKey
                    ) as? String
                    ?? "text"
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

// MARK: - TypeDetection
final class AssociatedTypeDetectionObjectTests: XCTestCase {
    let macros: [String: Macro.Type] = [
        "AssociatedObject": AssociatedObjectMacro.self
    ]

    func testTypeDetectionInt() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var int = 10
            """,
            expandedSource:
            """
            var int = 10 {
                get {
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_intKey
                    ) as? Int
                    ?? 10
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

    func testTypeDetectionDouble() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var double = 10.0
            """,
            expandedSource:
            """
            var double = 10.0 {
                get {
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_doubleKey
                    ) as? Double
                    ?? 10.0
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

    func testTypeDetectionFloat() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var float = 10.0
            """,
            expandedSource:
            """
            var float = 10.0 {
                get {
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_floatKey
                    ) as? Double
                    ?? 10.0
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

    func testTypeDetectionString() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var string = "text"
            """,
            expandedSource:
            """
            var string = "text" {
                get {
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_stringKey
                    ) as? String
                    ?? "text"
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

    func testTypeDetectionBool() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var bool = false
            """,
            expandedSource:
            """
            var bool = false {
                get {
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_boolKey
                    ) as? Bool
                    ?? false
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

    func testTypeDetectionIntArray() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var intArray = [1, 2, 3]
            """,
            expandedSource:
            """
            var intArray = [1, 2, 3] {
                get {
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_intArrayKey
                    ) as? [Int]
                    ?? [1, 2, 3]
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

    func testTypeDetectionDoubleArray() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var doubleArray = [1.0, 2.0, 3.0]
            """,
            expandedSource:
            """
            var doubleArray = [1.0, 2.0, 3.0] {
                get {
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_doubleArrayKey
                    ) as? [Double]
                    ?? [1.0, 2.0, 3.0]
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_doubleArrayKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            static var __associated_doubleArrayKey: UInt8 = 0
            """,
            macros: macros
        )
    }

    func testTypeDetectionBoolArray() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var boolArray = [true, false]
            """,
            expandedSource:
            """
            var boolArray = [true, false] {
                get {
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_boolArrayKey
                    ) as? [Bool]
                    ?? [true, false]
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_boolArrayKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            static var __associated_boolArrayKey: UInt8 = 0
            """,
            macros: macros
        )
    }

    func testTypeDetectionStringArray() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var stringArray = ["1.0", "2.0", "3.0"]
            """,
            expandedSource:
            """
            var stringArray = ["1.0", "2.0", "3.0"] {
                get {
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_stringArrayKey
                    ) as? [String]
                    ?? ["1.0", "2.0", "3.0"]
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_stringArrayKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            static var __associated_stringArrayKey: UInt8 = 0
            """,
            macros: macros
        )
    }

    func testTypeDetectionOptionalIntArray() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var optionalIntArray = [1, 2, 3, nil]
            """,
            expandedSource:
            """
            var optionalIntArray = [1, 2, 3, nil] {
                get {
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_optionalIntArrayKey
                    ) as? [Int?]
                    ?? [1, 2, 3, nil]
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_optionalIntArrayKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            static var __associated_optionalIntArrayKey: UInt8 = 0
            """,
            macros: macros
        )
    }

    func testTypeDetectionOptionalDoubleArray() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var optionalDoubleArray = [1.0, 2.0, 3.0, nil]
            """,
            expandedSource:
            """
            var optionalDoubleArray = [1.0, 2.0, 3.0, nil] {
                get {
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_optionalDoubleArrayKey
                    ) as? [Double?]
                    ?? [1.0, 2.0, 3.0, nil]
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_optionalDoubleArrayKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            static var __associated_optionalDoubleArrayKey: UInt8 = 0
            """,
            macros: macros
        )
    }

    func testTypeDetectionOptionalBoolArray() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var optionalBoolArray = [true, false, nil]
            """,
            expandedSource:
            """
            var optionalBoolArray = [true, false, nil] {
                get {
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_optionalBoolArrayKey
                    ) as? [Bool?]
                    ?? [true, false, nil]
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_optionalBoolArrayKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            static var __associated_optionalBoolArrayKey: UInt8 = 0
            """,
            macros: macros
        )
    }

    func testTypeDetectionOptionalStringArray() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var optionalStringArray = ["true", "false", nil]
            """,
            expandedSource:
            """
            var optionalStringArray = ["true", "false", nil] {
                get {
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_optionalStringArrayKey
                    ) as? [String?]
                    ?? ["true", "false", nil]
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        &Self.__associated_optionalStringArrayKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            static var __associated_optionalStringArrayKey: UInt8 = 0
            """,
            macros: macros
        )
    }

    func testTypeDetectionStringDictionary() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var dic = ["t": "a", "s": "b"]
            """,
            expandedSource:
            """
            var dic = ["t": "a", "s": "b"] {
                get {
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_dicKey
                    ) as? [String: String]
                    ?? ["t": "a", "s": "b"]
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

    func testTypeDetectionIntDictionary() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var dic = [1: 3, 2: 4]
            """,
            expandedSource:
            """
            var dic = [1: 3, 2: 4] {
                get {
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_dicKey
                    ) as? [Int: Int]
                    ?? [1: 3, 2: 4]
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

    func testTypeDetectionDoubleDictionary() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var dic = [1.0: 3.0, 2.0: 4.0]
            """,
            expandedSource:
            """
            var dic = [1.0: 3.0, 2.0: 4.0] {
                get {
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_dicKey
                    ) as? [Double: Double]
                    ?? [1.0: 3.0, 2.0: 4.0]
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
}
