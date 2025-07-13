//
//  I18NString.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

struct I18NString: JSONSerializable {
    
    var values: [String: String] = [:]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.values   = try container.decode([String: String].self)
    }
    
    init(values: [String: String]) {
        self.values = values
    }
    
    init(language: String,
         value:    String)
    {
        values[language] = value
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

    
    func first() -> String? {
        return values.values.first
    }
    
    
    /// Parses an I18NString from a JSON dictionary.
    /// - Parameters:
    ///   - data: The raw JSON dictionary representing language-to-string mappings.
    ///   - value: An inout I18NString? to receive the parsed result.
    ///   - errorResponse: An inout String? to receive an error message on failure.
    /// - Returns: True if parsing succeeds; false otherwise.
    static func parse(
        from data:      [String: Any],
        value:          inout I18NString?,
        errorResponse:  inout String?
    ) -> Bool {
        guard let dict = data as? [String: String] else {
            errorResponse = "Invalid I18NString value: expected object of [String:String]"
            return false
        }
        value = I18NString(values: dict)
        errorResponse = nil
        return true
    }

    func toJSON() -> [String: Any] {
        return values
    }

}
