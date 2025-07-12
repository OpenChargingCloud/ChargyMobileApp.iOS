//
//  Conformity.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class Conformity {
    
    var certificateId:        String?
    var url:                  String?
    var notBefore:            String?
    var notAfter:             String?
    var officialSoftware:     [TransparencySoftware]  = []
    var compatibleSoftware:   [TransparencySoftware]  = []
    var freeText:             String?
 

    /// Designated initializer
    init(
        certificateId: String? = nil,
        url: String? = nil,
        notBefore: String? = nil,
        notAfter: String? = nil,
        officialSoftware: [TransparencySoftware] = [],
        compatibleSoftware: [TransparencySoftware] = [],
        freeText: String? = nil
    ) {
        self.certificateId     = certificateId
        self.url               = url
        self.notBefore         = notBefore
        self.notAfter          = notAfter
        self.officialSoftware   = officialSoftware
        self.compatibleSoftware = compatibleSoftware
        self.freeText          = freeText
    }

    /// Converts this Conformity into a JSON dictionary.
    func toJSON() -> [String: Any] {
        var dict: [String: Any] = [:]
        if let certificateId = certificateId {
            dict["certificateId"] = certificateId
        }
        if let url = url {
            dict["url"] = url
        }
        if let notBefore = notBefore {
            dict["notBefore"] = notBefore
        }
        if let notAfter = notAfter {
            dict["notAfter"] = notAfter
        }
        if !officialSoftware.isEmpty {
            dict["officialSoftware"] = officialSoftware.map { $0.toJSON() }
        }
        if !compatibleSoftware.isEmpty {
            dict["compatibleSoftware"] = compatibleSoftware.map { $0.toJSON() }
        }
        if let freeText = freeText {
            dict["freeText"] = freeText
        }
        return dict
    }

    /// Parses a Conformity from a JSON dictionary.
    static func parse(
        from data: [String: Any],
        value: inout Conformity?,
        errorResponse: inout String?
    ) -> Bool {
        // Optional string fields
        var certId: String?
        _ = data.parseOptionalString("certificateId", value: &certId, errorResponse: &errorResponse)
        var urlValue: String?
        _ = data.parseOptionalString("url", value: &urlValue, errorResponse: &errorResponse)
        var beforeValue: String?
        _ = data.parseOptionalString("notBefore", value: &beforeValue, errorResponse: &errorResponse)
        var afterValue: String?
        _ = data.parseOptionalString("notAfter", value: &afterValue, errorResponse: &errorResponse)
        var freeTextValue: String?
        _ = data.parseOptionalString("freeText", value: &freeTextValue, errorResponse: &errorResponse)
        
        // Optional arrays
        var officialArray: [TransparencySoftware]? = []
        guard data.parseOptionalArray(
            "officialSoftware",
            into: &officialArray,
            errorResponse: &errorResponse,
            using: { dict, element, err in
                TransparencySoftware.parse(from: dict, value: &element, errorResponse: &err)
            }
        ) else {
            return false
        }
        var compatibleArray: [TransparencySoftware]? = []
        guard data.parseOptionalArray(
            "compatibleSoftware",
            into: &compatibleArray,
            errorResponse: &errorResponse,
            using: { dict, element, err in
                TransparencySoftware.parse(from: dict, value: &element, errorResponse: &err)
            }
        ) else {
            return false
        }

        // Instantiate
        value = Conformity(
            certificateId: certId,
            url: urlValue,
            notBefore: beforeValue,
            notAfter: afterValue,
            officialSoftware: officialArray ?? [],
            compatibleSoftware: compatibleArray ?? [],
            freeText: freeTextValue
        )
        errorResponse = nil
        return true
    }
    
}
