//
//  ChargingStation.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class ChargingStation: Identifiable, Codable {
    
    var originalJSONString:        String?
    
    var id:                        String
    var context:                   String?
    var description:               String? // I18N!
    var manufacturer:              Manufacturer?
    var model:                     IdWithURL?
    var hardwareVersion:           String?
    var firmware:                  FirmwareInfo?
    var serialNumber:              String?
    var address:                   Address?
    var geoLocation:               GeoLocation? // Might be more exact than address.geoLocation!

    var energyMeters:              [EnergyMeter]? // EnergyMeters that are not EVSE specific, e.g. the Uplink Energy Meter!
    
    var chargingTariffs:           [ChargingTariff]?
    
    var chargingPool:              ChargingPool?
    var chargingPoolId:            String?
    var evses:                     [EVSE]
    var evseIds:                   [String]
    
    var publicKeys:                [PublicKey] // ChargingStation public keys

    var validFrom:                 Date?
    var validTo:                   Date?

}

//legalCompliance?:           ILegalCompliance;
//chargingStationOperator?:   IChargingStationOperator;
