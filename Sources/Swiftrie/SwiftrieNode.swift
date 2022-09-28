//
//  SwiftrieNode.swift
//  
//
//  Created by okan.yucel on 5.03.2022.
//

import Foundation

typealias SwiftriableNode = SwifriableModifiableNodeLogic & SwiftriableStorableNodeLogic

/// A node in the trie
class SwiftrieNode: SwiftriableNode {
    
    /// Initializes a node.
    ///
    /// - Parameters:
    ///   - value: The value that goes into the node
    ///   - parent: A reference to this node's parent
    ///   - item: a json string for the swiftriable item
    required init(value: Character?, parent: SwiftriableNode?, item: String?) {
        self.value = value
        self.parent = parent
        self.items.append(item ?? "")
    }
    
    var value: Character?
    var items: [String] = []
    weak var parent: SwiftriableNode?
    var childrens: YOOrderedDictionary<Character, SwiftriableNode> = .init()
    var isFinal: Bool = false
    
    var isLeaf: Bool {
        return childrens.isEmpty
    }
}
