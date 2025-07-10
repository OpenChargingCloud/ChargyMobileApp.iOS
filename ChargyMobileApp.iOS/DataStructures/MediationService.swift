//
//  MediationService.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 09.07.25.
//

import Foundation

class MediationService: Codable {
    
    var id:            String
    var context:       String?
    var description:   I18NString?
    var publicKeys:    [PublicKey]  = []

}
