//
//  PatternBindingSyntax+.swift
//
//
//  Created by p-x9 on 2023/06/17.
//
//

import Foundation
import SwiftSyntax

extension PatternBindingSyntax {
    var setter: AccessorDeclSyntax? {
        get {
            guard let accessors = accessorBlock?.accessors,
                  case let .accessors(list) = accessors else {
                return nil
            }
            return list.first(where: {
                $0.accessorSpecifier.tokenKind == .keyword(.set)
            })
        }

        set {
            // NOTE: Be careful that setter cannot be implemented without a getter.
            setNewAccessor(kind: .keyword(.set), newValue: newValue)
        }
    }

    var getter: AccessorDeclSyntax? {
        get {
            switch accessorBlock?.accessors {
            case let .accessors(list):
                return list.first(where: {
                    $0.accessorSpecifier.tokenKind == .keyword(.get)
                })
            case let .getter(body):
                return AccessorDeclSyntax(accessorSpecifier: .keyword(.get), body: .init(statements: body))
            case .none:
                return nil
            }
        }

        set {
            let newAccessors: AccessorBlockSyntax.Accessors

            switch accessorBlock?.accessors {
            case .getter, .none:
                if let newValue {
                    if let body = newValue.body {
                        newAccessors = .getter(body.statements)
                    } else {
                        let accessors = AccessorDeclListSyntax {
                            newValue
                        }
                        newAccessors = .accessors(accessors)
                    }
                } else {
                    accessorBlock = .none
                    return
                }

            case let .accessors(list):
                var newList = list
                let accessor = list.first(where: { accessor in
                    accessor.accessorSpecifier.tokenKind == .keyword(.get)
                })
                if let accessor,
                   let index = list.index(of: accessor) {
                    if let newValue {
                        newList[index] = newValue
                    } else {
                        newList.remove(at: index)
                    }
                } else if let newValue {
                    newList.append(newValue)
                }
                newAccessors = .accessors(newList)
            }

            if accessorBlock == nil {
                accessorBlock = .init(accessors: newAccessors)
            } else {
                accessorBlock = accessorBlock?.with(\.accessors, newAccessors)
            }
        }
    }

    var isGetOnly: Bool {
        if initializer != nil {
            return false
        }
        if let accessors = accessorBlock?.accessors,
           case let .accessors(list) = accessors,
           list.contains(where: { $0.accessorSpecifier.tokenKind == .keyword(.set) }) {
            return false
        }
        if accessorBlock == nil && initializer == nil {
            return false
        }
        return true
    }
}

extension PatternBindingSyntax {
    var willSet: AccessorDeclSyntax? {
        get {
            if let accessors = accessorBlock?.accessors,
               case let .accessors(list) = accessors {
                return list.first(where: {
                    $0.accessorSpecifier.tokenKind == .keyword(.willSet)
                })
            }
            return nil
        }
        set {
            // NOTE: Be careful that willSet cannot be implemented without a setter.
            setNewAccessor(kind: .keyword(.willSet), newValue: newValue)
        }
    }

    var didSet: AccessorDeclSyntax? {
        get {
            if let accessors = accessorBlock?.accessors,
               case let .accessors(list) = accessors {
                return list.first(where: {
                    $0.accessorSpecifier.tokenKind == .keyword(.didSet)
                })
            }
            return nil
        }
        set {
            // NOTE: Be careful that didSet cannot be implemented without a setter.
            setNewAccessor(kind: .keyword(.willSet), newValue: newValue)
        }
    }
}

extension PatternBindingSyntax {
    // NOTE: - getter requires extra steps and should not be used.
    private mutating func setNewAccessor(kind: TokenKind, newValue: AccessorDeclSyntax?) {
        var newAccessor: AccessorBlockSyntax.Accessors

        switch accessorBlock?.accessors {
        case let .getter(body):
            guard let newValue else { return }
            newAccessor = .accessors(
                AccessorDeclListSyntax {
                    AccessorDeclSyntax(accessorSpecifier: .keyword(.get), body: .init(statements: body))
                    newValue
                }
            )
        case let .accessors(list):
            var newList = list
            let accessor = list.first(where: { accessor in
                accessor.accessorSpecifier.tokenKind == kind
            })
            if let accessor,
               let index = list.index(of: accessor) {
                if let newValue {
                    newList[index] = newValue
                } else {
                    newList.remove(at: index)
                }
            }
            newAccessor = .accessors(newList)
        case .none:
            guard let newValue else { return }
            newAccessor = .accessors(
                AccessorDeclListSyntax {
                    newValue
                }
            )
        }

        if accessorBlock == nil {
            accessorBlock = .init(accessors: newAccessor)
        } else {
            accessorBlock = accessorBlock?.with(\.accessors, newAccessor)
        }
    }
}
