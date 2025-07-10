//
//  EMobilityProvider.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class EMobilityProvider: Codable {
    
    var id:                String
    var context:           String?
    var description:       I18NString?
    var chargingTariffs:   [ChargingTariff]  = []
    var publicKeys:        [PublicKey]       = []

}
