//
//  Signature.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class Signature: JSONSerializable {
    
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
    
    /// Converts this Signature into a JSON-friendly dictionary.
    func toJSON() -> [String: Any] {
        var dict: [String: Any] = ["signature": signature!]
        if let publicKey = publicKey {
            dict["publicKey"] = publicKey
        }
        if let validation = validation {
            dict["validation"] = validation.rawValue
        }
        return dict
    }
    
    /// Parses a Signature from a JSON dictionary.
    static func parse(
        from data: [String: Any],
        value: inout Signature?,
        errorResponse: inout String?
    ) -> Bool {
        // publicKey (optional)
        var pk: String?
        _ = data.parseOptionalString("publicKey", value: &pk, errorResponse: &errorResponse)
        // signature (mandatory)
        var sig: String?
        guard data.parseMandatoryString("signature", value: &sig, errorResponse: &errorResponse),
              let signature = sig else {
            return false
        }
        // validation (optional)
        var valString: String?
        _ = data.parseOptionalString("validation", value: &valString, errorResponse: &errorResponse)
        let validation = valString.flatMap { ValidationState(rawValue: $0) }

        // Instantiate
        value = Signature(publicKey: pk, signature: signature, validation: validation)
        errorResponse = nil
        return true
    }
    
}
