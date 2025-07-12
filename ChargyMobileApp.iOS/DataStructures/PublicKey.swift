//
//  PublicKey.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class PublicKey: JSONSerializable {
    
    //var id:             String
    var context:        String
    //var subject:        String//|any
    var algorithm:      String?//|OIDInfo
    var type:           String?//|OIDInfo
    var format:         PublicKeyFormats?
    var encoding:       Encoding?
    var value:          String
    var signatures:     [PublicKeySignature]?
    //var certainty:      Double?

    /// Designated initializer
    init(
        context: String,
        algorithm: String? = nil,
        type: String? = nil,
        format: PublicKeyFormats? = nil,
        encoding: Encoding? = nil,
        value: String,
        signatures: [PublicKeySignature]? = nil
    ) {
        self.context   = context
        self.algorithm = algorithm
        self.type      = type
        self.format    = format
        self.encoding  = encoding
        self.value     = value
        self.signatures = signatures
    }

    /// Converts this PublicKey into a JSON dictionary.
    func toJSON() -> [String: Any] {
        var dict: [String: Any] = [
            "context": context,
            "value": value
        ]
        if let algorithm = algorithm {
            dict["algorithm"] = algorithm
        }
        if let type = type {
            dict["type"] = type
        }
        if let format = format {
            dict["format"] = format.rawValue
        }
        if let encoding = encoding {
            dict["encoding"] = encoding.rawValue
        }
        if let signatures = signatures {
            dict["signatures"] = signatures.map { $0.toJSON() }
        }
        return dict
    }

    /// Parses a PublicKey from a JSON dictionary.
    static func parse(
        from data: [String: Any],
        value: inout PublicKey?,
        errorResponse: inout String?
    ) -> Bool {
        // context (mandatory)
        var contextValue: String?
        guard data.parseMandatoryString("context", value: &contextValue, errorResponse: &errorResponse),
              let context = contextValue else {
            return false
        }
        // value (mandatory)
        var rawValue: String?
        guard data.parseMandatoryString("value", value: &rawValue, errorResponse: &errorResponse),
              let valueStr = rawValue else {
            return false
        }
        // algorithm (optional)
        var algorithmValue: String?
        _ = data.parseOptionalString("algorithm", value: &algorithmValue, errorResponse: &errorResponse)
        // type (optional)
        var typeValue: String?
        _ = data.parseOptionalString("type", value: &typeValue, errorResponse: &errorResponse)
        // format (optional enum)
        var formatString: String?
        _ = data.parseOptionalString("format", value: &formatString, errorResponse: &errorResponse)
        let formatEnum = formatString.flatMap { PublicKeyFormats(rawValue: $0) }
        // encoding (optional enum)
        var encodingString: String?
        _ = data.parseOptionalString("encoding", value: &encodingString, errorResponse: &errorResponse)
        let encodingEnum = encodingString.flatMap { Encoding(rawValue: $0) }
        // signatures (optional array)
        var sigs: [PublicKeySignature]? = []
        guard data.parseOptionalArray(
            "signatures",
            into: &sigs,
            errorResponse: &errorResponse,
            using: { dict, sig, err in
                PublicKeySignature.parse(from: dict, value: &sig, errorResponse: &err)
            }
        ) else {
            return false
        }
        // instantiate
        value = PublicKey(
            context: context,
            algorithm: algorithmValue,
            type: typeValue,
            format: formatEnum,
            encoding: encodingEnum,
            value: valueStr,
            signatures: sigs
        )
        errorResponse = nil
        return true
    }
}
