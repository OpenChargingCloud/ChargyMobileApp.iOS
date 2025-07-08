//
//  Address.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class Address: Codable {
    
    var context:       String
    var city:          String
    var Street:        String?
    var houseNumber:   String?
    var floorLevel:    String?
    var postalCode:    String?
    var country:       String? // Code?
    var comment:       I18NString?
}
