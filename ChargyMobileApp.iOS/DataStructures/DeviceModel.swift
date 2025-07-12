//
//  DeviceModel.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class DeviceModel: JSONSerializable {
    
    var context:   String?
    var name:      String
    var url:       URL?

    init(context: String? = nil, name: String, url: URL? = nil) {
        self.context = context
        self.name    = name
        self.url     = url
    }

    func toJSON() -> [String: Any] {
        var dict: [String: Any] = [
            "name": name
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
        value: inout DeviceModel?,
        errorResponse: inout String?
    ) -> Bool {
        // context (optional)
        var contextValue: String?
        _ = data.parseOptionalString("context", value: &contextValue, errorResponse: &errorResponse)
        // name (mandatory)
        var nameValue: String?
        guard data.parseMandatoryString("name", value: &nameValue, errorResponse: &errorResponse),
              let name = nameValue else {
            return false
        }
        // url (optional)
        var urlString: String?
        if data.parseOptionalString("url", value: &urlString, errorResponse: &errorResponse),
           let rawURL = urlString,
           let parsedURL = URL(string: rawURL) {
            // use parsedURL
            value = DeviceModel(context: contextValue, name: name, url: parsedURL)
        } else {
            // Either url missing or parsed URL nil; initialize without URL
            value = DeviceModel(context: contextValue, name: name, url: nil)
        }
        errorResponse = nil
        return true
    }
    
}
