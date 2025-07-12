//
//  TransparencySoftware.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 10.07.25.
//

import Foundation

class TransparencySoftware: JSONSerializable {
    
    var certificateId:  String?

    init(certificateId: String? = nil) {
        self.certificateId = certificateId
    }

    func toJSON() -> [String: Any] {
        var dict: [String: Any] = [:]
        if let certificateId = certificateId {
            dict["certificateId"] = certificateId
        }
        return dict
    }

    static func parse(
        from data: [String: Any],
        value: inout TransparencySoftware?,
        errorResponse: inout String?
    ) -> Bool {
        var certId: String?
        guard data.parseOptionalString("certificateId", value: &certId, errorResponse: &errorResponse) else {
            return false
        }
        value = TransparencySoftware(certificateId: certId)
        errorResponse = nil
        return true
    }
}
