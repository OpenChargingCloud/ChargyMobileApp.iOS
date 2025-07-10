//
//  EVSE.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class EVSE: Identifiable, Codable {
    
    var originalJSONString:   String?
    
    var id:                   String?
    var context:              String?
    var description:          I18NString?
    var chargingTariffs:      [ChargingTariff]  = []
    var energyMeters:         [EnergyMeter]     = []
    var connectors:           [Connector]
    var publicKeys:           [PublicKey]       = []

    var chargingStation:      ChargingStation?
    var chargingStationId:    String?

}
