//
//  objc_AssociationPolicy+.swift
//
//
//  Created by p-x9 on 2023/11/04.
//  
//

#if canImport(ObjectiveC)

import ObjectiveC

/// Extension for objc_AssociationPolicy to provide a more Swift-friendly interface.
extension objc_AssociationPolicy {
    /// Represents the atomicity options for associated objects.
    public enum Atomicity {
        /// Indicates that the associated object should be stored atomically.
        case atomic
        /// Indicates that the associated object should be stored non-atomically.
        case nonatomic
    }

    /// A property wrapper that corresponds to `.OBJC_ASSOCIATION_ASSIGN` policy.
    public static var assign: Self { .OBJC_ASSOCIATION_ASSIGN }

    /// Create an association policy for retaining an associated object with the specified atomicity.
    ///
    /// - Parameter atomicity: The desired atomicity for the associated object.
    /// - Returns: The appropriate association policy for retaining with the specified atomicity.
    public static func retain(_ atomicity: Atomicity) -> Self {
        switch atomicity {
        case .atomic:
            return .OBJC_ASSOCIATION_RETAIN
        case .nonatomic:
            return .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        }
    }

    /// Create an association policy for copying an associated object with the specified atomicity.
    ///
    /// - Parameter atomicity: The desired atomicity for the associated object.
    /// - Returns: The appropriate association policy for copying with the specified atomicity.
    public static func copy(_ atomicity: Atomicity) -> Self {
        switch atomicity {
        case .atomic:
            return .OBJC_ASSOCIATION_COPY
        case .nonatomic:
            return .OBJC_ASSOCIATION_COPY_NONATOMIC
        }
    }
}

#endif
