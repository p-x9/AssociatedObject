@_exported import ObjectiveC
@_exported import AssociatedObjectC

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
