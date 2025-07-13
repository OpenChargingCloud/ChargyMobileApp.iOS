//
//  PublicKey.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class PublicKey: JSONSerializable {
    
    //var id:             String
    var context:        String?
    //var subject:        String//|any
    var algorithm:      String?//|OIDInfo
    var type:           String?//|OIDInfo
    var format:         PublicKeyFormats?
    var encoding:       Encoding?
    var value:          String
    var signatures:     [PublicKeySignature]?
    //var certainty:      Double?
    
    init(
        algorithm: String? = nil,
        type: String? = nil,
        format: PublicKeyFormats? = nil,
        encoding: Encoding? = nil,
        value: String,
        signatures: [PublicKeySignature]? = nil,
        context: String? = nil
    ) {
        self.algorithm = algorithm
        self.type      = type
        self.format    = format
        self.encoding  = encoding
        self.value     = value
        self.signatures = signatures
        self.context   = context
    }
    
    
    func toJSON() -> [String: Any] {
        
        var json: [String: Any] = [
            "value":   value
        ]
        if let algorithm = algorithm {
            json["algorithm"] = algorithm
        }
        if let type = type {
            json["type"] = type
        }
        if let format = format {
            json["format"] = format.rawValue
        }
        if let encoding = encoding {
            json["encoding"] = encoding.rawValue
        }
        if let signatures = signatures {
            json["signatures"] = signatures.map { $0.toJSON() }
        }
        if let context = context {
            json["@context"] = context
        }
        
        return json
        
    }
    
    static func parse(
        from data:      [String: Any],
        value:          inout PublicKey?,
        errorResponse:  inout String?
    ) -> Bool {
        
        var rawValue: String?
        guard data.parseMandatoryString("value", value: &rawValue, errorResponse: &errorResponse),
              let valueStr = rawValue else {
            return false
        }
        
        var algorithmValue: String?
        _ = data.parseOptionalString("algorithm", value: &algorithmValue, errorResponse: &errorResponse)
        
        var typeValue: String?
        _ = data.parseOptionalString("type", value: &typeValue, errorResponse: &errorResponse)
        
        var formatString: String?
        _ = data.parseOptionalString("format", value: &formatString, errorResponse: &errorResponse)
        let formatEnum = formatString.flatMap { PublicKeyFormats(rawValue: $0) }
        
        var encodingString: String?
        _ = data.parseOptionalString("encoding", value: &encodingString, errorResponse: &errorResponse)
        let encodingEnum = encodingString.flatMap { Encoding(rawValue: $0) }
        
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
        
        var context: String?
        if data.parseOptionalString("@context", value: &context, errorResponse: &errorResponse) {
            if (errorResponse != nil) {
                return false
            }
        }
        
        value = PublicKey(
            algorithm: algorithmValue,
            type: typeValue,
            format: formatEnum,
            encoding: encodingEnum,
            value: valueStr,
            signatures: sigs,
            context: context
        )
        
        errorResponse = nil
        return true
        
    }
    
}
