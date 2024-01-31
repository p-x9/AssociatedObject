//
//  ClassType.swift
//
//
//  Created by p-x9 on 2024/01/19.
//  
//

import AssociatedObject

class ClassType {
    @AssociatedObject(.retain(.nonatomic))
    var int = 0

    @AssociatedObject(.retain(.nonatomic))
    var double = 0.0

    @AssociatedObject(.retain(.nonatomic))
    var string = ""

    @AssociatedObject(.retain(.nonatomic))
    var bool = false

    @AssociatedObject(.retain(.nonatomic))
    var optionalInt: Int?

    @AssociatedObject(.retain(.nonatomic))
    var optionalDouble: Double? = 123.4

    @AssociatedObject(.retain(.nonatomic))
    var optionalString: String?

    @AssociatedObject(.retain(.nonatomic))
    var optionalBool: Bool? = false

    @AssociatedObject(.retain(.nonatomic))
    var implicitlyUnwrappedString: String!

    @AssociatedObject(.retain(.atomic))
    var intArray = [0]

    @AssociatedObject(.retain(.atomic))
    var doubleArray = [0.0, 1]

    @AssociatedObject(.retain(.atomic))
    var stringArray = [""]

    @AssociatedObject(.retain(.nonatomic))
    var boolArray = [nil, false]

    @AssociatedObject(.retain(.atomic))
    var optionalIntArray = [0, nil]

    @AssociatedObject(.retain(.atomic))
    var optionalDoubleArray = [0.0, nil, 1]

    @AssociatedObject(.retain(.atomic))
    var optionalStringArray = [nil, ""]

    @AssociatedObject(.retain(.nonatomic))
    var optionalBoolArray = [false, nil]

    @AssociatedObject(.retain(.atomic))
    var classType: ClassType2 = {
        .init()
    }()
}

class ClassType2 {}

protocol ProtocolType: AnyObject {}

extension ProtocolType {
    @AssociatedObject(.retain(.nonatomic))
    var definedInProtocol = "hello"
}

extension ClassType: ProtocolType {}
