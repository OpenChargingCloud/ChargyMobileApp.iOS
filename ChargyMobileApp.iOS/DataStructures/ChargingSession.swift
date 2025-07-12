//
//  ChargingSession.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 07.07.25.
//

import Foundation
import CryptoKit

class ChargingSession: Identifiable, JSONSerializable {
        
    public private(set) var rawJSON:                    [String: Any]?

    public private(set) var id:                         String
    public private(set) var context:                    String?
    public private(set) var begin:                      Date
    public private(set) var end:                        Date?

    public private(set) var energy:                     Double?
    public private(set) var meterValues:                [MeterValue]?

    public private(set) var signatures:                 [Signature]?
                        var validation:                 ValidationState?

    public private(set) var chargeTransparencyRecord:   ChargeTransparencyRecord?

    
    init(
        id:                        String,
        begin:                     Date,
        context:                   String?                     = nil,
        end:                       Date?                       = nil,
        energy:                    Double?                     = nil,
        meterValues:               [MeterValue]?               = nil,
        signatures:                [Signature]?                = nil,
        validation:                ValidationState?            = nil,
        chargeTransparencyRecord:  ChargeTransparencyRecord?   = nil
    ) {
        self.id                        = id
        self.context                   = context
        self.begin                     = begin
        self.end                       = end
        self.energy                    = energy
        self.meterValues               = meterValues
        self.signatures                = signatures
        self.validation                = validation
        self.chargeTransparencyRecord  = chargeTransparencyRecord
    }


    func validateChargingSession() -> ValidationState {
        
        guard let json         = rawJSON,
              let originalData = try? JSONSerialization.data(withJSONObject: json, options: []) else {
            return .error
        }

        guard let canonicalJSON = JSONUtils.canonicalJSONForSignature(from: originalData) else {
            return .error
        }

        guard let signaturesX = signatures, !signaturesX.isEmpty else {
            return .invalid
        }

        for sig in signaturesX {
            
            sig.validation = .error

            guard let pubKeyB64     = sig.publicKey,
                  let signatureB64  = sig.signature,
                  let pubKeyData    = Data(base64Encoded: pubKeyB64),
                  let signatureData = Data(base64Encoded: signatureB64) else {
                sig.validation = .invalid
                continue
            }

            guard let ecKey          = try? P256.Signing.PublicKey(x963Representation: pubKeyData),
                  let ecdsaSignature = try? P256.Signing.ECDSASignature(derRepresentation: signatureData)
            else {
                sig.validation = .invalid
                continue
            }

            sig.validation = ecKey.isValidSignature(ecdsaSignature, for: canonicalJSON)
                                 ? .valid
                                 : .invalid
            
        }

        // All signatures must be valid
        return signaturesX.allSatisfy { $0.validation == .valid }
                   ? .valid
                   : .invalid
        
    }
    
    
    static func parse(from data:      [String: Any],
                      value:          inout ChargingSession?,
                      errorResponse:  inout String?) -> Bool {
                
        var id: String?
        if !data.parseMandatoryString("id", value: &id, errorResponse: &errorResponse) {
            return false
        }
        
        var description: I18NString?
        if data.parseOptionalI18NString("description", value: &description, errorResponse: &errorResponse) {
            if (!(errorResponse == nil)) {
                return false
            }
        }

        var context: String?
        if data.parseOptionalString("context", value: &context, errorResponse: &errorResponse) {
            if (!(errorResponse == nil)) {
                return false
            }
        }

        var begin: Date?
        if !data.parseMandatoryDate("begin", value: &begin, errorResponse: &errorResponse) {
            if (!(errorResponse == nil)) {
                return false
            }
        }
        
        var end: Date?
        if data.parseOptionalDate("end", value: &end, errorResponse: &errorResponse) {
            if (!(errorResponse == nil)) {
                return false
            }
        }

        var energy: Double?
        if data.parseOptionalDouble("energy", value: &energy, errorResponse: &errorResponse) {
            if (!(errorResponse == nil)) {
                return false
            }
        }

        var meterValues: [MeterValue]?
        if data.parseOptionalArray("meterValues", into: &meterValues, errorResponse: &errorResponse, using: MeterValue.parse) {
            if (!(errorResponse == nil)) {
                return false
            }
        }

        var signatures: [Signature]?
        if data.parseOptionalArray("signatures", into: &signatures, errorResponse: &errorResponse, using: Signature.parse) {
            if (!(errorResponse == nil)) {
                return false
            }
        }

        value = ChargingSession(
                    id:                id!,
                    begin:             begin!,
                    context:           context,
                    end:               end,
                    energy:            energy,
                    meterValues:       meterValues,
                    signatures:        signatures
//                    description:       description,
//                    chargingSessions:  sessions
                )
        
        value!.rawJSON = data
        
        return true
        
    }
    
    func toJSON() -> [String: Any] {

        var dict: [String: Any] = [
            "id":    id,
            "begin": ISO8601DateFormatter().string(from: begin)
        ]
        
        if let context = context {
            dict["context"] = context
        }
        
        if let end = end {
            dict["end"] = ISO8601DateFormatter().string(from: end)
        }
        
        if let energy = energy {
            dict["energy"] = energy
        }
        
        if let meterValues = meterValues {
            dict["meterValues"] = meterValues.map { $0.toJSON() }
        }
        
        if let signatures = signatures {
            dict["signatures"] = signatures.map { $0.toJSON() }
        }
        
        return dict
        
    }

}
