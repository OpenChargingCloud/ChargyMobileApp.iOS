//
//  EVSE.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class EVSE: Identifiable, Codable {
    
    var originalJSONString:  String?
    
    var id:                  UUID?
    var connectors:          [Connector]
    
}
