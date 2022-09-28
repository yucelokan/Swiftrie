//
//  TestModelCreator.swift
//  
//
//  Created by okan.yucel on 9.03.2022.
//

import Foundation

enum TestModelCreator {
    case get(count: Int)
    
    var models: [SwiftrieTestModel] {
        switch self {
        case .get(let count):
            var items: [SwiftrieTestModel] = []
            for index in 0..<count {
                items.append(.init(name: "item \(index)", id: index))
            }
            return items
        }
    }
}
