//
//  ChargingStationOperator.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class ChargingStationOperator: Identifiable {
    
    var id:                  String
    var context:             String?
    var description:         I18NString?
//    subCSOIds?:                      Array<string>;
    var contact:             Contact?
    var support:             Support?
    var privacyContact:      PrivacyContact?;
    var geoLocation:         GeoLocation?;
    var chargingPools:       [ChargingPool]     = []
    var chargingStations:    [ChargingStation]  = []
    var EVSEs:               [EVSE]             = []
    var chargingTariffs:     [ChargingTariff]   = []
    var parkingTariffs:      [ParkingTariff]    = []
    var publicKeys:          [PublicKey]        = []

    init(
        id: String,
        context: String? = nil,
        description: I18NString? = nil,
        contact: Contact? = nil,
        support: Support? = nil,
        privacyContact: PrivacyContact? = nil,
        geoLocation: GeoLocation? = nil,
        chargingPools: [ChargingPool] = [],
        chargingStations: [ChargingStation] = [],
        EVSEs: [EVSE] = [],
        chargingTariffs: [ChargingTariff] = [],
        parkingTariffs: [ParkingTariff] = [],
        publicKeys: [PublicKey] = []
    ) {
        self.id                = id
        self.context           = context
        self.description       = description
        self.contact           = contact
        self.support           = support
        self.privacyContact    = privacyContact
        self.geoLocation       = geoLocation
        self.chargingPools     = chargingPools
        self.chargingStations  = chargingStations
        self.EVSEs             = EVSEs
        self.chargingTariffs   = chargingTariffs
        self.parkingTariffs    = parkingTariffs
        self.publicKeys        = publicKeys
    }

    func toJSON() -> [String: Any] {
        
        var json: [String: Any] = [
            "@id": id
        ]
        
        if let context = context {
            json["context"] = context
        }
        if let description = description {
            json["description"] = description.toJSON()
        }
        if let contact = contact {
            json["contact"] = contact.toJSON()
        }
        if let support = support {
            json["support"] = support.toJSON()
        }
        if let privacyContact = privacyContact {
            json["privacyContact"] = privacyContact.toJSON()
        }
        if let geoLocation = geoLocation {
            json["geoLocation"] = geoLocation.toJSON()
        }
        if !chargingPools.isEmpty {
            json["chargingPools"] = chargingPools.map { $0.toJSON() }
        }
        if !chargingStations.isEmpty {
            json["chargingStations"] = chargingStations.map { $0.toJSON() }
        }
        if !EVSEs.isEmpty {
            json["EVSEs"] = EVSEs.map { $0.toJSON() }
        }
        if !chargingTariffs.isEmpty {
            json["chargingTariffs"] = chargingTariffs.map { $0.toJSON() }
        }
        if !parkingTariffs.isEmpty {
            json["parkingTariffs"] = parkingTariffs.map { $0.toJSON() }
        }
        if !publicKeys.isEmpty {
            json["publicKeys"] = publicKeys.map { $0.toJSON() }
        }
        
        return json
        
    }

    static func parse(
        from data:            [String: Any],
        value:          inout ChargingStationOperator?,
        errorResponse:  inout String?
    ) -> Bool {

        var idValue: String?
        guard data.parseMandatoryString("@id", value: &idValue, errorResponse: &errorResponse),
              let id = idValue else {
            return false
        }
        
        let contextValue = data["context"] as? String

        var descValue: I18NString?
        if data.parseOptionalI18NString("description", value: &descValue, errorResponse: &errorResponse) {
            if (errorResponse != nil)
            {
                return false
            }
        }

        var contactValue: Contact?
        if let raw = data["contact"] as? [String: Any] {
            guard Contact.parse(from: raw, value: &contactValue, errorResponse: &errorResponse) else {
                return false
            }
        }

        var supportValue: Support?
        if let raw = data["support"] as? [String: Any] {
            guard Support.parse(from: raw, value: &supportValue, errorResponse: &errorResponse) else {
                return false
            }
        }

        var privacyValue: PrivacyContact?
        if let raw = data["privacyContact"] as? [String: Any] {
            guard PrivacyContact.parse(from: raw, value: &privacyValue, errorResponse: &errorResponse) else {
                return false
            }
        }

        var geoValue: GeoLocation?
        if data.parseOptionalJSON("geoLocation",
                                  value: &geoValue,
                                  errorResponse: &errorResponse,
                                  using: { dict, val, err in GeoLocation.parse(from: dict, value: &val, errorResponse: &err)
        }) {
            if errorResponse != nil {
                return false
            }
        }
        
        var pools: [ChargingPool]? = []
        guard data.parseOptionalArray("chargingPools", into: &pools, errorResponse: &errorResponse,
            using: { dict, pool, err in
                ChargingPool.parse(from: dict, value: &pool, errorResponse: &err)
            }) else {
            return false
        }

        var stations: [ChargingStation]? = []
        guard data.parseOptionalArray("chargingStations", into: &stations, errorResponse: &errorResponse,
            using: { dict, st, err in
                ChargingStation.parse(from: dict, value: &st, errorResponse: &err)
            }) else {
            return false
        }

        var evses: [EVSE]? = []
        guard data.parseOptionalArray("EVSEs", into: &evses, errorResponse: &errorResponse,
            using: { dict, evse, err in
                EVSE.parse(from: dict, value: &evse, errorResponse: &err)
            }) else {
            return false
        }

        var tariffs: [ChargingTariff]? = []
        guard data.parseOptionalArray("chargingTariffs", into: &tariffs, errorResponse: &errorResponse,
            using: { dict, tariff, err in
                ChargingTariff.parse(from: dict, value: &tariff, errorResponse: &err)
            }) else {
            return false
        }

        var parking: [ParkingTariff]? = []
        guard data.parseOptionalArray("parkingTariffs", into: &parking, errorResponse: &errorResponse,
            using: { dict, pt, err in
                ParkingTariff.parse(from: dict, value: &pt, errorResponse: &err)
            }) else {
            return false
        }

        var keys: [PublicKey]? = []
        guard data.parseOptionalArray("publicKeys", into: &keys, errorResponse: &errorResponse,
            using: { dict, key, err in
                PublicKey.parse(from: dict, value: &key, errorResponse: &err)
            }) else {
            return false
        }

        value = ChargingStationOperator(
                    id:                id,
                    context:           contextValue,
                    description:       descValue,
                    contact:           contactValue,
                    support:           supportValue,
                    privacyContact:    privacyValue,
                    geoLocation:       geoValue,
                    chargingPools:     pools    ?? [],
                    chargingStations:  stations ?? [],
                    EVSEs:             evses    ?? [],
                    chargingTariffs:   tariffs  ?? [],
                    parkingTariffs:    parking  ?? [],
                    publicKeys:        keys     ?? []
                )
        
        errorResponse = nil
        return true

    }

}
