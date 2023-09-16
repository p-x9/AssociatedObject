//
//  PatternBindingSyntax+Tests.swift
//
//
//  Created by p-x9 on 2023/06/25.
//
//

import XCTest
import SwiftSyntax
import SwiftSyntaxBuilder
@testable import AssociatedObjectPlugin

final class PatternBindingSyntaxTests: XCTestCase {

    func testSetter() {
        let setter = AccessorDeclSyntax(accessorSpecifier: .keyword(.set), body: .init(statements: CodeBlockItemListSyntax {}))

        let binding: PatternBindingSyntax = .init(
            pattern: IdentifierPatternSyntax(identifier: .identifier("value")),
            accessorBlock: .init(
                accessors: .accessors(.init {
                    setter
                })
            )
        )

        XCTAssertEqual(setter.description, binding.setter?.description)
    }

    func testGetter() {
        let getter = AccessorDeclSyntax(accessorSpecifier: .keyword(.get), body: .init(statements: CodeBlockItemListSyntax {}))

        var binding: PatternBindingSyntax = .init(
            pattern: IdentifierPatternSyntax(identifier: .identifier("value")),
            accessorBlock: .init(
                accessors: .accessors(.init {
                    getter
                })
            )
        )

        XCTAssertEqual(getter.description, binding.getter?.description)

        /* getter only */
        guard let body = getter.body else {
            XCTFail("body must not be nil")
            return
        }
        binding = .init(
            pattern: IdentifierPatternSyntax(identifier: .identifier("value")),
            accessorBlock: .init(
                accessors: .getter(body.statements)
            )
        )

        XCTAssertEqual(getter.description, binding.getter?.description)
    }

    func testSetSetter() {
        let setter = AccessorDeclSyntax(accessorSpecifier: .keyword(.set), body: .init(statements: CodeBlockItemListSyntax {}))
        var binding: PatternBindingSyntax = .init(
            pattern: IdentifierPatternSyntax(identifier: .identifier("value")),
            accessorBlock: .init(
                accessors: .accessors(.init {
                    setter
                })
            )
        )
        let newSetter = AccessorDeclSyntax(
            accessorSpecifier: .keyword(.set),
            body: .init(statements: CodeBlockItemListSyntax {
                .init(item: .expr("print(\"hello\")"))
            })
        )

        binding.setter = newSetter
        XCTAssertEqual(newSetter.description, binding.setter?.description)


        /* getter only */
        binding = .init(
            pattern: IdentifierPatternSyntax(identifier: .identifier("value")),
            accessorBlock: .init(
                accessors: .getter(.init {
                    DeclSyntax("\"hello\"")
                })
            )
        )

        binding.setter = newSetter
        XCTAssertEqual(newSetter.description, binding.setter?.description)
    }

    func testSetGetter() {
        let getter = AccessorDeclSyntax(accessorSpecifier: .keyword(.get), body: .init(statements: CodeBlockItemListSyntax {}))
        var binding: PatternBindingSyntax = .init(
            pattern: IdentifierPatternSyntax(identifier: .identifier("value")),
            accessorBlock: .init(
                accessors: .accessors(.init {
                    getter
                })
            )
        )

        let newGetter = AccessorDeclSyntax(
            accessorSpecifier: .keyword(.get),
            body: .init(statements: CodeBlockItemListSyntax {
                .init(item: .decl("\"hello\""))
            })
        )

        binding.getter = newGetter
        print(binding.description)
        XCTAssertEqual(newGetter.description, binding.getter?.description)

        /* getter only */
        binding = .init(
            pattern: IdentifierPatternSyntax(identifier: .identifier("value")),
            accessorBlock: .init(
                accessors: .getter(.init {
                    DeclSyntax("\"hello\"")
                })
            )
        )

        binding.getter = newGetter
        XCTAssertEqual(newGetter.description, binding.getter?.description)

        /* setter only */
        binding = .init(
            pattern: IdentifierPatternSyntax(identifier: .identifier("value")),
            accessorBlock: .init(
                accessors: .accessors(.init {
                    AccessorDeclSyntax(accessorSpecifier: .keyword(.set), body: .init(statements: CodeBlockItemListSyntax {}))
                })
            )
        )

        binding.getter = newGetter
        XCTAssertEqual(newGetter.description, binding.getter?.description)
    }
}
