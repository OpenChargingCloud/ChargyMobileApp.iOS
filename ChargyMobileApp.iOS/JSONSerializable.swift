//
//  JSONSerializable.swift
//  ChargyMobileApp.iOS
//
//  Defines a protocol for types that can produce JSON dictionaries,
//  and gives a default implementation of serialization helpers.
//

import Foundation

public protocol JSONSerializable {
    /// Must return a [String: Any] dictionary representation.
    func toJSON() -> [String: Any]
}

public extension JSONSerializable {
    
    /// Serializes the JSON dictionary to Data.
    func toJSONData(options: JSONSerialization.WritingOptions = []) throws -> Data {
        return try JSONSerialization.data(withJSONObject: toJSON(), options: options)
    }

    /// Serializes to a UTF-8 JSON string.
    func toJSONString(options: JSONSerialization.WritingOptions = []) -> String? {
        guard let data = try? toJSONData(options: options),
              let str = String(data: data, encoding: .utf8) else {
            return nil
        }
        return str
    }
    
}
