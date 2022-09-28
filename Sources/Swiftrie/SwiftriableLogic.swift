//
//  Swiftrie+SwiftriableLogic.swift
//  
//
//  Created by okan.yucel on 6.03.2022.
//

import Foundation

protocol SwiftriableLogic: AnyObject {
    init(swiftriables: [Swiftriable])
    func items<T: Swiftriable>() -> [T]
    func find<T: Swiftriable>(
        with prefix: String, type: T.Type, completion: @escaping (([T]) -> Void)
    )
}

extension SwiftriableLogic where Self: SwiftrieFindableLogic & SwiftrieStorableLogic {
    /// All Swiftriables currently in the trie
    func items<T: Swiftriable>() -> [T] {
        return itemsInSubtrie(rootNode: root, partialWord: "")
    }
    
    /// Fetchs part by part an array of Swiftriable in a subtrie of the trie that start with the given prefix
    /// - Parameters:
    ///   - prefix: the letters for word prefix
    ///   - type: type of Swiftriable
    ///   - completion: Swiftriables in the subtrie that start with prefix (party by part)
    func find<T: Swiftriable>(
        with prefix: String, type: T.Type, completion: @escaping (([T]) -> Void)
    ) {
        operations.cancelAllOperations()
        let operation = SwiftriableFindPrimes<T>(
            swiftriable: self, prefix: prefix, type: type, completion: completion
        )
        operations.addOperation(operation)
    }
}
