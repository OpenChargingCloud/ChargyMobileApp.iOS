//
//  ChargingSessionsViewModel.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 07.07.25.
//

import Foundation
import SwiftUI
import CryptoKit

class ChargeTransparencyDataViewModel: ObservableObject {
    @Published var description:  I18NString?
    @Published var sessions:     [ChargingSession] = []
    @Published var errorMessage: String?
    
    func parseSessions(from data: Data) throws -> ChargeTransparencyRecord {

        let json = try JSONSerialization.jsonObject(with: data, options: [])

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            var sessionArray: [ChargingSession] = []

            if let array = json as? [[String: Any]] {
                for dict in array {
                    let singleData = try JSONSerialization.data(withJSONObject: dict, options: [])
                    let session    = try decoder.decode(ChargingSession.self, from: singleData)
                    session.originalCTR = String(data: singleData, encoding: .utf8)
                    sessionArray.append(session)
                }
            } else if let dict = json as? [String: Any] {
                let singleData = try JSONSerialization.data(withJSONObject: dict, options: [])
                let session    = try decoder.decode(ChargingSession.self, from: singleData)
                session.originalCTR = String(data: singleData, encoding: .utf8)
                sessionArray.append(session)
            } else {
                throw NSError(domain: "ChargeTransparencyDataViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid CTR format"])
            }

        return ChargeTransparencyRecord(
            id:                 "1",
            description:        I18NString(values: ["en": "All charging sessions"]),
            chargingSessions:   sessionArray
        )
        
    }
    
    func canonicalJSONForSignature(from json: Data) -> Data? {
        guard var jsonObj = try? JSONSerialization.jsonObject(with: json, options: []) as? [String: Any] else {
            return nil
        }
        jsonObj.removeValue(forKey: "signatures")
        return try? JSONSerialization.data(withJSONObject: jsonObj, options: [])
    }

    func validateChargingSession(_ session: ChargingSession) -> ValidationState {

        guard let originalJSONString = session.originalCTR,
              let originalData = originalJSONString.data(using: .utf8) else {
            return .error
        }

        guard let canonicalData = canonicalJSONForSignature(from: originalData) else {
            return .error
        }

        guard let signatures = session.signatures, !signatures.isEmpty else {
            return .invalid
        }

        // Check all signatures
        for sig in signatures {
            
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
        return signatures.allSatisfy { $0.validation == .valid }
                   ? .valid
                   : .invalid
        
    }
    
    
    
    func validateChargingSessions(_ chargingSessions: ChargeTransparencyRecord) {
        for session in chargingSessions.chargingSessions {
            if session.validation == nil {
                session.validation = validateChargingSession(session)
            }
        }
    }

    
    func pasteFromClipboard() {
        if let string = UIPasteboard.general.string {
            let data = Data(string.utf8)
            do {
                let chargingSessions = try parseSessions(from: data)
                self.validateChargingSessions(chargingSessions)
                self.description  = chargingSessions.description
                self.sessions     = chargingSessions.chargingSessions
                self.errorMessage = nil
            } catch {
                self.errorMessage = "Fehler beim Parsen: \(error)"
                self.sessions     = []
            }
        } else {
            self.errorMessage = "Kein Text in der Zwischenablage."
            self.sessions     = []
        }
    }
    
}
