//
//  ChargingStation.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class ChargingStation: Identifiable,
                       JSONSerializable {
    
    var originalJSONString:   String?
    
    var id:                   String
    var context:              String?
    var description:          I18NString?
    var validFrom:            Date?          // This information is valid from...
    var validTo:              Date?          // This information is valid to...
    var manufacturer:         Manufacturer?
    var model:                DeviceModel?
    var serialNumber:         String?
    var hardware:             Hardware?
    var firmware:             Firmware?
    
    var address:              Address?
    var geoLocation:          GeoLocation?   // Might be more exact than address.geoLocation!

    var chargingTariffs:      [ChargingTariff]?
    
    var chargingPool:         ChargingPool?
    var chargingPoolId:       String?
    var evses:                [EVSE]?
    var evseIds:              [String]?
    var energyMeters:         [EnergyMeter]? // EnergyMeters that are not EVSE specific, e.g. the Uplink Energy Meter!
    var publicKeys:           [PublicKey]?   // ChargingStation public keys

    /// Designated initializer
    init(
        id: String,
        context: String? = nil,
        description: I18NString? = nil,
        validFrom: Date? = nil,
        validTo: Date? = nil,
        manufacturer: Manufacturer? = nil,
        model: DeviceModel? = nil,
        serialNumber: String? = nil,
        hardware: Hardware? = nil,
        firmware: Firmware? = nil,
        address: Address? = nil,
        geoLocation: GeoLocation? = nil,
        chargingTariffs: [ChargingTariff]? = nil,
        chargingPool: ChargingPool? = nil,
        chargingPoolId: String? = nil,
        evses: [EVSE]? = nil,
        evseIds: [String]? = nil,
        energyMeters: [EnergyMeter]? = nil,
        publicKeys: [PublicKey]? = nil,
        originalJSONString: String? = nil
    ) {
        self.id                   = id
        self.context              = context
        self.description          = description
        self.validFrom            = validFrom
        self.validTo              = validTo
        self.manufacturer         = manufacturer
        self.model                = model
        self.serialNumber         = serialNumber
        self.hardware             = hardware
        self.firmware             = firmware
        self.address              = address
        self.geoLocation          = geoLocation
        self.chargingTariffs      = chargingTariffs
        self.chargingPool         = chargingPool
        self.chargingPoolId       = chargingPoolId
        self.evses                = evses
        self.evseIds              = evseIds
        self.energyMeters         = energyMeters
        self.publicKeys           = publicKeys
        self.originalJSONString   = originalJSONString
    }

    func toJSON() -> [String: Any] {
        
        var json: [String: Any] = ["@id": id]
        if let context = context {
            json["context"] = context
        }
        if let description = description {
            json["description"] = description.toJSON()
        }
        if let validFrom = validFrom {
            json["validFrom"] = ISO8601DateFormatter().string(from: validFrom)
        }
        if let validTo = validTo {
            json["validTo"] = ISO8601DateFormatter().string(from: validTo)
        }
        if let manufacturer = manufacturer {
            json["manufacturer"] = manufacturer.toJSON()
        }
        if let model = model {
            json["model"] = model.toJSON()
        }
        if let serialNumber = serialNumber {
            json["serialNumber"] = serialNumber
        }
        if let hardware = hardware {
            json["hardware"] = hardware.toJSON()
        }
        if let firmware = firmware {
            json["firmware"] = firmware.toJSON()
        }
        if let address = address {
            json["address"] = address.toJSON()
        }
        if let geo = geoLocation {
            json["geoLocation"] = geo.toJSON()
        }
        if let tariffs = chargingTariffs {
            json["chargingTariffs"] = tariffs.map { $0.toJSON() }
        }
        if let pool = chargingPool {
            json["chargingPool"] = pool.toJSON()
        }
        if let poolId = chargingPoolId {
            json["chargingPoolId"] = poolId
        }
        if let evses = evses {
            json["evses"] = evses.map { $0.toJSON() }
        }
        if let evseIds = evseIds {
            json["evseIds"] = evseIds
        }
        if let meters = energyMeters {
            json["energyMeters"] = meters.map { $0.toJSON() }
        }
        if let keys = publicKeys {
            json["publicKeys"] = keys.map { $0.toJSON() }
        }
        
        return json
        
    }

    static func parse(
        from data:      [String: Any],
        value:          inout ChargingStation?,
        errorResponse:  inout String?
    ) -> Bool {

        var idValue: String?
        guard data.parseMandatoryString("@id", value: &idValue, errorResponse: &errorResponse),
              let id = idValue else {
            return false
        }

        let contextValue    = data["context"] as? String

        var descValue: I18NString?
        if data.parseOptionalI18NString("description", value: &descValue, errorResponse: &errorResponse) {
            if (errorResponse != nil)
            {
                return false
            }
        }

        var fromValue: Date?
        if data.parseOptionalDate("validFrom", value: &fromValue, errorResponse: &errorResponse) {
            if (errorResponse != nil)
            {
                return false
            }
        }

        var toValue: Date?
        if data.parseOptionalDate("validTo", value: &toValue, errorResponse: &errorResponse) {
            if (errorResponse != nil)
            {
                return false
            }
        }

        var manuValue: Manufacturer?
        if let raw = data["manufacturer"] as? [String: Any] {
            guard Manufacturer.parse(from: raw, value: &manuValue, errorResponse: &errorResponse) else {
                return false
            }
        }

        var modelValue: DeviceModel?
        if let raw = data["model"] as? [String: Any] {
            guard DeviceModel.parse(from: raw, value: &modelValue, errorResponse: &errorResponse) else {
                return false
            }
        }

        let serialValue = data["serialNumber"] as? String

        var hardwareValue: Hardware?
        if let raw = data["hardware"] as? [String: Any] {
            guard Hardware.parse(from: raw, value: &hardwareValue, errorResponse: &errorResponse) else {
                return false
            }
        }

        var firmwareValue: Firmware?
        if let raw = data["firmware"] as? [String: Any] {
            guard Firmware.parse(from: raw, value: &firmwareValue, errorResponse: &errorResponse) else {
                return false
            }
        }

        var addressValue: Address?
        if let raw = data["address"] as? [String: Any] {
            guard Address.parse(from: raw, value: &addressValue, errorResponse: &errorResponse) else {
                return false
            }
        }

        var geoValue: GeoLocation?
        if let raw = data["geoLocation"] as? [String: Any] {
            guard GeoLocation.parse(from: raw, value: &geoValue, errorResponse: &errorResponse) else {
                return false
            }
        }

        var tariffs: [ChargingTariff]? = []
        guard data.parseOptionalArray("chargingTariffs", into: &tariffs, errorResponse: &errorResponse,
            using: { dict, t, err in ChargingTariff.parse(from: dict, value: &t, errorResponse: &err) }
        ) else { return false }

        var evseList: [EVSE]? = []
        guard data.parseOptionalArray("evses", into: &evseList, errorResponse: &errorResponse,
            using: { dict, e, err in EVSE.parse(from: dict, value: &e, errorResponse: &err) }
        ) else { return false }

        var meterList: [EnergyMeter]? = []
        guard data.parseOptionalArray("energyMeters", into: &meterList, errorResponse: &errorResponse,
            using: { dict, m, err in EnergyMeter.parse(from: dict, value: &m, errorResponse: &err) }
        ) else { return false }

        var keyList: [PublicKey]? = []
        guard data.parseOptionalArray("publicKeys", into: &keyList, errorResponse: &errorResponse,
            using: { dict, k, err in PublicKey.parse(from: dict, value: &k, errorResponse: &err) }
        ) else { return false }

        let evseIdsValue = data["evseIds"] as? [String]

        value = ChargingStation(
                    id: id,
                    context: contextValue,
                    description: descValue,
                    validFrom: fromValue,
                    validTo: toValue,
                    manufacturer: manuValue,
                    model: modelValue,
                    serialNumber: serialValue,
                    hardware: hardwareValue,
                    firmware: firmwareValue,
                    address: addressValue,
                    geoLocation: geoValue,
                    chargingTariffs: tariffs,
                    evses: evseList,
                    evseIds: evseIdsValue,
                    energyMeters: meterList,
                    publicKeys: keyList,
                    originalJSONString: nil
                )
        
        errorResponse = nil
        return true

    }

}

