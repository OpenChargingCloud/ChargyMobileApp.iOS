//
//  Hardware.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 09.07.25.
//

import Foundation

class Hardware: JSONSerializable {
    
    var version:       String
    var context:       String?
    var url:           URL?

    init(
        version: String,
        context: String? = nil,
        url: URL? = nil
    ) {
        self.version = version
        self.context = context
        self.url     = url
    }

    func toJSON() -> [String: Any] {
        var dict: [String: Any] = [
            "version": version
        ]
        if let context = context {
            dict["context"] = context
        }
        if let url = url {
            dict["url"] = url.absoluteString
        }
        return dict
    }

    static func parse(
        from data: [String: Any],
        value: inout Hardware?,
        errorResponse: inout String?
    ) -> Bool {
        // version (mandatory)
        var versionValue: String?
        guard data.parseMandatoryString("version", value: &versionValue, errorResponse: &errorResponse),
              let version = versionValue else {
            return false
        }
        // context (optional)
        let contextValue = data["context"] as? String
        // url (optional)
        var urlString: String?
        _ = data.parseOptionalString("url", value: &urlString, errorResponse: &errorResponse)
        let urlValue = urlString.flatMap { URL(string: $0) }
        // instantiate
        value = Hardware(version: version, context: contextValue, url: urlValue)
        errorResponse = nil
        return true
    }

}
