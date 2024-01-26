@_exported import ObjectiveC

#if canImport(AssociatedObjectC)
@_exported import AssociatedObjectC
#endif

@attached(peer, names: arbitrary)
@attached(accessor)
public macro AssociatedObject(
    _ policy: objc_AssociationPolicy
) = #externalMacro(
    module: "AssociatedObjectPlugin",
    type: "AssociatedObjectMacro"
)

@attached(accessor)
public macro _AssociatedObject(
    _ policy: objc_AssociationPolicy
) = #externalMacro(
    module: "AssociatedObjectPlugin",
    type: "AssociatedObjectMacro"
)
