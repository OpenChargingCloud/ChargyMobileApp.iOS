//
//  SignatureInfos.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 09.07.25.
//

import Foundation

class SignatureInfos: Codable {

    var hash:            CryptoHashAlgorithms?  //|String
    var hashTrucation:   UInt8
    var algorithm:       CryptoAlgorithms?      //|String
    var curve:           ECCurves?              //|String
    var format:          SignatureFormats?      //|String
    var encoding:        Encoding?              //|String

}
