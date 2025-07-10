//
//  PublicKey.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class PublicKey: Codable {
    
    //var id:             String
    var context:        String
    //var subject:        String//|any
    var algorithm:      String?//|OIDInfo
    var type:           String?//|OIDInfo
    var format:         PublicKeyFormats?
    var encoding:       Encoding?
    var value:          String
    var signatures:     [PublicKeySignature]?
    //var certainty:      Double?

}
