import ObjectiveC

@attached(peer, names: arbitrary)
@attached(accessor)
public macro AssociatedObject(_ policy: objc_AssociationPolicy) = #externalMacro(module: "AssociatedObjectPlugin", type: "AssociatedObjectMacro")

@attached(peer, names: arbitrary)
@attached(accessor)
public macro AssociatedObject(_ policy: objc_AssociationPolicy, key: Any) = #externalMacro(module: "AssociatedObjectPlugin", type: "AssociatedObjectMacro")
