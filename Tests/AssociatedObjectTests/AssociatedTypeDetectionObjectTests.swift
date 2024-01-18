//
//  AssociatedTypeDetectionObjectTests.swift
//
//
//  Created by p-x9 on 2024/01/18.
//  
//

import XCTest
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
@testable import AssociatedObjectPlugin
@testable import AssociatedObject

// MARK: - TypeDetection
// thanks: https://github.com/mlch911
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
                    ) as? Swift.Int
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
                    ) as? Swift.Double
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
                    ) as? Swift.String
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
                    ) as? Swift.Bool
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
                    ) as? [Swift.Int]
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
                    ) as? [Swift.Double]
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

    func testTypeDetectionIntAndDoubleArray() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var doubleArray = [1, 1.0, 2, 2.0, 3, 3.0]
            """,
            expandedSource:
            """
            var doubleArray = [1, 1.0, 2, 2.0, 3, 3.0] {
                get {
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_doubleArrayKey
                    ) as? [Swift.Double]
                    ?? [1, 1.0, 2, 2.0, 3, 3.0]
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
                    ) as? [Swift.Bool]
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
                    ) as? [Swift.String]
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
            var optionalIntArray = [1, 1, nil, 2, 3, nil]
            """,
            expandedSource:
            """
            var optionalIntArray = [1, 1, nil, 2, 3, nil] {
                get {
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_optionalIntArrayKey
                    ) as? [Swift.Int?]
                    ?? [1, 1, nil, 2, 3, nil]
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
                    ) as? [Swift.Double?]
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

    func testTypeDetectionOptionalIntAndDoubleArray() throws {
        assertMacroExpansion(
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var doubleArray = [nil, 1, 1.0, nil, 2, 2.0, nil, 3, 3.0]
            """,
            expandedSource:
            """
            var doubleArray = [nil, 1, 1.0, nil, 2, 2.0, nil, 3, 3.0] {
                get {
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_doubleArrayKey
                    ) as? [Swift.Double?]
                    ?? [nil, 1, 1.0, nil, 2, 2.0, nil, 3, 3.0]
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
                    ) as? [Swift.Bool?]
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
            var optionalStringArray = [nil, "true", "false", nil]
            """,
            expandedSource:
            """
            var optionalStringArray = [nil, "true", "false", nil] {
                get {
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_optionalStringArrayKey
                    ) as? [Swift.String?]
                    ?? [nil, "true", "false", nil]
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
                    ) as? [Swift.String: Swift.String]
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
                    ) as? [Swift.Int: Swift.Int]
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
                    ) as? [Swift.Double: Swift.Double]
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
