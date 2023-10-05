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
            bindingSpecifier: .identifier("static var"),
            bindings: PatternBindingListSyntax {
                PatternBindingSyntax(
                    pattern: IdentifierPatternSyntax(identifier: .identifier("__associated_\(identifier)Key")),
                    typeAnnotation: .init(type: IdentifierTypeSyntax(name: .identifier("UInt8"))),
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

        if varDecl.bindings.count > 1 {
            context.diagnose(AssociatedObjectMacroDiagnostic.multipleVariableDeclarationIsNotSupported.diagnose(at: binding))
            return []
        }

        //  Explicit specification of type is required
        guard let type = binding.typeAnnotation?.type else {
            context.diagnose(AssociatedObjectMacroDiagnostic.specifyTypeExplicitly.diagnose(at: identifier))
            return []
        }

        // Error if setter already exists
        if let setter = binding.setter {
            context.diagnose(AssociatedObjectMacroDiagnostic.getterAndSetterShouldBeNil.diagnose(at: setter))
            return []
        }

        // Error if getter already exists
        if let getter = binding.getter {
            context.diagnose(AssociatedObjectMacroDiagnostic.getterAndSetterShouldBeNil.diagnose(at: getter))
            return []
        }

        let defaultValue = binding.initializer?.value
        // Initial value required if type is optional
        if defaultValue == nil && !type.isOptional {
            context.diagnose(AssociatedObjectMacroDiagnostic.requiresInitialValue.diagnose(at: declaration))
            return []
        }

        guard case let .argumentList(arguments) = node.arguments,
              let firstElement = arguments.first?.expression,
              let policy = firstElement.as(MemberAccessExprSyntax.self) else {
            return []
        }

        return [
            Self.getter(
                identifier: identifier,
                type: type,
                defaultValue: defaultValue
            ),

            Self.setter(
                identifier: identifier,
                type: type,
                policy: policy,
                willSet: binding.willSet,
                didSet: binding.didSet
            )
        ]
    }
}

extension AssociatedObjectMacro {
    static func getter(
        identifier: TokenSyntax,
        type: TypeSyntax,
        defaultValue: ExprSyntax?
    ) -> AccessorDeclSyntax {
        AccessorDeclSyntax(
            accessorSpecifier: .keyword(.get),
            body: CodeBlockSyntax {
                    """
                    objc_getAssociatedObject(
                        self,
                        &Self.__associated_\(identifier)Key
                    ) as? \(type)
                    ?? \(defaultValue ?? "nil")
                    """
            }
        )
    }
}

extension AssociatedObjectMacro {
    static func setter(
        identifier: TokenSyntax,
        type: TypeSyntax,
        policy: MemberAccessExprSyntax,
        `willSet`: AccessorDeclSyntax?,
        `didSet`: AccessorDeclSyntax?
    ) -> AccessorDeclSyntax {
        AccessorDeclSyntax(
            accessorSpecifier: .keyword(.set),
            body: CodeBlockSyntax {
                if let willSet = `willSet`,
                   let body = willSet.body {
                    let newValue = willSet.parameters?.name.trimmed ?? .identifier("newValue")
                    Self.willSet(
                        accessor: willSet,
                        type: type,
                        body: body
                    )

                    Self.callWillSet()
                        .with(\.trailingTrivia, .newlines(2))
                }

                if `didSet` != nil {
                    "let oldValue = \(identifier)"
                }

                """
                objc_setAssociatedObject(
                    self,
                    &Self.__associated_\(identifier)Key,
                    newValue,
                    \(policy)
                )
                """

                if let didSet = `didSet`,
                   let body = didSet.body {
                    let oldValue = didSet.parameters?.name.trimmed ?? .identifier("oldValue")

                    Self.didSet(
                        accessor: didSet,
                        type: type,
                        body: body
                    ).with(\.leadingTrivia, .newlines(2))

                    Self.callDidSet()
                }
            }
        )
    }

    static func `willSet`(
        accessor: AccessorDeclSyntax,
        type: TypeSyntax,
        body: CodeBlockSyntax
    ) -> VariableDeclSyntax {
        VariableDeclSyntax(
            bindingSpecifier: .keyword(.let),
            bindings: .init() {
                .init(
                    pattern: IdentifierPatternSyntax(identifier: .identifier("willSet")),
                    typeAnnotation: .init(
                        type: FunctionTypeSyntax(
                            parameters: .init() {
                                TupleTypeElementSyntax(
                                    type: type
                                )
                            },
                            returnClause: ReturnClauseSyntax(
                                type: IdentifierTypeSyntax(name: .identifier("Void"))
                            )
                        )
                    ),
                    initializer: .init(
                        value: ClosureExprSyntax(
                            signature: .init(
                                capture: .init() {
                                    ClosureCaptureSyntax(
                                        expression: DeclReferenceExprSyntax(
                                            baseName: .keyword(.`self`)
                                        )
                                    )
                                },
                                parameterClause: .init(ClosureShorthandParameterListSyntax() {
                                    ClosureShorthandParameterSyntax(name: .identifier("newValue"))
                                })
                            ),
                            statements: .init(body.statements.map(\.trimmed))
                        )
                    )
                )
            }
        )
    }

    static func `didSet`(
        accessor: AccessorDeclSyntax,
        type: TypeSyntax,
        body: CodeBlockSyntax
    ) -> VariableDeclSyntax {
        VariableDeclSyntax(
            bindingSpecifier: .keyword(.let),
            bindings: .init() {
                .init(
                    pattern: IdentifierPatternSyntax(identifier: .identifier("didSet")),
                    typeAnnotation: .init(
                        type: FunctionTypeSyntax(
                            parameters: .init() {
                                TupleTypeElementSyntax(
                                    type: type
                                )
                            },
                            returnClause: ReturnClauseSyntax(
                                type: IdentifierTypeSyntax(name: .identifier("Void"))
                            )
                        )
                    ),
                    initializer: .init(
                        value: ClosureExprSyntax(
                            signature: .init(
                                capture: .init() {
                                    ClosureCaptureSyntax(
                                        expression: DeclReferenceExprSyntax(
                                            baseName: .keyword(.`self`)
                                        )
                                    )
                                },
                                parameterClause: .init(ClosureShorthandParameterListSyntax() {
                                    ClosureShorthandParameterSyntax(name: .identifier("oldValue"))
                                })
                            ),
                            statements: .init(body.statements.map(\.trimmed))
                        )
                    )
                )
            }
        )
    }

    static func callWillSet() -> FunctionCallExprSyntax {
        FunctionCallExprSyntax(
            callee: DeclReferenceExprSyntax(baseName: .identifier("willSet")),
            argumentList: {
                .init(
                    expression: DeclReferenceExprSyntax(
                        baseName: .identifier("newValue")
                    )
                )
            }
        )
    }

    static func callDidSet() -> FunctionCallExprSyntax {
        FunctionCallExprSyntax(
            callee: DeclReferenceExprSyntax(baseName: .identifier("didSet")),
            argumentList: {
                .init(
                    expression: DeclReferenceExprSyntax(
                        baseName: .identifier("oldValue")
                    )
                )
            }
        )
    }
}
