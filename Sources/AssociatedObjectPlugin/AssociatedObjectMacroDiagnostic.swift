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
    case getterAndSetterShouldBeNil
    case accessorParameterNameMustBeNewValue
    case requiresInitialValue
    case specifyTypeExplicitly
}

extension AssociatedObjectMacroDiagnostic: DiagnosticMessage {
    func diagnose(at node: some SyntaxProtocol) -> Diagnostic {
        Diagnostic(node: Syntax(node), message: self)
    }

    public var message: String {
        switch self {
        case .requiresVariableDeclaration:
            return "`@AssociatedObject` must be attached to the property declaration."
        case .getterAndSetterShouldBeNil:
            return "getter and setter must not be implemented when using `@AssociatedObject`."
        case .accessorParameterNameMustBeNewValue:
            return "accessor parameter name must be `newValue` when using `@AssociatedObject`."
        case .requiresInitialValue:
            return "Initial values must be specified when using `@AssociatedObject`."
        case .specifyTypeExplicitly:
            return "Specify a type explicitly when using `@AssociatedObject`."
        }
    }

    public var severity: DiagnosticSeverity { .error }

    public var diagnosticID: MessageID {
        MessageID(domain: "Swift", id: "AssociatedObject.\(self)")
    }
}
