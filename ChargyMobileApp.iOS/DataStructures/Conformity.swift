//
//  Conformity.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class Conformity: Codable {
    
    var certificateId:        String?
    var url:                  String?
    var notBefore:            String?
    var notAfter:             String?
    var officialSoftware:     [TransparencySoftware]  = []
    var compatibleSoftware:   [TransparencySoftware]  = []
    var freeText:             String?
    
}
