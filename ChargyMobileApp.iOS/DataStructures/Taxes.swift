//
//  Taxes.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 10.07.25.
//

import Foundation

class Taxes: Codable {
    
    var id:            String
    var context:       String?
    var description:   I18NString?
    var percentage:    Decimal

}
