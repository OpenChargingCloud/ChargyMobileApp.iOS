//
//  MeterValue.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class MeterValue: Identifiable, Codable {
    
    var originalJSONString:  String?
    
    var id:                  UUID?
    var timestamp:           String?
    var value:               Double?
    
    var signatures:          [Signature]?
    var validation:          ValidationState?
    
}
