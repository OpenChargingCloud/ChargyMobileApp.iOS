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

            if let jsonArray = json as? [[String: Any]] {
                for dict in jsonArray {
                    let singleData = try JSONSerialization.data(withJSONObject: dict, options: [])
                    let session    = try decoder.decode(ChargingSession.self, from: singleData)
                    session.originalCTR = String(data: singleData, encoding: .utf8)
                    sessionArray.append(session)
                }
            } else if let jsonObject = json as? [String: Any] {
                let singleData   = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
                let ctr          = try decoder.decode(ChargeTransparencyRecord.self, from: singleData)
                ctr.originalJSON = String(data: singleData, encoding: .utf8)
                return ctr;
            } else {
                throw NSError(domain: "ChargeTransparencyDataViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid charge transparency data format"])
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


    
    
    
    func validateChargingSessions(_ chargingSessions: ChargeTransparencyRecord) {
        for session in chargingSessions.chargingSessions ?? [] {
            if session.validation == nil {
                session.validation = session.validateChargingSession()
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
                self.sessions     = chargingSessions.chargingSessions ?? []
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
