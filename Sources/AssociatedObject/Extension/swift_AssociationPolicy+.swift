//
//  swift_AssociationPolicy+.swift
//
//
//  Created by p-x9 on 2024/01/29.
//  
//

#if canImport(ObjectAssociation)

import ObjectAssociation

/// Extension for swift_AssociationPolicy to provide a more Swift-friendly interface.
extension swift_AssociationPolicy {
    /// Represents the atomicity options for associated objects.
    public enum Atomicity {
        /// Indicates that the associated object should be stored atomically.
        case atomic
        /// Indicates that the associated object should be stored non-atomically.
        case nonatomic
    }

    /// A property wrapper that corresponds to `.SWIFT_ASSOCIATION_ASSIGN` policy.
    public static var assign: Self { .SWIFT_ASSOCIATION_ASSIGN }

    /// A property wrapper that corresponds to `.SWIFT_ASSOCIATION_WEAK` policy.
    public static var weak: Self { .SWIFT_ASSOCIATION_WEAK }

    /// Create an association policy for retaining an associated object with the specified atomicity.
    ///
    /// - Parameter atomicity: The desired atomicity for the associated object.
    /// - Returns: The appropriate association policy for retaining with the specified atomicity.
    public static func retain(_ atomicity: Atomicity) -> Self {
        switch atomicity {
        case .atomic:
            return .SWIFT_ASSOCIATION_RETAIN
        case .nonatomic:
            return .SWIFT_ASSOCIATION_RETAIN_NONATOMIC
        }
    }
}

#endif
