//
//  SwiftrieTestModel.swift
//  
//
//  Created by okan.yucel on 9.03.2022.
//

import Foundation
import Swiftrie

struct SwiftrieTestModel {
    var name: String
    var id: Int
}

extension SwiftrieTestModel: Swiftriable {
    var prefixableText: String {
        return name
    }
}
