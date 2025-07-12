//
//  Connector.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class Connector: Identifiable, JSONSerializable {

    var id: String
    var type: String
    var looses: Double

    init(id: String, type: String, looses: Double) {
        self.id = id
        self.type = type
        self.looses = looses
    }
    
    func toJSON() -> [String: Any] {
        return [
            "id": id,
            "type": type,
            "looses": looses
        ]
    }

    static func parse(
        from data: [String: Any],
        value: inout Connector?,
        errorResponse: inout String?
    ) -> Bool {
        // id (mandatory)
        var idValue: String?
        guard data.parseMandatoryString("id", value: &idValue, errorResponse: &errorResponse),
              let id = idValue else {
            return false
        }
        // type (mandatory)
        var typeValue: String?
        guard data.parseMandatoryString("type", value: &typeValue, errorResponse: &errorResponse),
              let type = typeValue else {
            return false
        }
        // looses (mandatory)
        var loosesValue: Double?
        guard data.parseMandatoryDouble("looses", value: &loosesValue, errorResponse: &errorResponse),
              let looses = loosesValue else {
            return false
        }
        // Instantiate
        value = Connector(id: id, type: type, looses: looses)
        errorResponse = nil
        return true
    }
    
}
