//
//  Signature.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class Signature: Codable {
    var publicKey: String?
    var signature: String?
    var validation: ValidationState?
}
