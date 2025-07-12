//
//  PrivacyContact.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 09.07.25.
//

import Foundation

class PrivacyContact: JSONSerializable {
    
    var contact:      String
    var email:        String
    var web:          String
    var publicKeys:   [PublicKey]

    init(
        contact: String,
        email: String,
        web: String,
        publicKeys: [PublicKey] = []
    ) {
        self.contact    = contact
        self.email      = email
        self.web        = web
        self.publicKeys = publicKeys
    }

    func toJSON() -> [String: Any] {
        var dict: [String: Any] = [
            "contact": contact,
            "email": email,
            "web": web
        ]
        if !publicKeys.isEmpty {
            dict["publicKeys"] = publicKeys.map { $0.toJSON() }
        }
        return dict
    }

    static func parse(
        from data: [String: Any],
        value: inout PrivacyContact?,
        errorResponse: inout String?
    ) -> Bool {
        // contact (mandatory)
        var contactValue: String?
        guard data.parseMandatoryString("contact", value: &contactValue, errorResponse: &errorResponse),
              let contact = contactValue else {
            return false
        }
        // email (mandatory)
        var emailValue: String?
        guard data.parseMandatoryString("email", value: &emailValue, errorResponse: &errorResponse),
              let email = emailValue else {
            return false
        }
        // web (mandatory)
        var webValue: String?
        guard data.parseMandatoryString("web", value: &webValue, errorResponse: &errorResponse),
              let web = webValue else {
            return false
        }
        // publicKeys (optional array)
        var keys: [PublicKey]? = []
        guard data.parseOptionalArray(
            "publicKeys",
            into: &keys,
            errorResponse: &errorResponse,
            using: { dict, key, err in
                PublicKey.parse(from: dict, value: &key, errorResponse: &err)
            }
        ) else {
            return false
        }
        value = PrivacyContact(
            contact: contact,
            email: email,
            web: web,
            publicKeys: keys ?? []
        )
        errorResponse = nil
        return true
    }
}
