//
//  Support.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 09.07.25.
//

import Foundation

class Support: JSONSerializable {

    var email:               String
    var hotline:             String?
    var web:                 String?
    var mediationServices:  [MediationService]?
    var publicKeys:         [PublicKey]?

    init(
        email:               String,
        hotline:             String?               = nil,
        web:                 String?               = nil,
        mediationServices:   [MediationService]?   = nil,
        publicKeys:          [PublicKey]?          = nil
    ) {
        self.hotline            = hotline
        self.email              = email
        self.web                = web
        self.mediationServices  = mediationServices
        self.publicKeys         = publicKeys
    }

    func toJSON() -> [String: Any] {
        var json: [String: Any] = [
            "email": email
        ]
        if let web = web {
            json["web"] = web
        }
        if let hotline = hotline {
            json["hotline"] = hotline
        }
        if let services = mediationServices {
            json["mediationServices"] = services.map { $0.toJSON() }
        }
        if let keys = publicKeys, !keys.isEmpty {
            json["publicKeys"] = keys.map { $0.toJSON() }
        }
        return json
    }

    static func parse(
        from data:      [String: Any],
        value:          inout Support?,
        errorResponse:  inout String?
    ) -> Bool {

        var emailValue: String?
        guard data.parseMandatoryString("email", value: &emailValue, errorResponse: &errorResponse),
              let email = emailValue else {
            return false
        }

        var hotlineValue: String?
        _ = data.parseOptionalString("hotline", value: &hotlineValue, errorResponse: &errorResponse)

        var webValue: String?
        _ = data.parseOptionalString("web", value: &webValue, errorResponse: &errorResponse)

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

        value = Support(
                    email:              email,
                    hotline:            hotlineValue,
                    web:                webValue,
                    mediationServices:  services,
                    publicKeys:         publicKeys
                )
        
        errorResponse = nil
        return true
        
    }
    
}
