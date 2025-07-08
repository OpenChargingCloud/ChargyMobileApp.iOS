//
//  PublicKey.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

enum ECCurves: String, Codable {
    case secp192r1   = "secp192r1"
    case secp224k1   = "secp224k1"
    case secp256k1   = "secp256k1"
    case secp256r1   = "secp256r1"
    case secp384r1   = "secp384r1"
    case secp512r1   = "secp512r1"
}

enum Encoding: String, Codable {
    case hex         = "hex"
    case base64      = "base64"
}

enum PublicKeyFormats: String, Codable {
    case DER         = "DER"
    case XY          = "XY"
}

enum SignatureFormats: String, Codable {
    case DER         = "DER"
    case RS          = "RS"
}

enum CryptoAlgorithms: String, Codable {
    case RSA         = "RSA"
    case ECC         = "ECC"
}

enum CryptoHashAlgorithms: String, Codable {
    case SHA256      = "SHA256"
    case SHA384      = "SHA384"
    case SHA512      = "SHA512"
}

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
