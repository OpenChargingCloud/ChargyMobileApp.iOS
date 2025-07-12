//
//  Support.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 09.07.25.
//

import Foundation

class Support: JSONSerializable {

    var hotline:             String?
    var email:               String
    var web:                 String?
    var mediationServices:   [MediationService]?
    var publicKeys:          [PublicKey]

    init(
        hotline: String? = nil,
        email: String,
        web: String? = nil,
        mediationServices: [MediationService]? = nil,
        publicKeys: [PublicKey]
    ) {
        self.hotline            = hotline
        self.email              = email
        self.web                = web
        self.mediationServices  = mediationServices
        self.publicKeys         = publicKeys
    }

    func toJSON() -> [String: Any] {
        var dict: [String: Any] = [
            "email": email
        ]
        if let hotline = hotline {
            dict["hotline"] = hotline
        }
        if let web = web {
            dict["web"] = web
        }
        if let services = mediationServices {
            dict["mediationServices"] = services.map { $0.toJSON() }
        }
        if !publicKeys.isEmpty {
            dict["publicKeys"] = publicKeys.map { $0.toJSON() }
        }
        return dict
    }

    static func parse(
        from data: [String: Any],
        value: inout Support?,
        errorResponse: inout String?
    ) -> Bool {
        // hotline (optional)
        var hotlineValue: String?
        _ = data.parseOptionalString("hotline", value: &hotlineValue, errorResponse: &errorResponse)

        // email (mandatory)
        var emailValue: String?
        guard data.parseMandatoryString("email", value: &emailValue, errorResponse: &errorResponse),
              let email = emailValue else {
            return false
        }

        // web (optional)
        var webValue: String?
        _ = data.parseOptionalString("web", value: &webValue, errorResponse: &errorResponse)

        // mediationServices (optional array)
        var services: [MediationService]? = []
        guard data.parseOptionalArray(
            "mediationServices",
            into: &services,
            errorResponse: &errorResponse,
            using: { dict, svc, err in
                MediationService.parse(from: dict, value: &svc, errorResponse: &err)
            }
        ) else {
            return false
        }

        // publicKeys (mandatory array)
        var keys: [PublicKey] = []
        guard data.parseMandatoryArray(
            "publicKeys",
            into: &keys,
            errorResponse: &errorResponse,
            using: { dict, key, err in
                PublicKey.parse(from: dict, value: &key, errorResponse: &err)
            }
        ) else {
            return false
        }

        // Instantiate
        value = Support(
            hotline: hotlineValue,
            email: email,
            web: webValue,
            mediationServices: services,
            publicKeys: keys
        )
        errorResponse = nil
        return true
    }
}
