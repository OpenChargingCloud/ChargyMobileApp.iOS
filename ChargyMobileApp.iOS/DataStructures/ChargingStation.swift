//
//  ChargingStation.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class ChargingStation: Identifiable, JSONSerializable {
    
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

    /// Converts this ChargingStation into a JSON dictionary.
    func toJSON() -> [String: Any] {
        var dict: [String: Any] = ["id": id]
        if let context = context {
            dict["context"] = context
        }
        if let description = description {
            dict["description"] = description.toJSON()
        }
        if let validFrom = validFrom {
            dict["validFrom"] = ISO8601DateFormatter().string(from: validFrom)
        }
        if let validTo = validTo {
            dict["validTo"] = ISO8601DateFormatter().string(from: validTo)
        }
        if let manufacturer = manufacturer {
            dict["manufacturer"] = manufacturer.toJSON()
        }
        if let model = model {
            dict["model"] = model.toJSON()
        }
        if let serialNumber = serialNumber {
            dict["serialNumber"] = serialNumber
        }
        if let hardware = hardware {
            dict["hardware"] = hardware.toJSON()
        }
        if let firmware = firmware {
            dict["firmware"] = firmware.toJSON()
        }
        if let address = address {
            dict["address"] = address.toJSON()
        }
        if let geo = geoLocation {
            dict["geoLocation"] = geo.toJSON()
        }
        if let tariffs = chargingTariffs {
            dict["chargingTariffs"] = tariffs.map { $0.toJSON() }
        }
        if let pool = chargingPool {
            dict["chargingPool"] = pool.toJSON()
        }
        if let poolId = chargingPoolId {
            dict["chargingPoolId"] = poolId
        }
        if let evses = evses {
            dict["evses"] = evses.map { $0.toJSON() }
        }
        if let evseIds = evseIds {
            dict["evseIds"] = evseIds
        }
        if let meters = energyMeters {
            dict["energyMeters"] = meters.map { $0.toJSON() }
        }
        if let keys = publicKeys {
            dict["publicKeys"] = keys.map { $0.toJSON() }
        }
        return dict
    }

    /// Parses a ChargingStation from a JSON dictionary.
    static func parse(
        from data: [String: Any],
        value: inout ChargingStation?,
        errorResponse: inout String?
    ) -> Bool {
        // id (mandatory)
        var idValue: String?
        guard data.parseMandatoryString("id", value: &idValue, errorResponse: &errorResponse),
              let id = idValue else {
            return false
        }
        // optional string fields
        let contextValue    = data["context"] as? String
        // optional I18NString
        var descValue: I18NString?
        guard data.parseOptionalI18NString("description", value: &descValue, errorResponse: &errorResponse) else {
            return false
        }
        // optional dates
        var fromValue: Date?
        guard data.parseOptionalDate("validFrom", value: &fromValue, errorResponse: &errorResponse) else {
            return false
        }
        var toValue: Date?
        guard data.parseOptionalDate("validTo", value: &toValue, errorResponse: &errorResponse) else {
            return false
        }
        // nested objects
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
        // simple string
        let serialValue = data["serialNumber"] as? String
        // nested objects
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
        // location and address
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
        // arrays
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
        // pool and IDs
        var poolValue: ChargingPool?
        if let raw = data["chargingPool"] as? [String: Any] {
            guard ChargingPool.parse(from: raw, value: &poolValue, errorResponse: &errorResponse) else {
                return false
            }
        }
        let poolIdValue = data["chargingPoolId"] as? String
        let evseIdsValue = data["evseIds"] as? [String]
        // instantiate
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
            chargingPool: poolValue,
            chargingPoolId: poolIdValue,
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

