//
//  Swiftrie+Extensions.swift
//  
//
//  Created by okan.yucel on 5.03.2022.
//

import Foundation

protocol SwiftrieFindableLogic: AnyObject {
    func findLastNodeOf(word: String) -> SwiftriableNode?
    func findTerminalNodeOf(word: String) -> SwiftriableNode?
    func deleteNodesForWordEndingWith(terminalNode: SwiftriableNode)
    func itemsInSubtrie<T: Swiftriable>(rootNode: SwiftriableNode, partialWord: String) -> [T]
}

extension SwiftrieFindableLogic where Self: SwiftrieStorableLogic {
    /// Attempts to walk to the last node of a word.  The
    /// search will fail if the word is not present. Doesn't
    /// check if the node is terminating
    ///
    /// - Parameter word: the word in question
    /// - Returns: the node where the search ended, nil if the
    /// search failed.
    func findLastNodeOf(word: String) -> SwiftriableNode? {
        var currentNode = root
        for character in word.lowercased() {
            guard let childNode = currentNode.childrens[character] else {
                return nil
            }
            currentNode = childNode
        }
        return currentNode
    }
    
    /// Attempts to walk to the terminating node of a word.  The
    /// search will fail if the word is not present.
    ///
    /// - Parameter word: the word in question
    /// - Returns: the node where the search ended, nil if the
    /// search failed.
    func findTerminalNodeOf(word: String) -> SwiftriableNode? {
        if let lastNode = findLastNodeOf(word: word) {
            return lastNode.isFinal ? lastNode : nil
        }
        return nil
    }
    
    /// Deletes a word from the trie by starting with the last letter
    /// and moving back, deleting nodes until either a non-leaf or a
    /// terminating node is found.
    ///
    /// - Parameter terminalNode: the node representing the last node
    /// of a word
    func deleteNodesForWordEndingWith(terminalNode: SwiftriableNode) {
        var lastNode = terminalNode
        var character = lastNode.value
        while lastNode.isLeaf, let parentNode = lastNode.parent {
            lastNode = parentNode
            lastNode.childrens[character ?? Character("empty")] = nil
            character = lastNode.value
            if lastNode.isFinal {
                break
            }
        }
    }
    
    /// Returns an array of words in a subtrie of the trie
    ///
    /// - Parameters:
    ///   - rootNode: the root node of the subtrie
    ///   - partialWord: the letters collected by traversing to this node
    /// - Returns: the objects in the subtrie
    func itemsInSubtrie<T: Swiftriable>(rootNode: SwiftriableNode, partialWord: String) -> [T] {
        var subtrieItems: [T] = []
        var previousLetters = partialWord
        if let value = rootNode.value {
            previousLetters.append(value)
        }
        if rootNode.isFinal {
            let items: [T] = rootNode.items.compactMap({$0.toObject()})
            subtrieItems.append(contentsOf: items)
        }
        for item in rootNode.childrens.values {
            let childItems: [T] = itemsInSubtrie(rootNode: item.value, partialWord: previousLetters)
            subtrieItems += childItems
        }
        return subtrieItems
    }
}
