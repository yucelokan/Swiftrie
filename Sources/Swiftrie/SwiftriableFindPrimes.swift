//
//  File.swift
//  
//
//  Created by okan.yucel on 7.03.2022.
//

import Foundation

class SwiftriableFindPrimes<T: Swiftriable>: Operation {
    typealias PrimesTrie = SwiftriableLogic & SwiftrieFindableLogic & SwiftrieStorableLogic
    init(swiftriable: PrimesTrie,
         prefix: String,
         type: T.Type,
         completion: @escaping ([T]) -> Void) {
        self.swiftriable = swiftriable
        self.prefix = prefix
        self.type = type
        self.completion = completion
    }
    
    private unowned var swiftriable: PrimesTrie
    private var prefix: String
    private var type: T.Type
    private var completion: ([T]) -> Void
    
    override func main() {
        findResults(with: prefix, type: type, completion: completion)
    }
    
    private func findResults<T: Swiftriable>(
        with prefix: String, type: T.Type? = nil, completion: (([T]) -> Void)? = nil
    ) {
        let graduallyIndex = (
            swiftriable as? SwiftrieAccessibleLogic
        )?.gradually.modIndex ?? -1
        var items: [T] = []
        let prefixLowerCased = prefix.lowercased()
        if let lastNode = swiftriable.findLastNodeOf(word: prefixLowerCased) {
            if lastNode.isFinal {
                let subItems: [T] = lastNode.items.compactMap({$0.toObject()})
                items.append(contentsOf: subItems)
            }
            for item in lastNode.childrens.values.enumerated() {
                if isCancelled {
                    return
                }
                let childItems: [T] = swiftriable.itemsInSubtrie(rootNode: item.element.value, partialWord: prefixLowerCased)
                items += childItems
                if graduallyIndex > 1, item.offset%graduallyIndex == 0 {
                    swiftriable.queue.async {
                        completion?(items)
                    }
                }
            }
        }
        completion?(items)
    }
}
