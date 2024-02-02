#if canImport(AssociatedObjectC)
@_exported import AssociatedObjectC
#endif


#if canImport(ObjectiveC)

@_exported import ObjectiveC
public typealias Policy = objc_AssociationPolicy

#elseif canImport(ObjectAssociation)

@_exported import ObjectAssociation
public typealias Policy = swift_AssociationPolicy

#endif


@attached(peer, names: arbitrary)
@attached(accessor)
public macro AssociatedObject(
    _ policy: Policy
) = #externalMacro(
    module: "AssociatedObjectPlugin",
    type: "AssociatedObjectMacro"
)

@attached(peer, names: arbitrary)
@attached(accessor)
public macro AssociatedObject(
    _ policy: Policy,
    key: Any
) = #externalMacro(
    module: "AssociatedObjectPlugin",
    type: "AssociatedObjectMacro"
)

@attached(accessor)
public macro _AssociatedObject(
    _ policy: Policy
) = #externalMacro(
    module: "AssociatedObjectPlugin",
    type: "AssociatedObjectMacro"
)
