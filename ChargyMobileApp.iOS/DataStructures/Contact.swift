//
//  Contact.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class Contact {
    
    var email:        String?
    var web:          String?
    var logoURL:      URL?
    var address:      Address?
    var publicKeys:  [PublicKey]

    init(
        email:        String?      = nil,
        web:          String?      = nil,
        logoURL:      URL?         = nil,
        address:      Address?     = nil,
        publicKeys:  [PublicKey]   = []
    ) {
        self.email       = email
        self.web         = web
        self.logoURL     = logoURL
        self.address     = address
        self.publicKeys  = publicKeys
    }

    func toJSON() -> [String: Any] {
        
        var json: [String: Any] = [:]

        if let email = email {
            json["email"] = email
        }
        if let web = web {
            json["web"] = web
        }
        if let logoURL = logoURL {
            json["logoURL"] = logoURL.absoluteString
        }
        if let address = address {
            json["address"] = address.toJSON()
        }
        if !publicKeys.isEmpty {
            json["publicKeys"] = publicKeys.map { $0.toJSON() }
        }

        return json

    }

    static func parse(
        from data:      [String: Any],
        value:          inout Contact?,
        errorResponse:  inout String?
    ) -> Bool {
        
        var emailValue: String?
        _ = data.parseOptionalString("email", value: &emailValue, errorResponse: &errorResponse)

        var webValue: String?
        _ = data.parseOptionalString("web", value: &webValue, errorResponse: &errorResponse)

        var logoString: String?
        if data.parseOptionalString("logoURL", value: &logoString, errorResponse: &errorResponse),
           let urlString = logoString {
            value?.logoURL = URL(string: urlString)
        }

        var addressValue: Address?
        if let raw = data["address"] as? [String: Any] {
            guard Address.parse(from: raw, value: &addressValue, errorResponse: &errorResponse) else {
                return false
            }
        }

        var publicKeys: [PublicKey]? = []
        guard data.parseOptionalArray(
            "publicKeys",
            into: &publicKeys,
            errorResponse: &errorResponse,
            using: { dict, key, err in
                PublicKey.parse(from: dict, value: &key, errorResponse: &err)
            }
        ) else {
            return false
        }

        value = Contact(
                    email:       emailValue,
                    web:         webValue,
                    logoURL:     value?.logoURL,
                    address:     addressValue,
                    publicKeys:  publicKeys ?? []
                )
        
        errorResponse = nil
        return true
        
    }
    
}
