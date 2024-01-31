//
//  functions.swift
//
//
//  Created by p-x9 on 2024/01/28.
//  
//

#if canImport(ObjectiveC)
import ObjectiveC
#elseif canImport(ObjectAssociation)
import ObjectAssociation
#else
#warning("Current platform is not supported")
#endif


public func getAssociatedObject(
    _ object: AnyObject,
    _ key: UnsafeRawPointer
) -> Any? {
#if canImport(ObjectiveC)
    objc_getAssociatedObject(object, key)
#elseif canImport(ObjectAssociation)
    ObjectAssociation.getAssociatedObject(object, key)
#endif
}


public func setAssociatedObject(
    _ object: AnyObject,
    _ key: UnsafeRawPointer,
    _ value: Any?,
    _ policy: Policy = .retain(.nonatomic)
) {
#if canImport(ObjectiveC)
    objc_setAssociatedObject(
        object,
        key,
        value,
        policy
    )
#elseif canImport(ObjectAssociation)
    ObjectAssociation.setAssociatedObject(
        object,
        key,
        value
    )
#endif
}
