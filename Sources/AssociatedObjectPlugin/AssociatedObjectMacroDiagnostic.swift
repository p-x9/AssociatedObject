//
//  AssociatedObjectMacroDiagnostic.swift
//
//
//  Created by p-x9 on 2023/06/12.
//  
//

import SwiftSyntax
import SwiftDiagnostics

public enum AssociatedObjectMacroDiagnostic {
    case requiresVariableDeclaration
    case multipleVariableDeclarationIsNotSupported
    case getterAndSetterShouldBeNil
    case requiresInitialValue
    case specifyTypeExplicitly
    case invalidCustomKeySpecification
}

extension AssociatedObjectMacroDiagnostic: DiagnosticMessage {
    func diagnose(at node: some SyntaxProtocol) -> Diagnostic {
        Diagnostic(node: Syntax(node), message: self)
    }

    public var message: String {
        switch self {
        case .requiresVariableDeclaration:
            return "`@AssociatedObject` must be attached to the property declaration."
        case .multipleVariableDeclarationIsNotSupported:
            return """
            Multiple variable declaration in one statement is not supported when using `@AssociatedObject`.
            """
        case .getterAndSetterShouldBeNil:
            return "getter and setter must not be implemented when using `@AssociatedObject`."
        case .requiresInitialValue:
            return "Initial values must be specified when using `@AssociatedObject`."
        case .specifyTypeExplicitly:
            return "Specify a type explicitly when using `@AssociatedObject`."
        case .invalidCustomKeySpecification:
            return "customKey specification is invalid."
        }
    }

    public var severity: DiagnosticSeverity { .error }

    public var diagnosticID: MessageID {
        MessageID(domain: "Swift", id: "AssociatedObject.\(self)")
    }
}
