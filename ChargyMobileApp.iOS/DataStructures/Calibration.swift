//
//  Calibration.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class Calibration {
    
    var certificateId:        String?
    var url:                  String?
    var notBefore:            String?
    var notAfter:             String?
    var freeText:             String?
    
    /// Designated initializer
    init(
        certificateId: String? = nil,
        url: String? = nil,
        notBefore: String? = nil,
        notAfter: String? = nil,
        freeText: String? = nil
    ) {
        self.certificateId = certificateId
        self.url           = url
        self.notBefore     = notBefore
        self.notAfter      = notAfter
        self.freeText      = freeText
    }
    
    /// Converts this Calibration into a JSON dictionary.
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
        if let freeText = freeText {
            dict["freeText"] = freeText
        }
        return dict
    }
    
    /// Parses a Calibration from a JSON dictionary.
    static func parse(
        from data: [String: Any],
        value: inout Calibration?,
        errorResponse: inout String?
    ) -> Bool {
        // certificateId (optional)
        var certId: String?
        _ = data.parseOptionalString("certificateId", value: &certId, errorResponse: &errorResponse)
        // url (optional)
        var urlValue: String?
        _ = data.parseOptionalString("url", value: &urlValue, errorResponse: &errorResponse)
        // notBefore (optional)
        var beforeValue: String?
        _ = data.parseOptionalString("notBefore", value: &beforeValue, errorResponse: &errorResponse)
        // notAfter (optional)
        var afterValue: String?
        _ = data.parseOptionalString("notAfter", value: &afterValue, errorResponse: &errorResponse)
        // freeText (optional)
        var freeTextValue: String?
        _ = data.parseOptionalString("freeText", value: &freeTextValue, errorResponse: &errorResponse)
        // Instantiate
        value = Calibration(
            certificateId: certId,
            url: urlValue,
            notBefore: beforeValue,
            notAfter: afterValue,
            freeText: freeTextValue
        )
        errorResponse = nil
        return true
    }
    
}
