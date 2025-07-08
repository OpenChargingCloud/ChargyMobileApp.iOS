//
//  FirmwareInfo.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//


import Foundation

class FirmwareInfo: Codable {
    
    var id:         String
    var checksum:   String?
    var url:        URL?

}
