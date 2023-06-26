//
//  AssociatedObjectMacro.swift
//
//
//  Created by p-x9 on 2023/06/12.
//
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct AssociatedObjectMacro {}

extension AssociatedObjectMacro: PeerMacro {
    public static func expansion<Context: MacroExpansionContext, Declaration: DeclSyntaxProtocol>(
        of node: AttributeSyntax,
        providingPeersOf declaration: Declaration,
        in context: Context
    ) throws -> [DeclSyntax] {

        guard let varDecl = declaration.as(VariableDeclSyntax.self),
              let binding = varDecl.bindings.first,
              let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier else {
            context.diagnose(AssociatedObjectMacroDiagnostic.requiresVariableDeclaration.diagnose(at: declaration))
            return []
        }

        let keyDecl = VariableDeclSyntax(
            bindingKeyword: .identifier("static var"),
            bindings: PatternBindingListSyntax {
                PatternBindingSyntax(
                    pattern: IdentifierPatternSyntax(identifier: .identifier("__associated_\(identifier)Key")),
                    typeAnnotation: .init(type: SimpleTypeIdentifierSyntax(name: .identifier("UInt8"))),
                    initializer: InitializerClauseSyntax(value: ExprSyntax(stringLiteral: "0"))
                )
            }
        )

        return [
            DeclSyntax(keyDecl)
        ]
    }
}

extension AssociatedObjectMacro: AccessorMacro {
    public static func expansion<Context: MacroExpansionContext, Declaration: DeclSyntaxProtocol>(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: Declaration,
        in context: Context
    ) throws -> [AccessorDeclSyntax] {

        guard let varDecl = declaration.as(VariableDeclSyntax.self),
              let binding = varDecl.bindings.first,
              let identifier = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier
        else {
            // Probably can't add a diagnose here, since this is an Accessor macro
            context.diagnose(AssociatedObjectMacroDiagnostic.requiresVariableDeclaration.diagnose(at: declaration))
            return []
        }

        //  Explicit specification of type is required
        guard let type = binding.typeAnnotation?.type else {
            context.diagnose(AssociatedObjectMacroDiagnostic.specifyTypeExplicitly.diagnose(at: identifier))
            return []
        }

        // Error if accessor already exists
        if let accessor = binding.accessor {
            context.diagnose(AssociatedObjectMacroDiagnostic.accessorShouldBeNil.diagnose(at: accessor))
            return []
        }

        // Initial value required
        guard let defaultValue = binding.initializer?.value else {
            context.diagnose(AssociatedObjectMacroDiagnostic.requiresInitialValue.diagnose(at: declaration))
            return []
        }

        guard case let .argumentList(arguments) = node.argument,
              let firstElement = arguments.first?.expression,
              let policy = firstElement.as(MemberAccessExprSyntax.self) else {
            return []
        }

        return [
            """
            get {
                objc_getAssociatedObject(
                    self,
                    &Self.__associated_\(identifier)Key
                ) as? \(type)
                ?? \(defaultValue)
            }
            """,

            """

            set {
                objc_setAssociatedObject(
                    self,
                    &Self.__associated_\(identifier)Key,
                    newValue,
                    \(policy)
                )
            }
            """
        ]
    }
}
