//
//  SwiftriableGraduallyLogic.swift
//  
//
//  Created by okan.yucel on 8.03.2022.
//

import Foundation

public enum SwiftriableGraduallyLogic {
    case nonIndexable
    case indexable(_ index: Int)
    
    var modIndex: Int? {
        switch self {
        case .nonIndexable:
            return nil
        case .indexable(let index):
            guard index > 1 else { return 2 }
            return index
        }
    }
}
