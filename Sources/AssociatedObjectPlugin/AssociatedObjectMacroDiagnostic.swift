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
    case accessorShouldBeNil
    case requiresInitialValue
}

extension AssociatedObjectMacroDiagnostic: DiagnosticMessage {
    func diagnose(at node: some SyntaxProtocol) -> Diagnostic {
        Diagnostic(node: Syntax(node), message: self)
    }

    public var message: String {
        switch self {
        case .requiresVariableDeclaration:
            return "`@AssociatedObject` must be appended to the property declaration."
        case .accessorShouldBeNil:
            return "`accessor should not be specified."
        case .requiresInitialValue:
            return "Initial values must be specified."
        }
    }

    public var severity: DiagnosticSeverity { .error }

    public var diagnosticID: MessageID {
        MessageID(domain: "Swift", id: "AssociatedObject.\(self)")
    }
}
