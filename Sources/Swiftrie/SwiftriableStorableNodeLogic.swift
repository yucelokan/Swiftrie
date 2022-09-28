//
//  SwiftrieNode+SwiftriableStorableNodeLogic.swift
//  
//
//  Created by okan.yucel on 6.03.2022.
//

import Foundation

protocol SwiftriableStorableNodeLogic: AnyObject {
    var value: Character? { get set }
    var items: [String] { get set }
    var parent: SwiftriableNode? { get set }
    var childrens: YOOrderedDictionary<Character, SwiftriableNode> { get set }
    var isFinal: Bool { get set }
    var isLeaf: Bool { get }
}
