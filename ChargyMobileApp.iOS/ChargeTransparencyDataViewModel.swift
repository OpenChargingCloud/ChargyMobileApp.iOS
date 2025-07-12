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
    @Published var ctr:          ChargeTransparencyRecord?
    @Published var description:  I18NString?
    @Published var sessions:     [ChargingSession] = []
    @Published var errorMessage: String?

    func pasteFromClipboard() {
        if let string = UIPasteboard.general.string {
            let data = Data(string.utf8)
            do {
                
                let any = try JSONSerialization.jsonObject(with: data, options: [])
                guard let jsonObject = any as? [String: Any] else {
                    fatalError("Expected a JSON object!")
                }
                
                var chargeTransparencyRecord:  ChargeTransparencyRecord?
                var errorResponse:             String?
                if ChargeTransparencyRecord.parse(from:          jsonObject,
                                                  value:         &chargeTransparencyRecord,
                                                  errorResponse: &errorResponse)
                {

                    chargeTransparencyRecord!.validate()
                    
                    self.ctr          = chargeTransparencyRecord
                    self.description  = chargeTransparencyRecord!.description
                    self.sessions     = chargeTransparencyRecord!.chargingSessions ?? []
                    self.errorMessage = nil
                    
                }
                else
                {
                    self.errorMessage = "Fehler beim Parsen: \(errorResponse ?? "")"
                    self.sessions     = []
                }

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
