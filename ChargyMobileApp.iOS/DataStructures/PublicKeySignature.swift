//
//  PublicKeysignature.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class PublicKeySignature: Codable {
    
    var id:          String
    var context:     String
    var timestamp:   String
    var keyUsage:    [String]?
    
}
