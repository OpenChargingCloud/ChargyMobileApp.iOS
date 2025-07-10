//
//  Firmware.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class Firmware: Codable {
    
    var version:       String
    var context:       String?
    var releaseDate:   Date?
    var checksum:      String?
    var url:           URL?

}
