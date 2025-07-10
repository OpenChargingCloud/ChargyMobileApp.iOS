//
//  ChargingSession.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 07.07.25.
//

import Foundation

class ChargingSession: Identifiable, Codable {
    
    var originalCTR:                String?

    var id:                         String
    var context:                    String?
    var begin:                      Date
    var end:                        Date?
    
    var energy:                     Double?
    var meterValues:                [MeterValue]?

    var signatures:                 [Signature]?
    var validation:                 ValidationState?
    
    
    var chargeTransparencyRecord:   ChargeTransparencyRecord?
    
}
