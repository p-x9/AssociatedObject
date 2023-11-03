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
                    let willSet: (String ) -> Void = { [self] newValue in
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

                    let didSet: (String ) -> Void = { [self] oldValue in
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
                    let willSet: (String ) -> Void = { [self] newValue in
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

                    let didSet: (String ) -> Void = { [self] oldValue in
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
                    let willSet: (String ) -> Void = { [self] new in
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

                    let didSet: (String ) -> Void = { [self] old in
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
            var string = "text"
            """,
            expandedSource:
            """
            var string = "text"

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
