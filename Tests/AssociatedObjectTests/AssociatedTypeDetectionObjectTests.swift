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
import MacroTesting
@testable import AssociatedObjectPlugin
@testable import AssociatedObject

// MARK: - TypeDetection
// thanks: https://github.com/mlch911
final class AssociatedTypeDetectionObjectTests: XCTestCase {
    override func invokeTest() {
        withMacroTesting(
//            isRecording: true,
            macros: ["AssociatedObject": AssociatedObjectMacro.self]
        ) {
            super.invokeTest()
        }
    }
}

// MARK: - Simple Types
extension AssociatedTypeDetectionObjectTests {
    func testTypeDetectionInt() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var int = 10
            """
        } expansion: {
            """
            var int = 10 {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        Self.__associated_intKey
                    ) as? Swift.Int {
                        return value
                    } else {
                        let value: Swift.Int = 10
                        objc_setAssociatedObject(
                            self,
                            Self.__associated_intKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        Self.__associated_intKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            @inline(never) static var __associated_intKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }

    func testTypeDetectionDouble() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var double = 10.0
            """
        } expansion: {
            """
            var double = 10.0 {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        Self.__associated_doubleKey
                    ) as? Swift.Double {
                        return value
                    } else {
                        let value: Swift.Double = 10.0
                        objc_setAssociatedObject(
                            self,
                            Self.__associated_doubleKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        Self.__associated_doubleKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            @inline(never) static var __associated_doubleKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }

    func testTypeDetectionString() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var string = "text"
            """
        } expansion: {
            """
            var string = "text" {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        Self.__associated_stringKey
                    ) as? Swift.String {
                        return value
                    } else {
                        let value: Swift.String = "text"
                        objc_setAssociatedObject(
                            self,
                            Self.__associated_stringKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        Self.__associated_stringKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            @inline(never) static var __associated_stringKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }

    func testTypeDetectionBool() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var bool = false
            """
        } expansion: {
            """
            var bool = false {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        Self.__associated_boolKey
                    ) as? Swift.Bool {
                        return value
                    } else {
                        let value: Swift.Bool = false
                        objc_setAssociatedObject(
                            self,
                            Self.__associated_boolKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        Self.__associated_boolKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            @inline(never) static var __associated_boolKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }
}

// MARK: - Array
extension AssociatedTypeDetectionObjectTests {
    func testTypeDetectionIntArray() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var intArray = [1, 2, 3]
            """
        } expansion: {
            """
            var intArray = [1, 2, 3] {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        Self.__associated_intArrayKey
                    ) as? [Swift.Int] {
                        return value
                    } else {
                        let value: [Swift.Int] = [1, 2, 3]
                        objc_setAssociatedObject(
                            self,
                            Self.__associated_intArrayKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        Self.__associated_intArrayKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            @inline(never) static var __associated_intArrayKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }

    func testTypeDetectionDoubleArray() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var doubleArray = [1.0, 2.0, 3.0]
            """
        } expansion: {
            """
            var doubleArray = [1.0, 2.0, 3.0] {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        Self.__associated_doubleArrayKey
                    ) as? [Swift.Double] {
                        return value
                    } else {
                        let value: [Swift.Double] = [1.0, 2.0, 3.0]
                        objc_setAssociatedObject(
                            self,
                            Self.__associated_doubleArrayKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        Self.__associated_doubleArrayKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            @inline(never) static var __associated_doubleArrayKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }

    func testTypeDetectionIntAndDoubleArray() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var doubleArray = [1, 1.0, 2, 2.0, 3, 3.0]
            """
        } expansion: {
            """
            var doubleArray = [1, 1.0, 2, 2.0, 3, 3.0] {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        Self.__associated_doubleArrayKey
                    ) as? [Swift.Double] {
                        return value
                    } else {
                        let value: [Swift.Double] = [1, 1.0, 2, 2.0, 3, 3.0]
                        objc_setAssociatedObject(
                            self,
                            Self.__associated_doubleArrayKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        Self.__associated_doubleArrayKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            @inline(never) static var __associated_doubleArrayKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }

    func testTypeDetectionBoolArray() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var boolArray = [true, false]
            """
        } expansion: {
            """
            var boolArray = [true, false] {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        Self.__associated_boolArrayKey
                    ) as? [Swift.Bool] {
                        return value
                    } else {
                        let value: [Swift.Bool] = [true, false]
                        objc_setAssociatedObject(
                            self,
                            Self.__associated_boolArrayKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        Self.__associated_boolArrayKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            @inline(never) static var __associated_boolArrayKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }

    func testTypeDetectionStringArray() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var stringArray = ["1.0", "2.0", "3.0"]
            """
        } expansion: {
            """
            var stringArray = ["1.0", "2.0", "3.0"] {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        Self.__associated_stringArrayKey
                    ) as? [Swift.String] {
                        return value
                    } else {
                        let value: [Swift.String] = ["1.0", "2.0", "3.0"]
                        objc_setAssociatedObject(
                            self,
                            Self.__associated_stringArrayKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        Self.__associated_stringArrayKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            @inline(never) static var __associated_stringArrayKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }
}

// MARK: - Array with optional Elements
extension AssociatedTypeDetectionObjectTests {
    func testTypeDetectionOptionalIntArray() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var optionalIntArray = [1, 1, nil, 2, 3, nil]
            """
        } expansion: {
            """
            var optionalIntArray = [1, 1, nil, 2, 3, nil] {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        Self.__associated_optionalIntArrayKey
                    ) as? [Swift.Int?] {
                        return value
                    } else {
                        let value: [Swift.Int?] = [1, 1, nil, 2, 3, nil]
                        objc_setAssociatedObject(
                            self,
                            Self.__associated_optionalIntArrayKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        Self.__associated_optionalIntArrayKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            @inline(never) static var __associated_optionalIntArrayKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }

    func testTypeDetectionOptionalDoubleArray() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var optionalDoubleArray = [1.0, 2.0, 3.0, nil]
            """
        } expansion: {
            """
            var optionalDoubleArray = [1.0, 2.0, 3.0, nil] {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        Self.__associated_optionalDoubleArrayKey
                    ) as? [Swift.Double?] {
                        return value
                    } else {
                        let value: [Swift.Double?] = [1.0, 2.0, 3.0, nil]
                        objc_setAssociatedObject(
                            self,
                            Self.__associated_optionalDoubleArrayKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        Self.__associated_optionalDoubleArrayKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            @inline(never) static var __associated_optionalDoubleArrayKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }

    func testTypeDetectionOptionalIntAndDoubleArray() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var doubleArray = [nil, 1, 1.0, nil, 2, 2.0, nil, 3, 3.0]
            """
        } expansion: {
            """
            var doubleArray = [nil, 1, 1.0, nil, 2, 2.0, nil, 3, 3.0] {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        Self.__associated_doubleArrayKey
                    ) as? [Swift.Double?] {
                        return value
                    } else {
                        let value: [Swift.Double?] = [nil, 1, 1.0, nil, 2, 2.0, nil, 3, 3.0]
                        objc_setAssociatedObject(
                            self,
                            Self.__associated_doubleArrayKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        Self.__associated_doubleArrayKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            @inline(never) static var __associated_doubleArrayKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }


    func testTypeDetectionOptionalBoolArray() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var optionalBoolArray = [true, false, nil]
            """
        } expansion: {
            """
            var optionalBoolArray = [true, false, nil] {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        Self.__associated_optionalBoolArrayKey
                    ) as? [Swift.Bool?] {
                        return value
                    } else {
                        let value: [Swift.Bool?] = [true, false, nil]
                        objc_setAssociatedObject(
                            self,
                            Self.__associated_optionalBoolArrayKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        Self.__associated_optionalBoolArrayKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            @inline(never) static var __associated_optionalBoolArrayKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }

    func testTypeDetectionOptionalStringArray() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var optionalStringArray = [nil, "true", "false", nil]
            """
        } expansion: {
            """
            var optionalStringArray = [nil, "true", "false", nil] {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        Self.__associated_optionalStringArrayKey
                    ) as? [Swift.String?] {
                        return value
                    } else {
                        let value: [Swift.String?] = [nil, "true", "false", nil]
                        objc_setAssociatedObject(
                            self,
                            Self.__associated_optionalStringArrayKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        Self.__associated_optionalStringArrayKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            @inline(never) static var __associated_optionalStringArrayKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }
}

// MARK: - Dictionary
extension AssociatedTypeDetectionObjectTests {
    func testTypeDetectionStringDictionary() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var dic = ["t": "a", "s": "b"]
            """
        } expansion: {
            """
            var dic = ["t": "a", "s": "b"] {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        Self.__associated_dicKey
                    ) as? [Swift.String: Swift.String] {
                        return value
                    } else {
                        let value: [Swift.String: Swift.String] = ["t": "a", "s": "b"]
                        objc_setAssociatedObject(
                            self,
                            Self.__associated_dicKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        Self.__associated_dicKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            @inline(never) static var __associated_dicKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }

    func testTypeDetectionIntDictionary() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var dic = [1: 3, 2: 4]
            """
        } expansion: {
            """
            var dic = [1: 3, 2: 4] {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        Self.__associated_dicKey
                    ) as? [Swift.Int: Swift.Int] {
                        return value
                    } else {
                        let value: [Swift.Int: Swift.Int] = [1: 3, 2: 4]
                        objc_setAssociatedObject(
                            self,
                            Self.__associated_dicKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        Self.__associated_dicKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            @inline(never) static var __associated_dicKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }

    func testTypeDetectionDoubleDictionary() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var dic = [1.0: 3.0, 2.0: 4.0]
            """
        } expansion: {
            """
            var dic = [1.0: 3.0, 2.0: 4.0] {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        Self.__associated_dicKey
                    ) as? [Swift.Double: Swift.Double] {
                        return value
                    } else {
                        let value: [Swift.Double: Swift.Double] = [1.0: 3.0, 2.0: 4.0]
                        objc_setAssociatedObject(
                            self,
                            Self.__associated_dicKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        Self.__associated_dicKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            @inline(never) static var __associated_dicKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }
}


// MARK: - Other
extension AssociatedTypeDetectionObjectTests {
    func testTypeDetection2DimensionDoubleArray() throws {
        assertMacro {
            """
            @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
            var array = [[1.0], [2.0], [3.0, 4.0]]
            """
        } expansion: {
            """
            var array = [[1.0], [2.0], [3.0, 4.0]] {
                get {
                    if let value = objc_getAssociatedObject(
                        self,
                        Self.__associated_arrayKey
                    ) as? [[Swift.Double]] {
                        return value
                    } else {
                        let value: [[Swift.Double]] = [[1.0], [2.0], [3.0, 4.0]]
                        objc_setAssociatedObject(
                            self,
                            Self.__associated_arrayKey,
                            value,
                            .OBJC_ASSOCIATION_ASSIGN
                        )
                        return value
                    }
                }
                set {
                    objc_setAssociatedObject(
                        self,
                        Self.__associated_arrayKey,
                        newValue,
                        .OBJC_ASSOCIATION_ASSIGN
                    )
                }
            }

            @inline(never) static var __associated_arrayKey: UnsafeRawPointer {
                _associated_object_key()
            }
            """
        }
    }
}
