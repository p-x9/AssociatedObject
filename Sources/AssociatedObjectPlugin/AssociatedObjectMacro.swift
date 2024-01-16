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
		let varType: TypeSyntax

        if let type = binding.typeAnnotation?.type {
            //  TypeAnnotation
            varType = type
        } else if let type = typeDetection(defaultValue) {
            //  TypeDetection
            varType = type
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
        if defaultValue == nil && !varType.isOptional {
            context.diagnose(AssociatedObjectMacroDiagnostic.requiresInitialValue.diagnose(at: declaration))
            return []
        }

        guard case let .argumentList(arguments) = node.arguments,
              let firstElement = arguments.first?.expression,
              let policy = firstElement.as(ExprSyntax.self) else {
            return []
        }

        return [
            Self.getter(
                identifier: identifier,
                type: varType,
                defaultValue: defaultValue
            ),

            Self.setter(
                identifier: identifier,
                type: varType,
                policy: policy,
                willSet: binding.willSet,
                didSet: binding.didSet
            )
        ]
    }
    
    private static func typeDetection(_ value: ExprSyntax?) -> TypeSyntax? {
        guard let value else { return nil }
        switch value.kind {
        case .stringLiteralExpr:
            return .init(IdentifierTypeSyntax(name: .identifier("String")))
        case .integerLiteralExpr:
            return .init(IdentifierTypeSyntax(name: .identifier("Int")))
        case .floatLiteralExpr:
            return .init(IdentifierTypeSyntax(name: .identifier("Double")))
        case .booleanLiteralExpr:
            return .init(IdentifierTypeSyntax(name: .identifier("Bool")))
        case .arrayExpr:
            guard let arr = ArrayExprSyntax(value) else { return nil }
            let itemTypes = arr.elements
                .map(\.expression)
                .map(typeDetection(_:))
            guard let itemType = arrayTypeDetection(itemTypes) else { return nil }
            return .init(ArrayTypeSyntax(element: itemType))
        case .dictionaryExpr:
            guard let dic = DictionaryExprSyntax(value), case let .elements(list) = dic.content else { return nil }
            let keyTypes = list
                .map(\.key)
                .map(typeDetection(_:))
            let valueTypes = list
                .map(\.value)
                .map(typeDetection(_:))
            guard let keyType = arrayTypeDetection(keyTypes), let valueType = arrayTypeDetection(valueTypes) else { return nil }
            return .init(DictionaryTypeSyntax(key: keyType, value: valueType))
        default:
            return nil
        }
    }
    
    private static func arrayTypeDetection(_ types: [TypeSyntax?]) -> TypeSyntaxProtocol? {
        let identifiers = types.map { IdentifierTypeSyntax($0)?.name.text }.removeDuplicate()
        if identifiers.count == 1, let type = types.first as? TypeSyntax {
            return type
        } else if identifiers.filter({ $0 != nil }).count == 1, let type = types.first(where: { !($0?.isOptional ?? true) }) as? TypeSyntax {
            return OptionalTypeSyntax(wrappedType: type)
        } else {
            return nil
        }
    }
}

private extension Array where Element: Equatable {
    func removeDuplicate() -> Array {
        return enumerated().filter { index, value -> Bool in
            firstIndex(where: { $0 == value }) == index
        }.map { $0.element }
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
        defaultValue: ExprSyntax?
    ) -> AccessorDeclSyntax {
        AccessorDeclSyntax(
            accessorSpecifier: .keyword(.get),
            body: CodeBlockSyntax {
                """
                objc_getAssociatedObject(
                    self,
                    &Self.__associated_\(identifier.trimmed)Key
                ) as? \(type)
                ?? \(defaultValue ?? "nil")
                """
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
                    &Self.__associated_\(identifier.trimmed)Key,
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
