//
//  SwiftrieStorableLogic.swift
//  
//
//  Created by okan.yucel on 8.03.2022.
//

import Foundation

protocol SwiftrieStorableLogic: AnyObject {
    var root: SwiftriableNode { get set }
    var operations: OperationQueue { get set }
    var queue: DispatchQueue { get set }
}
