//
//  ChargingPool.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class ChargingPool: Identifiable, Codable {
    
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

    
}
