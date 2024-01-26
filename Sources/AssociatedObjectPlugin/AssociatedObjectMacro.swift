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
           let element = arguments.first(where: { $0.label?.text == "key" }) {
            let kind = element.expression.kind
            if ![.declReferenceExpr, .memberAccessExpr].contains(kind) {
                context.diagnose(
                    AssociatedObjectMacroDiagnostic
                        .invalidCustomKeySpecification
                        .diagnose(at: element)
                )
            }
            // Provide store key from outside the macro
            return []
        }

        let defaultValue = binding.initializer?.value
        let type: TypeSyntax? = binding.typeAnnotation?.type ?? defaultValue?.detectedTypeByLiteral

        guard let type else {
            //  Explicit specification of type is required
            context.diagnose(AssociatedObjectMacroDiagnostic.specifyTypeExplicitly.diagnose(at: identifier))
            return []
        }

        let keyAccessor = """
        _associated_object_key()
        """

        let keyDecl = VariableDeclSyntax(
            attributes: [
                .attribute("@inline(never)")
            ],
            bindingSpecifier: .identifier("static var"),
            bindings: PatternBindingListSyntax {
                PatternBindingSyntax(
                    pattern: IdentifierPatternSyntax(identifier: .identifier("__associated_\(identifier.trimmed)Key")),
                    typeAnnotation: .init(type: IdentifierTypeSyntax(name: .identifier("UnsafeRawPointer"))),
                    accessorBlock: .init(
                        accessors: .getter("\(raw: keyAccessor)")
                    )
                )
            }
        )

        var decls = [
            DeclSyntax(keyDecl)
        ]

        if type.isOptional && defaultValue != nil {
            let flagName = "__associated_\(identifier.trimmed)IsSet"
            let flagDecl = VariableDeclSyntax(
                attributes: [
                    .attribute("@_AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)")
                ],
                bindingSpecifier: .identifier("var"),
                bindings: PatternBindingListSyntax {
                    PatternBindingSyntax(
                        pattern: IdentifierPatternSyntax(
                            identifier: .identifier(flagName)
                        ),
                        typeAnnotation: .init(type: IdentifierTypeSyntax(name: .identifier("Bool"))),
                        initializer: InitializerClauseSyntax(value: BooleanLiteralExprSyntax(false))
                    )
                }
            )

            // nested peer macro will not expand
            // https://github.com/apple/swift/issues/69073
            let keyAccessor = """
            _associated_object_key()
            """
            let flagKeyDecl = VariableDeclSyntax(
                attributes: [
                    .attribute("@inline(never)")
                ],
                bindingSpecifier: .identifier("static var"),
                bindings: PatternBindingListSyntax {
                    PatternBindingSyntax(
                        pattern: IdentifierPatternSyntax(
                            identifier: .identifier("__associated___associated_\(identifier.trimmed)IsSetKey")
                        ),
                        typeAnnotation: .init(type: IdentifierTypeSyntax(name: .identifier("UnsafeRawPointer"))),
                        accessorBlock: .init(
                            accessors: .getter("\(raw: keyAccessor)")
                        )
                    )
                }
            )
            decls.append(DeclSyntax(flagDecl))
            decls.append(DeclSyntax(flagKeyDecl))
        }

        return decls
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

        var associatedKey: ExprSyntax = "Self.__associated_\(identifier.trimmed)Key"
        if case let .argumentList(arguments) = node.arguments,
           let element = arguments.first(where: { $0.label?.text == "key" }),
           let customKey = element.expression.as(ExprSyntax.self) {
            // Provide store key from outside the macro
            associatedKey = "&\(customKey)"
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
        associatedKey: ExprSyntax,
        policy: ExprSyntax,
        defaultValue: ExprSyntax?
    ) -> AccessorDeclSyntax {
        let varTypeWithoutOptional = if let type = type.as(ImplicitlyUnwrappedOptionalTypeSyntax.self) {
            type.wrappedType
        } else {
            type
        }

        return AccessorDeclSyntax(
            accessorSpecifier: .keyword(.get),
            body: CodeBlockSyntax {
                if let defaultValue {
                    if type.isOptional {
                        """
                        if !self.__associated_\(identifier.trimmed)IsSet {
                            let value: \(type.trimmed) = \(defaultValue.trimmed)
                            objc_setAssociatedObject(
                                self,
                                \(associatedKey),
                                value,
                                \(policy.trimmed)
                            )
                            self.__associated_\(identifier.trimmed)IsSet = true
                            return value
                        } else {
                            return objc_getAssociatedObject(
                                self,
                                \(associatedKey)
                            ) as! \(varTypeWithoutOptional.trimmed)
                        }
                        """
                    } else {
                        """
                        if let value = objc_getAssociatedObject(
                            self,
                            \(associatedKey)
                        ) as? \(varTypeWithoutOptional.trimmed) {
                            return value
                        } else {
                            let value: \(type.trimmed) = \(defaultValue.trimmed)
                            objc_setAssociatedObject(
                                self,
                                \(associatedKey),
                                value,
                                \(policy.trimmed)
                            )
                            return value
                        }
                        """
                    }
                } else {
                    """
                    objc_getAssociatedObject(
                        self,
                        \(associatedKey)
                    ) as? \(varTypeWithoutOptional.trimmed)
                    ?? \(defaultValue ?? "nil")
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
        associatedKey: ExprSyntax,
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
                    \(associatedKey),
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
