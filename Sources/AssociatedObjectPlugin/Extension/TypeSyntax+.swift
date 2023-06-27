//
//  TypeSyntax+.swift
//
//
//  Created by p-x9 on 2023/06/27.
//  
//

import SwiftSyntax
import SwiftSyntaxBuilder

extension TypeSyntax {
    var isOptional: Bool {
        if let optionalType = self.as(OptionalTypeSyntax.self) {
            return true
        }
        if let simpleType = self.as(SimpleTypeIdentifierSyntax.self),
           simpleType.name.trimmed.text == "Optional" {
            return true
        }
        return false
    }
}
