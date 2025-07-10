//
//  LegalCompliance.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class LegalCompliance: Codable {
    
    var conformity:    [Conformity]?
    var calibration:   [Calibration]?
    var url:           String?
    var freetext:      String?

}

