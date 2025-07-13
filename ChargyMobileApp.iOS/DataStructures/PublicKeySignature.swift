//
//  PublicKeysignature.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class PublicKeySignature: Identifiable,
                          JSONSerializable {
    
    var id:         String
    var context:    String?
    var timestamp:  Date?
    var keyUsage:  [String]?

    private static let isoFormatter: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()

    init(
        id:         String,
        context:    String?    = nil,
        timestamp:  Date?      = nil,
        keyUsage:  [String]?   = nil
    ) {
        self.id         = id
        self.context    = context
        self.timestamp  = timestamp
        self.keyUsage   = keyUsage
    }

    func toJSON() -> [String: Any] {
        var json: [String: Any] = [
            "@id": id
        ]
        if let context_ = context {
            json["@context"] = context_
        }
        if let timestamp_ = timestamp {
            json["timestamp"] = PublicKeySignature.isoFormatter.string(from: timestamp_)
        }
        if let usage = keyUsage {
            json["keyUsage"] = usage
        }
        return json
    }

    static func parse(
        from data:      [String: Any],
        value:          inout PublicKeySignature?,
        errorResponse:  inout String?
    ) -> Bool {

        var idValue: String?
        guard data.parseMandatoryString("@id", value: &idValue, errorResponse: &errorResponse),
              let id = idValue else {
            return false
        }

        var contextValue: String?
        _ = data.parseOptionalString("@context", value: &contextValue, errorResponse: &errorResponse)

        var timestampString: String?
        _ = data.parseOptionalString("timestamp", value: &timestampString, errorResponse: &errorResponse)

        var timestamp: Date? = nil
        if let timestampString = timestampString {
            if let date = isoFormatter.date(from: timestampString) {
                timestamp = date
            } else {
                errorResponse = "Invalid timestamp format"
                return false
            }
        }

        var usage: [String]?
        if let raw = data["keyUsage"] as? [Any] {
            usage = raw.compactMap { $0 as? String }
        }

        value = PublicKeySignature(
                    id:         id,
                    context:    contextValue,
                    timestamp:  timestamp,
                    keyUsage:   usage
                )

        errorResponse = nil
        return true

    }
    
}
