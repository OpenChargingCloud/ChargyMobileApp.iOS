//
//  Manufacturer.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class Manufacturer: Codable {
    
    var context:          String?
    var name:             String
    var description:      I18NString?
    var contact:          Contact?
    var support:          Support?
    var privacyContact:   PrivacyContact?
    var geoLocation:      GeoLocation?
    var publicKeys:       [PublicKey]?

}
