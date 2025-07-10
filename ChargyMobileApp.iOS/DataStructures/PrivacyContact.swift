//
//  PrivacyContact.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 09.07.25.
//

import Foundation

class PrivacyContact: Codable {
    
    var contact:      String
    var email:        String
    var web:          String
    var publicKeys:   [PublicKey]
    
}
