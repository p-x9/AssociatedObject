//
//  AssociatedObjectMacrosPlugin.swift
//
//
//  Created by p-x9 on 2023/06/12.
//  
//

#if canImport(SwiftCompilerPlugin)
import SwiftSyntaxMacros
import SwiftCompilerPlugin

@main
struct AssociatedObjectMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        AssociatedObjectMacro.self
    ]
}
#endif
