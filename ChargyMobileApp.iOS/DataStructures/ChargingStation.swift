//
//  ChargingStation.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class ChargingStation: Identifiable, Codable {
    
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

}

//legalCompliance?:           ILegalCompliance;
//chargingStationOperator?:   IChargingStationOperator;
