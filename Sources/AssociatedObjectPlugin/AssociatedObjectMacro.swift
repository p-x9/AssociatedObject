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
        
        if case let .argumentList(arguments) = node.arguments,
           let element = arguments.first(where: { $0.label?.text == "key" }),
           element.expression.is(DeclReferenceExprSyntax.self) {
            // Provide store key from outside the macro
            return []
        }

        let keyDecl = VariableDeclSyntax(
            bindingSpecifier: .identifier("static var"),
            bindings: PatternBindingListSyntax {
                PatternBindingSyntax(
                    pattern: IdentifierPatternSyntax(identifier: .identifier("__associated_\(identifier.trimmed)Key")),
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

        let defaultValue = binding.initializer?.value
        let type: TypeSyntax

        if let specifiedType = binding.typeAnnotation?.type {
            //  TypeAnnotation
            type = specifiedType
        } else if let detectedType = defaultValue?.detectedTypeByLiteral {
            //  TypeDetection
            type = detectedType
        } else {
            //  Explicit specification of type is required
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

        // Initial value required if type is optional
        if defaultValue == nil && !type.isOptional {
            context.diagnose(AssociatedObjectMacroDiagnostic.requiresInitialValue.diagnose(at: declaration))
            return []
        }

        guard case let .argumentList(arguments) = node.arguments,
              let firstElement = arguments.first?.expression,
              let policy = firstElement.as(ExprSyntax.self) else {
            return []
        }
        
        var associatedKey = "&Self.__associated_\(identifier.trimmed)Key"
        if case let .argumentList(arguments) = node.arguments,
           let element = arguments.first(where: { $0.label?.text == "key" }),
           let s = element.expression.as(DeclReferenceExprSyntax.self) {
            // Provide store key from outside the macro
            associatedKey = "&\(s.trimmedDescription)"
        }

        return [
            Self.getter(
                identifier: identifier,
                type: type,
                associatedKey: associatedKey,
                policy: policy,
                defaultValue: defaultValue
            ),

            Self.setter(
                identifier: identifier,
                type: type,
                policy: policy,
                associatedKey: associatedKey,
                willSet: binding.willSet,
                didSet: binding.didSet
            )
        ]
    }
}

extension AssociatedObjectMacro {
    /// Create the syntax for the `get` accessor after expansion.
    /// - Parameters:
    ///   - identifier: Type of Associated object.
    ///   - type: Type of Associated object.
    ///   - defaultValue: Syntax of default value
    /// - Returns: Syntax of `get` accessor after expansion.
    static func getter(
        identifier: TokenSyntax,
        type: TypeSyntax,
        associatedKey: String,
        policy: ExprSyntax,
        defaultValue: ExprSyntax?
    ) -> AccessorDeclSyntax {
        AccessorDeclSyntax(
            accessorSpecifier: .keyword(.get),
            body: CodeBlockSyntax {
                if let defaultValue {
                    """
                    if let value = objc_getAssociatedObject(
                        self,
                        \(raw: associatedKey)
                    ) as? \(type.trimmed) {
                        return value
                    }
                        let value: \(type.trimmed) = \(defaultValue.trimmed)
                        objc_setAssociatedObject(
                            self,
                            \(raw: associatedKey),
                            value,
                            \(policy.trimmed)
                        )
                        return value
                    """
                } else {
                    """
                    if let value = objc_getAssociatedObject(
                        self,
                        \(raw: associatedKey)
                    ) as? \(type.trimmed) {
                        return value
                    }
                        return nil
                    """
                }
            }
        )
    }
}

extension AssociatedObjectMacro {
    /// Create the syntax for the `set` accessor after expansion.
    /// - Parameters:
    ///   - identifier: Name of associated object.
    ///   - type: Type of Associated object.
    ///   - policy: Syntax of `objc_AssociationPolicy`
    ///   - `willSet`: `willSet` accessor of the original variable definition.
    ///   - `didSet`: `didSet` accessor of the original variable definition.
    /// - Returns: Syntax of `set` accessor after expansion.
    static func setter(
        identifier: TokenSyntax,
        type: TypeSyntax,
        policy: ExprSyntax,
        associatedKey: String,
        `willSet`: AccessorDeclSyntax?,
        `didSet`: AccessorDeclSyntax?
    ) -> AccessorDeclSyntax {
        AccessorDeclSyntax(
            accessorSpecifier: .keyword(.set),
            body: CodeBlockSyntax {
                if let willSet = `willSet`,
                   let body = willSet.body {
                    Self.willSet(
                        type: type,
                        accessor: willSet,
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
                    \(raw: associatedKey),
                    newValue,
                    \(policy)
                )
                """

                if let didSet = `didSet`,
                   let body = didSet.body {
                    Self.didSet(
                        type: type,
                        accessor: didSet,
                        body: body
                    ).with(\.leadingTrivia, .newlines(2))

                    Self.callDidSet()
                }
            }
        )
    }

    /// `willSet` closure
    ///
    /// Convert a willSet accessor to a closure variable in the following format.
    /// ```swift
    /// let `willSet`: (\(type.trimmed)) -> Void = { [self] \(newValue) in
    ///     \(body.statements.trimmed)
    /// }
    /// ```
    /// - Parameters:
    ///   - type: Type of Associated object.
    ///   - body: Contents of willSet
    /// - Returns: Variable that converts the contents of willSet to a closure
    static func `willSet`(
        type: TypeSyntax,
        accessor: AccessorDeclSyntax,
        body: CodeBlockSyntax
    ) -> VariableDeclSyntax {
        let newValue = accessor.parameters?.name.trimmed ?? .identifier("newValue")

        return VariableDeclSyntax(
            bindingSpecifier: .keyword(.let),
            bindings: .init() {
                .init(
                    pattern: IdentifierPatternSyntax(identifier: .identifier("willSet")),
                    typeAnnotation: .init(
                        type: FunctionTypeSyntax(
                            parameters: .init() {
                                TupleTypeElementSyntax(
                                    type: type.trimmed
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
                                    ClosureShorthandParameterSyntax(name: newValue)
                                })
                            ),
                            statements: .init(body.statements.map(\.trimmed))
                        )
                    )
                )
            }
        )
    }

    /// `didSet` closure
    ///
    /// Convert a didSet accessor to a closure variable in the following format.
    /// ```swift
    /// let `didSet`: (\(type.trimmed)) -> Void = { [self] \(oldValue) in
    ///     \(body.statements.trimmed)
    /// }
    /// ```
    /// - Parameters:
    ///   - type: Type of Associated object.
    ///   - body: Contents of didSet
    /// - Returns: Variable that converts the contents of didSet to a closure
    static func `didSet`(
        type: TypeSyntax,
        accessor: AccessorDeclSyntax,
        body: CodeBlockSyntax
    ) -> VariableDeclSyntax {
        let oldValue = accessor.parameters?.name.trimmed ?? .identifier("oldValue")

        return VariableDeclSyntax(
            bindingSpecifier: .keyword(.let),
            bindings: .init() {
                .init(
                    pattern: IdentifierPatternSyntax(identifier: .identifier("didSet")),
                    typeAnnotation: .init(
                        type: FunctionTypeSyntax(
                            parameters: .init() {
                                TupleTypeElementSyntax(
                                    type: type.trimmed
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
                                    ClosureShorthandParameterSyntax(name: oldValue)
                                })
                            ),
                            statements: .init(body.statements.map(\.trimmed))
                        )
                    )
                )
            }
        )
    }

    /// Execute willSet closure
    ///
    /// ```swift
    /// willSet(newValue)
    /// ```
    /// - Returns: Syntax for executing willSet closure
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

    /// Execute didSet closure
    ///
    /// ```swift
    /// didSet(oldValue)
    /// ```
    /// - Returns: Syntax for executing didSet closure
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
