//
//  PublicKeysignature.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class OIDInfo: JSONSerializable {

    var oid:    String
    var name:   String

    init(oid: String, name: String) {
        self.oid  = oid
        self.name = name
    }

    func toJSON() -> [String: Any] {
        return [
            "oid": oid,
            "name": name
        ]
    }

    static func parse(
        from data: [String: Any],
        value: inout OIDInfo?,
        errorResponse: inout String?
    ) -> Bool {
        // oid (mandatory)
        var oidValue: String?
        guard data.parseMandatoryString("oid", value: &oidValue, errorResponse: &errorResponse),
              let oid = oidValue else {
            return false
        }
        // name (mandatory)
        var nameValue: String?
        guard data.parseMandatoryString("name", value: &nameValue, errorResponse: &errorResponse),
              let name = nameValue else {
            return false
        }
        // Instantiate
        value = OIDInfo(oid: oid, name: name)
        errorResponse = nil
        return true
    }
    
}
