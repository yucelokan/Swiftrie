//
//  YOOrderedDictionary.swift
//  
//
//  Created by okan.yucel on 12.04.2022.
//

import Foundation

class YOOrderedDictionary<Key: Hashable, Value> {
    
    typealias Element = (key: Key, value: Value)
    
    init() { }

    private (set) var values: [Element] = []
    
    subscript(key: Key) -> Value? {
        get {
            guard let item = values.first(where: {$0.key == key}) else { return nil }
            return item.value
        }
        set(newValue) {
            guard let value = newValue else {
                // if it is nil, remove it
                values.removeAll(where: {$0.key == key})
                return
            }
            let element = (key: key, value: value)
            guard let index = values.firstIndex(where: {$0.key == key}) else {
                // if there is no exist, append it
                values.append(element)
                return
            }
            // if it already exists, remove it and insert it
            values.remove(at: index)
            values.insert(element, at: index)
        }
    }
    
    func sort(
        by condition: (Element, Element) -> Bool
    ) {
        values.sort(by: condition)
    }
    
    var first: Value? {
        return values.first?.value
    }
    
    var last: Value? {
        return values.last?.value
    }
    
    var count: Int {
        return values.count
    }
    
    var isEmpty: Bool {
        return values.isEmpty
    }
    
}
