//
//  Contact.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class Contact: Codable {
    
    var email:        String
    var web:          String
    var logoURL:      URL?
    var address:      Address?
    var publicKeys:   [PublicKey]

}
