//
//  ClassType.swift
//
//
//  Created by p-x9 on 2024/01/19.
//  
//

import AssociatedObject

class ClassType {
    @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
    var int = 0

    @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
    var double = 0.0

    @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
    var string = ""

    @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
    var bool = false

    @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
    var optionalInt: Int?

    @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
    var optionalDouble: Double? = 123.4

    @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
    var optionalString: String?

    @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
    var optionalBool: Bool? = false

    @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
    var implicitlyUnwrappedString: String!

    @AssociatedObject(.OBJC_ASSOCIATION_RETAIN)
    var intArray = [0]

    @AssociatedObject(.OBJC_ASSOCIATION_RETAIN)
    var doubleArray = [0.0, 1]

    @AssociatedObject(.OBJC_ASSOCIATION_RETAIN)
    var stringArray = [""]

    @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
    var boolArray = [nil, false]

    @AssociatedObject(.OBJC_ASSOCIATION_RETAIN)
    var optionalIntArray = [0, nil]

    @AssociatedObject(.OBJC_ASSOCIATION_RETAIN)
    var optionalDoubleArray = [0.0, nil, 1]

    @AssociatedObject(.OBJC_ASSOCIATION_RETAIN)
    var optionalStringArray = [nil, ""]

    @AssociatedObject(.OBJC_ASSOCIATION_ASSIGN)
    var optionalBoolArray = [false, nil]

    @AssociatedObject(.OBJC_ASSOCIATION_RETAIN)
    var classType: ClassType2 = {
        .init()
    }()
}

class ClassType2 {}
