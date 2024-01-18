//
//  ExprSyntax+.swift
//
//
//  Created by p-x9 on 2024/01/18.
//  
//

import SwiftSyntax

extension ExprSyntax {
    var detectedTypeByLiteral: TypeSyntax? {
        switch self.kind {
        case .stringLiteralExpr: return "Swift.String"
        case .integerLiteralExpr: return "Swift.Int"
        case .floatLiteralExpr: return "Swift.Double"
        case .booleanLiteralExpr: return "Swift.Bool"

        case .arrayExpr:
            guard let arrayExpr = self.as(ArrayExprSyntax.self) else {
                return nil
            }
            guard let elementType = arrayExpr.detectedElementTypeByLiteral else {
                return nil
            }
            return .init(ArrayTypeSyntax(element: elementType))

        case .dictionaryExpr:
            guard let dictionaryExpr = self.as(DictionaryExprSyntax.self) else {
                return nil
            }
            guard let keyType = dictionaryExpr.detectedKeyTypeByLiteral,
                  let valueType = dictionaryExpr.detectedValueTypeByLiteral else {
                return nil
            }
            return .init(DictionaryTypeSyntax(key: keyType, value: valueType))

        default:
            return nil
        }
    }
}

extension Sequence where Element == ExprSyntax {
    var detectedElementTypeByLiteral: TypeSyntaxProtocol? {
        let expressions = Array(self)
        let isOptional = expressions.map(\.kind).contains(.nilLiteralExpr)

        let numberOfLiteralTypes = expressions
            .filter {
                $0.detectedTypeByLiteral != nil || $0.kind == .nilLiteralExpr
            }.count

        guard expressions.count == numberOfLiteralTypes else {
            return nil
        }

        let elementTypes = expressions
                .compactMap(\.detectedTypeByLiteral)
        guard !elementTypes.isEmpty else { return nil }

        let uniqueElementTypeStrings = Set(elementTypes.map { "\($0)" })
        let isAllSameType = uniqueElementTypeStrings.count == 1

        var detectedType: TypeSyntax?
        if isAllSameType,
           let type = elementTypes.first {
            detectedType = type
        } else if uniqueElementTypeStrings == ["Swift.Int", "Swift.Double"] {
            detectedType = "Swift.Double"
        }

        guard let detectedType else { return nil }
        if isOptional {
            return OptionalTypeSyntax(wrappedType: detectedType)
        } else {
            return detectedType
        }
    }
}

extension ArrayExprSyntax {
    var detectedElementTypeByLiteral: TypeSyntaxProtocol? {
        let expressions = elements.map(\.expression)
        return expressions.detectedElementTypeByLiteral
    }
}

extension DictionaryExprSyntax {
    var detectedKeyTypeByLiteral: TypeSyntaxProtocol? {
        guard case let .elements(elements) = self.content else {
            return nil
        }
        let expressions = elements.map(\.key)
        return expressions.detectedElementTypeByLiteral
    }

    var detectedValueTypeByLiteral: TypeSyntaxProtocol? {
        guard case let .elements(elements) = self.content else {
            return nil
        }
        let expressions = elements.map(\.value)
        return expressions.detectedElementTypeByLiteral
    }
}
