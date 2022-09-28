//
//  SwiftrieAccessibleLogic.swift
//  
//
//  Created by okan.yucel on 8.03.2022.
//

import Foundation

public protocol SwiftrieAccessibleLogic {
    
    /// cancel all search thats are active
    func cancelSearch()
    
    /// get all items in Swiftrie.
    /// - Returns: A Swiftriable array that is generic. Response type should be provided.
    func getAllItems<T: Swiftriable>() -> [T]
    
    /// Fetchs part by part an array of Swiftriable in a subtrie of the trie that start with the given prefix
    /// - Parameters:
    ///   - prefix: the letters for word prefix
    ///   - throttle: delay for search / deduped
    ///   - type: type of Swiftriable
    ///   - completion: Swiftriables in the subtrie
    ///   that start with prefix (party by part) (to change logic check .gradually)
    func findItems<T: Swiftriable>(
        prefix: String, throttle: Double, type: T.Type, completion: @escaping (([T]) -> Void)
    )
    
    /// remove a Swiftriable item from Swiftrie .
    /// - Parameter Swiftriable: the Swiftriable to be removed
    func removeItem(_ swiftriable: Swiftriable)
    
    /// Inserts a Swiftriable into the trie.
    /// - Parameter Swiftriable: the Swiftriable to be inserted.
    func insertItem(_ swiftriable: Swiftriable)
    
    /// a logic to get data part by part. Default is `case indexable(_ index: 3)`
    /// index 3 means, the find method will return the response
    /// that it found at every 3 nodes without waiting for all nodes that will be visited.
    var gradually: SwiftriableGraduallyLogic { get set }
}

extension Swiftrie: SwiftrieAccessibleLogic {
    public func cancelSearch() {
        operations.cancelAllOperations()
    }
    
    public func getAllItems<T: Swiftriable>() -> [T] {
        queue.sync {
            return items()
        }
    }
    
    public func findItems<T: Swiftriable>(
        prefix: String, throttle: Double, type: T.Type, completion: @escaping (([T]) -> Void)
    ) {
        queue.asyncDeduped(target: self, after: throttle) { [weak self] in
            self?.queue.sync {
                self?.find(with: prefix, type: type, completion: completion)
            }
        }
    }
    
    public func removeItem(_ swiftriable: Swiftriable) {
        queue.async(flags: .barrier) {
            self.remove(swiftriable)
        }
    }
    
    public func insertItem(_ swiftriable: Swiftriable) {
        queue.async(flags: .barrier) {
            self.insert(swiftriable)
        }
    }
}
