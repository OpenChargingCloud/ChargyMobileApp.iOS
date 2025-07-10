//
//  Signature.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class Signature: Codable {
    
    public private(set) var publicKey:    String?
    public private(set) var signature:    String?
                        var validation:   ValidationState?
    
    init(
        publicKey:    String?,
        signature:    String,
        validation:   ValidationState?   = nil
    ) {
        self.publicKey   = publicKey
        self.signature   = signature
        self.validation  = validation
    }
    
}
