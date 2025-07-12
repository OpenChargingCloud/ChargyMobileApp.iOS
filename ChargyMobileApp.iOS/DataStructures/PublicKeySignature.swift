//
//  PublicKeysignature.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class PublicKeySignature: Identifiable, JSONSerializable {
    
    var id:          String
    var context:     String
    var timestamp:   String
    var keyUsage:    [String]?

    /// Designated initializer
    init(
        id: String,
        context: String,
        timestamp: String,
        keyUsage: [String]? = nil
    ) {
        self.id = id
        self.context = context
        self.timestamp = timestamp
        self.keyUsage = keyUsage
    }

    /// Converts this PublicKeySignature into a JSON dictionary.
    func toJSON() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "context": context,
            "timestamp": timestamp
        ]
        if let usage = keyUsage {
            dict["keyUsage"] = usage
        }
        return dict
    }

    /// Parses a PublicKeySignature from a JSON dictionary.
    static func parse(
        from data: [String: Any],
        value: inout PublicKeySignature?,
        errorResponse: inout String?
    ) -> Bool {
        // id (mandatory)
        var idValue: String?
        guard data.parseMandatoryString("id", value: &idValue, errorResponse: &errorResponse),
              let id = idValue else {
            return false
        }
        // context (mandatory)
        var contextValue: String?
        guard data.parseMandatoryString("context", value: &contextValue, errorResponse: &errorResponse),
              let context = contextValue else {
            return false
        }
        // timestamp (mandatory)
        var timestampValue: String?
        guard data.parseMandatoryString("timestamp", value: &timestampValue, errorResponse: &errorResponse),
              let timestamp = timestampValue else {
            return false
        }
        // keyUsage (optional array of String)
        var usage: [String]?
        if let raw = data["keyUsage"] as? [Any] {
            usage = raw.compactMap { $0 as? String }
        }
        // instantiate
        value = PublicKeySignature(
            id: id,
            context: context,
            timestamp: timestamp,
            keyUsage: usage
        )
        errorResponse = nil
        return true
    }
    
}
