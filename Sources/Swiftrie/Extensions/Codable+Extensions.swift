//
//  Codable+Extensions.swift
//  
//
//  Created by okan.yucel on 5.03.2022.
//

import Foundation

extension Encodable {
    var data: Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try? encoder.encode(self)
    }

    var jsonString: String {
        guard let data = data else { return "" }
        guard let jsonString = String(data: data, encoding: .utf8) else { return "" }
        return jsonString
    }
}
