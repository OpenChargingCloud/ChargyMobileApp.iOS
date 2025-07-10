//
//  EnergyMeter.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class EnergyMeter: Identifiable, Codable {
    
    var originalJSONString:  String?
    
    var id:                  String
    var context:             String?
    var description:         I18NString?
    var manufacturer:        Manufacturer?
    var model:               DeviceModel?
    var serialNumber:        String?
    var hardwareVersion:     String?
    var firmwareVersion:     String?
    var legalCompliance:     LegalCompliance?
    var signatureFormat:     String?
    var signatureInfos:      SignatureInfos?
    var publicKey:           String?

    var chargingPool:        ChargingPool?
    var chargingPoolId:      String?
    var chargingStation:     ChargingStation?
    var chargingStationId:   String?
    var EVSE:                EVSE?
    var EVSEId:              String?
    
}
