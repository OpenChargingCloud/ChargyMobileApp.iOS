//
//  Contract.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class Contract: Codable {
    
    var id:            String
    var context:       String?
    var description:   I18NString?
    var type:          String?
    var username:      String?
    var email:         String?
    
}
