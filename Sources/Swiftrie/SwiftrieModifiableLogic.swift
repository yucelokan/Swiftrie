//
//  Swiftrie+SwiftrieModifiableLogic.swift
//  
//
//  Created by okan.yucel on 6.03.2022.
//

import Foundation

protocol SwiftrieModifiableLogic {
    func remove(_ swiftriable: Swiftriable)
    func insert(_ swiftriable: Swiftriable)
}
 
extension SwiftrieModifiableLogic where Self: SwiftrieFindableLogic & SwiftrieStorableLogic {
    /// Inserts a Swiftriable into the trie.
    /// - Parameter Swiftriable: the Swiftriable to be inserted.
    func insert(_ swiftriable: Swiftriable) {
        guard !swiftriable.prefixableText.isEmpty else { return }
        
        var currentNode = root
        swiftriable.prefixableText.lowercased().forEach { character in
            if let childNode = currentNode.childrens[character] {
                currentNode = childNode
            } else {
                currentNode.add(value: character)
                if let childNode = currentNode.childrens[character] {
                    currentNode = childNode
                }
            }
        }
        
        // Word already present?
        guard !currentNode.isFinal else {
            jsonAppender(node: currentNode, item: swiftriable)
            return
        }
        currentNode.isFinal = true
        jsonAppender(node: currentNode, item: swiftriable)
        
    }
    
    /// Removes a Swiftriable from the trie.  If the Swiftriable is not present or
    /// it is empty, just ignore it.  If the last node is a leaf,
    ///  and this node has a only an item as JSON string
    /// delete that node and higher nodes that are leaves until a
    /// terminating node or non-leaf is found.
    /// If it has more then one item only remove JSON string
    /// - Parameter Swiftriable: the Swiftriable to be removed.
    func remove(_ swiftriable: Swiftriable) {
        guard !swiftriable.prefixableText.isEmpty,
              let terminalNode = findTerminalNodeOf(word: swiftriable.prefixableText) else { return }
        
        guard terminalNode.isLeaf else {
            terminalNode.isFinal = false
            return
        }
        if terminalNode.items.count > 1 {
            if let index = terminalNode.items.firstIndex(where: {$0 == swiftriable.jsonString}) {
                terminalNode.items.remove(at: index)
            }
        } else {
            deleteNodesForWordEndingWith(terminalNode: terminalNode)
        }
    }
    
    /// add the json if it doesn't exist
    private func jsonAppender(node: SwiftriableNode, item: Swiftriable) {
        let jsonString = item.jsonString
        if !node.items.contains(jsonString) {
            node.items.append(jsonString)
        }
    }
}
