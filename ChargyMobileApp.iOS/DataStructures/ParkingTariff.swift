//
//  ParkingTariff.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 09.07.25.
//

import Foundation

class ParkingTariff: Identifiable, JSONSerializable {

    var id:           UUID?

    /// Designated initializer
    init(id: UUID? = nil) {
        self.id = id
    }

    /// Converts this ParkingTariff into a JSON dictionary.
    func toJSON() -> [String: Any] {
        var dict: [String: Any] = [:]
        if let id = id {
            dict["id"] = id.uuidString
        }
        return dict
    }

    /// Parses a ParkingTariff from a JSON dictionary.
    static func parse(
        from data: [String: Any],
        value: inout ParkingTariff?,
        errorResponse: inout String?
    ) -> Bool {
        // id (optional UUID)
        var idString: String?
        guard data.parseOptionalString("id", value: &idString, errorResponse: &errorResponse) else {
            return false
        }
        // Convert to UUID if present
        let idValue: UUID?
        if let raw = idString {
            guard let uuid = UUID(uuidString: raw) else {
                errorResponse = "Invalid 'id' format: expected UUID string"
                return false
            }
            idValue = uuid
        } else {
            idValue = nil
        }
        // Instantiate
        value = ParkingTariff(id: idValue)
        errorResponse = nil
        return true
    }
}
