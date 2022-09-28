//
//  SwiftrieNode+SwiftriableModifiableNodeLogic.swift
//  
//
//  Created by okan.yucel on 6.03.2022.
//

import Foundation
 
protocol SwifriableModifiableNodeLogic: AnyObject {
    init(value: Character?, parent: SwiftriableNode?, item: String?)
    func add(value: Character, item: String?)
}

extension SwifriableModifiableNodeLogic where Self: SwiftriableStorableNodeLogic {
    /// Adds a child node to self.
    /// - Parameter value: The item to be added to this node.
    func add(value: Character, item: String? = nil) {
        childrens[value] = SwiftrieNode(value: value, parent: self, item: item)
        childrens.sort(by: {$0.key.lowercased() < $1.key.lowercased()})
    }
}
