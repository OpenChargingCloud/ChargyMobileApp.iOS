//
//  EMobilityProvider.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class EMobilityProvider: Identifiable, JSONSerializable {
    
    var id:                String
    var context:           String?
    var description:       I18NString?
    var chargingTariffs:   [ChargingTariff]  = []
    var publicKeys:        [PublicKey]       = []

    init(
        id: String,
        context: String? = nil,
        description: I18NString? = nil,
        chargingTariffs: [ChargingTariff] = [],
        publicKeys: [PublicKey] = []
    ) {
        self.id               = id
        self.context          = context
        self.description      = description
        self.chargingTariffs  = chargingTariffs
        self.publicKeys       = publicKeys
    }

    func toJSON() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id
        ]
        if let context = context {
            dict["context"] = context
        }
        if let description = description {
            dict["description"] = description.toJSON()
        }
        if !chargingTariffs.isEmpty {
            dict["chargingTariffs"] = chargingTariffs.map { $0.toJSON() }
        }
        if !publicKeys.isEmpty {
            dict["publicKeys"] = publicKeys.map { $0.toJSON() }
        }
        return dict
    }

    static func parse(
        from data: [String: Any],
        value: inout EMobilityProvider?,
        errorResponse: inout String?
    ) -> Bool {
        // id (mandatory)
        var idValue: String?
        guard data.parseMandatoryString("id", value: &idValue, errorResponse: &errorResponse),
              let id = idValue else {
            return false
        }
        // context (optional)
        var contextValue: String?
        _ = data.parseOptionalString("context", value: &contextValue, errorResponse: &errorResponse)
        // description (optional I18NString)
        var descriptionValue: I18NString?
        guard data.parseOptionalI18NString("description", value: &descriptionValue, errorResponse: &errorResponse) else {
            return false
        }
        // chargingTariffs (optional array)
        var tariffs: [ChargingTariff]? = []
        guard data.parseOptionalArray("chargingTariffs", into: &tariffs, errorResponse: &errorResponse,
            using: { dict, tariff, err in
                ChargingTariff.parse(from: dict, value: &tariff, errorResponse: &err)
            }) else {
            return false
        }
        // publicKeys (optional array)
        var keys: [PublicKey]? = []
        guard data.parseOptionalArray("publicKeys", into: &keys, errorResponse: &errorResponse,
            using: { dict, key, err in
                PublicKey.parse(from: dict, value: &key, errorResponse: &err)
            }) else {
            return false
        }
        // instantiate
        value = EMobilityProvider(
            id:               id,
            context:          contextValue,
            description:      descriptionValue,
            chargingTariffs:  tariffs ?? [],
            publicKeys:       keys    ?? []
        )
        errorResponse = nil
        return true
    }
}
