//
//  LegalCompliance.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class LegalCompliance: JSONSerializable {

    var conformity:    [Conformity]?
    var calibration:   [Calibration]?
    var url:           String?
    var freetext:      String?

    init(
        conformity: [Conformity]? = nil,
        calibration: [Calibration]? = nil,
        url: String? = nil,
        freetext: String? = nil
    ) {
        self.conformity  = conformity
        self.calibration = calibration
        self.url         = url
        self.freetext    = freetext
    }

    /// Converts this LegalCompliance into a JSON dictionary.
    func toJSON() -> [String: Any] {
        var dict: [String: Any] = [:]
        if let conf = conformity, !conf.isEmpty {
            dict["conformity"]  = conf.map { $0.toJSON() }
        }
        if let cal = calibration, !cal.isEmpty {
            dict["calibration"] = cal.map { $0.toJSON() }
        }
        if let url = url {
            dict["url"] = url
        }
        if let freetext = freetext {
            dict["freetext"] = freetext
        }
        return dict
    }

    /// Parses a LegalCompliance from a JSON dictionary.
    static func parse(
        from data: [String: Any],
        value: inout LegalCompliance?,
        errorResponse: inout String?
    ) -> Bool {
        // conformity (optional array)
        var confArray: [Conformity]? = []
        guard data.parseOptionalArray(
            "conformity",
            into: &confArray,
            errorResponse: &errorResponse,
            using: { dict, elem, err in
                Conformity.parse(from: dict, value: &elem, errorResponse: &err)
            }
        ) else {
            return false
        }
        // calibration (optional array)
        var calArray: [Calibration]? = []
        guard data.parseOptionalArray(
            "calibration",
            into: &calArray,
            errorResponse: &errorResponse,
            using: { dict, elem, err in
                Calibration.parse(from: dict, value: &elem, errorResponse: &err)
            }
        ) else {
            return false
        }
        // url (optional)
        var urlValue: String?
        _ = data.parseOptionalString("url", value: &urlValue, errorResponse: &errorResponse)
        // freetext (optional)
        var freeTextValue: String?
        _ = data.parseOptionalString("freetext", value: &freeTextValue, errorResponse: &errorResponse)

        // Instantiate
        value = LegalCompliance(
            conformity:   confArray,
            calibration:  calArray,
            url:          urlValue,
            freetext:     freeTextValue
        )
        errorResponse = nil
        return true
    }

}
