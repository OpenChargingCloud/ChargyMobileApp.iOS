//
//  MeterValue.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class MeterValue: Identifiable, JSONSerializable {

    var id:                  UUID?
    var timestamp:           String?
    var value:               Double?

    var signatures:          [Signature]?
    var validation:          ValidationState?

    init(
        id: UUID? = nil,
        timestamp: String? = nil,
        value: Double? = nil,
        signatures: [Signature]? = nil,
        validation: ValidationState? = nil
    ) {
        self.id = id
        self.timestamp = timestamp
        self.value = value
        self.signatures = signatures
        self.validation = validation
    }
        
    func toJSON() -> [String: Any] {
        var dict: [String: Any] = [:]
        if let id = id {
            dict["id"] = id.uuidString
        }
        if let timestamp = timestamp {
            dict["timestamp"] = timestamp
        }
        if let value = value {
            dict["value"] = value
        }
        if let signatures = signatures {
            dict["signatures"] = signatures.map { $0.toJSON() }
        }
        if let validation = validation {
            dict["validation"] = validation.rawValue
        }
        return dict
    }

    /// Parses a MeterValue from a JSON dictionary.
    static func parse(
        from data: [String: Any],
        value: inout MeterValue?,
        errorResponse: inout String?
    ) -> Bool {
        // id (optional UUID)
        var idString: String?
        _ = data.parseOptionalString("id", value: &idString, errorResponse: &errorResponse)
        let idValue = idString.flatMap { UUID(uuidString: $0) }

        // timestamp (optional)
        var timestampValue: String?
        _ = data.parseOptionalString("timestamp", value: &timestampValue, errorResponse: &errorResponse)

        // value (mandatory Double)
        var doubleValue: Double?
        guard data.parseMandatoryDouble("value", value: &doubleValue, errorResponse: &errorResponse),
              let v = doubleValue else {
            return false
        }

        // signatures (optional array)
        var sigs: [Signature]? = []
        guard data.parseOptionalArray("signatures", into: &sigs, errorResponse: &errorResponse,
                                      using: { dict, sig, err in
                                          Signature.parse(from: dict, value: &sig, errorResponse: &err)
                                      }) else {
            return false
        }

        // validation (optional)
        var validationString: String?
        _ = data.parseOptionalString("validation", value: &validationString, errorResponse: &errorResponse)
        let validationValue = validationString.flatMap { ValidationState(rawValue: $0) }

        // instantiate
        value = MeterValue(
            id: idValue,
            timestamp: timestampValue,
            value: v,
            signatures: sigs,
            validation: validationValue
        )
        errorResponse = nil
        return true
    }
}
