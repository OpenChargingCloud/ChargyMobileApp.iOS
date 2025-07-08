//
//  EnergyMeter.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class EnergyMeter: Identifiable, Codable {
    
    var originalJSONString:  String?
    
    var id:                  UUID?
    var manufacturer:        String?
    var type:                String?
    var serialNumber:        String?
    var hardwareVersion:     String?
    var firmwareVersion:     String?
    var publicKey:           String?
        
    var signatures:          [Signature]?
    var validation:          ValidationState?
    
}
