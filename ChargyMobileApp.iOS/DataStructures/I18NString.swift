//
//  I18NString.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

struct I18NString: Codable {
    
    var values: [String: String] = [:]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.values   = try container.decode([String: String].self)
    }
    
    init(values: [String: String]) {
        self.values = values
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(values)
    }
    
    init() {
        self.values = [:]
    }
    
    mutating func add(_ lang: String, _ value: String) {
        self.values[lang] = value
    }
    
    mutating func remove(_ lang: String) {
        values.removeValue(forKey: lang)
    }

    subscript(lang: String) -> String? {
        get { values[lang] }
        set { values[lang] = newValue }
    }
    
}
