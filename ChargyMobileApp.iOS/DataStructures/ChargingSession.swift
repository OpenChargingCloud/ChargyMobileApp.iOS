//
//  ChargingSession.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 07.07.25.
//

import Foundation
import CryptoKit

extension CodingUserInfoKey {
    static let rawJSONString = CodingUserInfoKey(rawValue: "rawJSONString")!
}

class ChargingSession: Identifiable, Codable {
        
    /// Stores the raw JSON string used to decode this session
    public private(set) var rawJSON: String?

    public private(set) var id:                         String
    public private(set) var context:                    String?
    public private(set) var begin:                      Date
    public private(set) var end:                        Date?

    public private(set) var energy:                     Double?
    public private(set) var meterValues:                [MeterValue]?

    public private(set) var signatures:                 [Signature]?
                        var validation:                 ValidationState?

    public private(set) var chargeTransparencyRecord:   ChargeTransparencyRecord?
                        var originalCTR:                String?

    
    init(
        id:                        String,
        begin:                     Date,
        context:                   String?                     = nil,
        end:                       Date?                       = nil,
        energy:                    Double?                     = nil,
        meterValues:               [MeterValue]?               = nil,
        signatures:                [Signature]?                = nil,
        validation:                ValidationState?            = nil,
        chargeTransparencyRecord:  ChargeTransparencyRecord?   = nil,
        originalCTR:               String?                     = nil
    ) {
        self.originalCTR               = originalCTR
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
    
    required convenience init(from decoder: Decoder) throws {
        
        // Capture raw JSON from decoder.userInfo
        var rawJSONString: String? = nil
        if let raw = decoder.userInfo[CodingUserInfoKey.rawJSONString] as? String {
            rawJSONString = raw
        }
        // Decode all other properties as before
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id                        = try container.decode(String.self, forKey: .id)
        let begin                     = try container.decode(Date.self, forKey: .begin)
        let context                   = try container.decodeIfPresent(String.self, forKey: .context)
        let end                       = try container.decodeIfPresent(Date.self, forKey: .end)
        let energy                    = try container.decodeIfPresent(Double.self, forKey: .energy)
        let meterValues               = try container.decodeIfPresent([MeterValue].self, forKey: .meterValues)
        let signatures                = try container.decodeIfPresent([Signature].self, forKey: .signatures)
        let validation                = try container.decodeIfPresent(ValidationState.self, forKey: .validation)
        let chargeTransparencyRecord  = try container.decodeIfPresent(ChargeTransparencyRecord.self, forKey: .chargeTransparencyRecord)
        let originalCTR               = try container.decodeIfPresent(String.self, forKey: .originalCTR)
        
        self.init(
            id: id,
            begin: begin,
            context: context,
            end: end,
            energy: energy,
            meterValues: meterValues,
            signatures: signatures,
            validation: validation,
            chargeTransparencyRecord: chargeTransparencyRecord,
            originalCTR: originalCTR
        )
        
        self.rawJSON = rawJSONString

    }
    
    
    func canonicalJSONForSignature(from json: Data) -> Data? {
        guard var jsonObj = try? JSONSerialization.jsonObject(with: json, options: []) as? [String: Any] else {
            return nil
        }
        jsonObj.removeValue(forKey: "signatures")
        return try? JSONSerialization.data(withJSONObject: jsonObj, options: [])
    }
    
    
    func validateChargingSession() -> ValidationState {

        guard let originalJSONString = originalCTR,
              let originalData = originalJSONString.data(using: .utf8) else {
            return .error
        }

        guard let canonicalData = canonicalJSONForSignature(from: originalData) else {
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

            sig.validation = ecKey.isValidSignature(ecdsaSignature, for: canonicalData)
                                 ? .valid
                                 : .invalid
            
        }

        // All signatures must be valid
        return signaturesX.allSatisfy { $0.validation == .valid }
                   ? .valid
                   : .invalid
        
    }
    
    
    static func parse(from data:     [String: Any],
                      value:         inout ChargingSession?,
                      errorResponse: inout String?) -> Bool {
        
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

        
        value = ChargingSession(
                    id:                id!,
                    begin:             begin!,
                    end:               end
//                    description:       description,
//                    chargingSessions:  sessions
                )
        
        return true
        
    }
    
}
