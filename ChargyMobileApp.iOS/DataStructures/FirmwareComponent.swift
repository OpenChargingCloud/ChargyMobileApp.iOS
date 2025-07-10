//
//  FirmwareComponent.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class FirmwareComponent: Codable {
    
    var id:            String
    var context:       String?
    var description:   I18NString?
    var version:       String
    var releaseDate:   Date?
    var checksum:      String?
    var url:           URL?

}
