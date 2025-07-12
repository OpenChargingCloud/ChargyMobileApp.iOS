//
//  ChargingPool.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class ChargingPool: Identifiable {
    
    var originalJSONString:        String?
    
    var id:                        String
    var context:                   String?
    var description:               I18NString?
    var address:                   Address?
    var geoLocation:               GeoLocation? // Might be more exact than address.geoLocation!
    var chargingStationOperator:   ChargingStationOperator?
    var chargingStations:          [ChargingStation]  = []
    var chargingTariffs:           [ChargingTariff]   = []
    var energyMeters:              [EnergyMeter]      = [] // EnergyMeters that are not Charging Station specific, e.g. an Energy Meter at the grid connection point!
    //var publicKeys:                [PublicKey]?
    
    /// Designated initializer
    init(
        id: String,
        context: String? = nil,
        description: I18NString? = nil,
        address: Address? = nil,
        geoLocation: GeoLocation? = nil,
        chargingStationOperator:  ChargingStationOperator?   = nil,
        chargingStations:         [ChargingStation]?         = nil,
        chargingTariffs:          [ChargingTariff]? = nil,
        energyMeters:             [EnergyMeter]? = nil,
        originalJSONString: String? = nil
    ) {
        self.originalJSONString           = originalJSONString
        self.id                           = id
        self.context                      = context
        self.description                  = description
        self.address                      = address
        self.geoLocation                  = geoLocation
        self.chargingStationOperator      = chargingStationOperator
        self.chargingStations             = chargingStations ?? []
        self.chargingTariffs              = chargingTariffs ?? []
        self.energyMeters                 = energyMeters ?? []
    }
    
    /// Converts this ChargingPool into a JSON dictionary.
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
        if let address = address {
            dict["address"] = address.toJSON()
        }
        if let geo = geoLocation {
            dict["geoLocation"] = geo.toJSON()
        }
        if let op = chargingStationOperator {
            dict["chargingStationOperator"] = op.toJSON()
        }
        dict["chargingStations"] = chargingStations.map { $0.toJSON() }
        dict["chargingTariffs"]  = chargingTariffs.map { $0.toJSON() }
        dict["energyMeters"]     = energyMeters.map { $0.toJSON() }
        return dict
    }
    
    /// Parses a ChargingPool from a JSON dictionary.
    static func parse(
        from data:      [String: Any],
        value:          inout ChargingPool?,
        errorResponse:  inout String?
    ) -> Bool {
        
        var idValue: String?
        guard data.parseMandatoryString("id", value: &idValue, errorResponse: &errorResponse),
              let id = idValue else {
            return false
        }
        
        var contextValue: String?
        if let raw = data["context"] as? String {
            contextValue = raw
        }
        
        var descriptionValue: I18NString?
        guard data.parseOptionalI18NString("description", value: &descriptionValue, errorResponse: &errorResponse) else {
            return false
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
        // chargingStationOperator (optional object)
        var operatorValue: ChargingStationOperator?
        if let raw = data["chargingStationOperator"] as? [String: Any] {
            guard ChargingStationOperator.parse(from: raw, value: &operatorValue, errorResponse: &errorResponse) else {
                return false
            }
        }
        
        var stations: [ChargingStation] = []
        guard data.parseMandatoryArray("chargingStations",
                                       into: &stations,
                                       errorResponse: &errorResponse,
                                       using: { dict, station, err in
            ChargingStation.parse(from: dict, value: &station, errorResponse: &err)
        }) else {
            return false
        }
        
        var tariffs: [ChargingTariff] = []
        guard data.parseMandatoryArray("chargingTariffs",
                                       into: &tariffs,
                                       errorResponse: &errorResponse,
                                       using: { dict, tariff, err in
            ChargingTariff.parse(from: dict, value: &tariff, errorResponse: &err)
        }) else {
            return false
        }
        
        var meters: [EnergyMeter] = []
        guard data.parseMandatoryArray("energyMeters",
                                       into: &meters,
                                       errorResponse: &errorResponse,
                                       using: { dict, meter, err in
            EnergyMeter.parse(from: dict, value: &meter, errorResponse: &err)
        }) else {
            return false
        }
        
        value = ChargingPool(
            id: id,
            context: contextValue,
            description: descriptionValue,
            address: addressValue,
            geoLocation: geoValue,
            chargingStationOperator: operatorValue,
            chargingStations: stations,
            chargingTariffs: tariffs,
            energyMeters: meters,
            originalJSONString: nil
        )
        
        errorResponse = nil
        return true
        
    }
    
}
