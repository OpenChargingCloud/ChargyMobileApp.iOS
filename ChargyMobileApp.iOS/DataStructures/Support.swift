//
//  Support.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 09.07.25.
//

import Foundation

class Support: Codable {
    
    var hotline:             String?
    var email:               String
    var web:                 String?
    var mediationServices:   [MediationService]?
    var publicKeys:          [PublicKey]

}
