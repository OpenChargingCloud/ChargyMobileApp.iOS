//
//  FirmwareComponent.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class FirmwareComponent: Identifiable, JSONSerializable {
    
    var id:            String
    var context:       String?
    var description:   I18NString?
    var version:       String
    var releaseDate:   Date?
    var checksum:      String?
    var url:           URL?

    init(
        id: String,
        context: String? = nil,
        description: I18NString? = nil,
        version: String,
        releaseDate: Date? = nil,
        checksum: String? = nil,
        url: URL? = nil
    ) {
        self.id          = id
        self.context     = context
        self.description = description
        self.version     = version
        self.releaseDate = releaseDate
        self.checksum    = checksum
        self.url         = url
    }

    func toJSON() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "version": version
        ]
        if let context = context {
            dict["context"] = context
        }
        if let description = description {
            dict["description"] = description.toJSON()
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
        value: inout FirmwareComponent?,
        errorResponse: inout String?
    ) -> Bool {
        // id (mandatory)
        var idValue: String?
        guard data.parseMandatoryString("id", value: &idValue, errorResponse: &errorResponse),
              let id = idValue else {
            return false
        }
        // version (mandatory)
        var versionValue: String?
        guard data.parseMandatoryString("version", value: &versionValue, errorResponse: &errorResponse),
              let version = versionValue else {
            return false
        }
        // optional fields
        let contextValue     = data["context"] as? String
        var descValue: I18NString?
        guard data.parseOptionalI18NString("description", value: &descValue, errorResponse: &errorResponse) else {
            return false
        }
        var dateValue: Date?
        guard data.parseOptionalDate("releaseDate", value: &dateValue, errorResponse: &errorResponse) else {
            return false
        }
        let checksumValue    = data["checksum"] as? String
        var urlString: String?
        _ = data.parseOptionalString("url", value: &urlString, errorResponse: &errorResponse)
        let urlValue         = urlString.flatMap { URL(string: $0) }

        // instantiate
        value = FirmwareComponent(
            id: id,
            context: contextValue,
            description: descValue,
            version: version,
            releaseDate: dateValue,
            checksum: checksumValue,
            url: urlValue
        )
        errorResponse = nil
        return true
    }
}
