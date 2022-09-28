//
//  String+Extensions.swift
//
//
//  Created by okan.yucel on 5.03.2022.
//

import Foundation

extension String {
    func toObject<T: Decodable>() -> T? {
        return try? JSONDecoder().decode(T.self, from: Data(self.utf8))
    }
}
