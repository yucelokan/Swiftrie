//
//  Swiftrie.swift
//
//
//  Created by okan.yucel on 6.03.2022.
//

import Foundation

typealias SwiftrieAllLogics = (
    SwiftriableLogic & SwiftrieStorableLogic & SwiftrieFindableLogic & SwiftrieModifiableLogic
)

public class Swiftrie: SwiftrieAllLogics {
    required public init(swiftriables: [Swiftriable]) {
        swiftriables.forEach { swiftriable in
            insert(swiftriable)
        }
    }
    
    var root: SwiftriableNode = SwiftrieNode(value: nil, parent: nil, item: nil)
    var operations: OperationQueue = OperationQueue()
    var queue: DispatchQueue = DispatchQueue(label: "swiftrie-safe", qos: .userInitiated, attributes: .concurrent)
    
    public var gradually: SwiftriableGraduallyLogic = .indexable(3)
}
