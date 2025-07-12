//
//  Firmware.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class Firmware: JSONSerializable {
    
    var version:       String
    var context:       String?
    var releaseDate:   Date?
    var checksum:      String?
    var url:           URL?

    init(
        version: String,
        context: String? = nil,
        releaseDate: Date? = nil,
        checksum: String? = nil,
        url: URL? = nil
    ) {
        self.version     = version
        self.context     = context
        self.releaseDate = releaseDate
        self.checksum    = checksum
        self.url         = url
    }

    func toJSON() -> [String: Any] {
        var dict: [String: Any] = [
            "version": version
        ]
        if let context = context {
            dict["context"] = context
        }
        if let date = releaseDate {
            dict["releaseDate"] = ISO8601DateFormatter().string(from: date)
        }
        if let checksum = checksum {
            dict["checksum"] = checksum
        }
        if let url = url {
            dict["url"] = url.absoluteString
        }
        return dict
    }

    static func parse(
        from data: [String: Any],
        value: inout Firmware?,
        errorResponse: inout String?
    ) -> Bool {
        // version (mandatory)
        var versionValue: String?
        guard data.parseMandatoryString("version", value: &versionValue, errorResponse: &errorResponse),
              let version = versionValue else {
            return false
        }
        // context (optional)
        var contextValue: String?
        _ = data.parseOptionalString("context", value: &contextValue, errorResponse: &errorResponse)
        // releaseDate (optional ISO8601 date)
        var dateValue: Date?
        guard data.parseOptionalDate("releaseDate", value: &dateValue, errorResponse: &errorResponse) else {
            return false
        }
        // checksum (optional)
        var checksumValue: String?
        _ = data.parseOptionalString("checksum", value: &checksumValue, errorResponse: &errorResponse)
        // url (optional)
        var urlString: String?
        if data.parseOptionalString("url", value: &urlString, errorResponse: &errorResponse),
           let rawURL = urlString,
           let parsedURL = URL(string: rawURL) {
            // parsedURL used below
            value = Firmware(
                version: version,
                context: contextValue,
                releaseDate: dateValue,
                checksum: checksumValue,
                url: parsedURL
            )
        } else {
            value = Firmware(
                version: version,
                context: contextValue,
                releaseDate: dateValue,
                checksum: checksumValue,
                url: nil
            )
        }
        errorResponse = nil
        return true
    }
}
