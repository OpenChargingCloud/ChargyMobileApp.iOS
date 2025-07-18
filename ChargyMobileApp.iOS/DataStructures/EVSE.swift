//
//  EVSE.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class EVSE: Identifiable,
            JSONSerializable {
        
    var id:                   String?
    var context:              String?
    var description:          I18NString?
    var chargingTariffs:      [ChargingTariff]  = []
    var energyMeters:         [EnergyMeter]     = []
    var connectors:           [Connector]
    var publicKeys:           [PublicKey]       = []

    var chargingStation:      ChargingStation?
    var chargingStationId:    String?

    init(
        id: String? = nil,
        context: String? = nil,
        description: I18NString? = nil,
        chargingTariffs: [ChargingTariff] = [],
        energyMeters: [EnergyMeter] = [],
        connectors: [Connector] = [],
        publicKeys: [PublicKey] = [],
        chargingStation: ChargingStation? = nil,
        chargingStationId: String? = nil
    ) {
        self.id = id
        self.context = context
        self.description = description
        self.chargingTariffs = chargingTariffs
        self.energyMeters = energyMeters
        self.connectors = connectors
        self.publicKeys = publicKeys
        self.chargingStation = chargingStation
        self.chargingStationId = chargingStationId
    }

    func toJSON() -> [String: Any] {

        var json: [String: Any] = [:]
        
        if let id = id {
            json["@id"] = id
        }
        if let context = context {
            json["context"] = context
        }
        if let description = description {
            json["description"] = description.toJSON()
        }
        if !chargingTariffs.isEmpty {
            json["chargingTariffs"] = chargingTariffs.map { $0.toJSON() }
        }
        if !energyMeters.isEmpty {
            json["energyMeters"] = energyMeters.map { $0.toJSON() }
        }
        if !connectors.isEmpty {
            json["connectors"] = connectors.map { $0.toJSON() }
        }
        if !publicKeys.isEmpty {
            json["publicKeys"] = publicKeys.map { $0.toJSON() }
        }
        if let station = chargingStation {
            json["chargingStation"] = station.toJSON()
        }
        if let stationId = chargingStationId {
            json["chargingStationId"] = stationId
        }
        
        return json
        
    }

    static func parse(
        from data:      [String: Any],
        value:          inout EVSE?,
        errorResponse:  inout String?
    ) -> Bool {

        var idValue: String?
        _ = data.parseOptionalString("@id", value: &idValue, errorResponse: &errorResponse)

        var contextValue: String?
        _ = data.parseOptionalString("context", value: &contextValue, errorResponse: &errorResponse)

        var descValue: I18NString?
        guard data.parseOptionalI18NString("description", value: &descValue, errorResponse: &errorResponse) else {
            return false
        }

        var tariffs: [ChargingTariff]? = []
        guard data.parseOptionalArray("chargingTariffs", into: &tariffs, errorResponse: &errorResponse,
                                      using: { dict, tariff, err in
                                          ChargingTariff.parse(from: dict, value: &tariff, errorResponse: &err)
                                      }) else {
            return false
        }

        var meters: [EnergyMeter]? = []
        guard data.parseOptionalArray("energyMeters", into: &meters, errorResponse: &errorResponse,
                                      using: { dict, meter, err in
                                          EnergyMeter.parse(from: dict, value: &meter, errorResponse: &err)
                                      }) else {
            return false
        }

        var conns: [Connector] = []
        guard data.parseMandatoryArray("connectors", into: &conns, errorResponse: &errorResponse,
                                       using: { dict, conn, err in
                                           Connector.parse(from: dict, value: &conn, errorResponse: &err)
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

        value = EVSE(
                    id: idValue,
                    context: contextValue,
                    description: descValue,
                    chargingTariffs: tariffs ?? [],
                    energyMeters: meters ?? [],
                    connectors: conns,
                    publicKeys: keys ?? []
                )

        errorResponse = nil
        return true

    }
    
}
