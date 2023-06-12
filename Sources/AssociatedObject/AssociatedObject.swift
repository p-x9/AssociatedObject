import ObjectiveC

@attached(peer, names: arbitrary)
@attached(accessor)
public macro AssociatedObject(_ policy: objc_AssociationPolicy) = #externalMacro(module: "AssociatedObjectPlugin", type: "AssociatedObjectMacro")
