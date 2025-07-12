//
//  ChargingTariff.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class ChargingTariff: Identifiable {
        
    var id:                   String
   
    /// Designated initializer
    init(id: String) {
        self.id = id
    }

    /// Converts this ChargingTariff into a JSON dictionary.
    func toJSON() -> [String: Any] {
        return ["id": id]
    }

    /// Parses a ChargingTariff from a JSON dictionary.
    static func parse(
        from data: [String: Any],
        value: inout ChargingTariff?,
        errorResponse: inout String?
    ) -> Bool {
        // id (mandatory)
        var idValue: String?
        guard data.parseMandatoryString("id", value: &idValue, errorResponse: &errorResponse),
              let id = idValue else {
            return false
        }
        value = ChargingTariff(id: id)
        errorResponse = nil
        return true
    }
    
}
