//
//  ChargeTransparencyRecord.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 07.07.25.
//

import Foundation

class ChargeTransparencyRecord: Codable {

    var id:                         String
    var context:                    String? //oder [String]
    var begin:                      Date?
    var end:                        Date?
    var description:                I18NString?
    
    var eMobilityProviders:         [EMobilityProvider]?
    var contracts:                  [Contract]?

    var chargingStationOperators:   [ChargingStationOperator]?
    var chargingPools:              [ChargingPool]?
    var chargingStations:           [ChargingStation]?
    var chargingTariffs:            [ChargingTariff]?
    var energyMeters:               [EnergyMeter]?
    var chargingSessions:           [ChargingSession]?

    var publicKeys:                 [PublicKey]?
    
    var signatures:                 [Signature]?
    var validation:                 ValidationState?

//    mediationServices?:         Array<IMediationService>;
//
//    var verificationResult:         SessionCryptoResult?
//    invalidDataSets?:           Array<IExtendedFileInfo>;
//
//    // How sure we are that this result is correct!
//    // (JSON) transparency records might not always include an unambiguously
//    // format identifier. So multiple chargy parsers might be candidates, but
//    // hopefully one will be the best matching parser.
//    certainty:                  number;
//
    var warnings:                   [String]?
    var errors:                     [String]?
//    var status:                     SessionVerificationResult;
    
    var originalJSON:               String?
    
        
    init(id:                  String,
         context:             String?                = nil, //oder [String]
         begin:               Date?                  = nil,
         end:                 Date?                  = nil,
         description:         I18NString?            = nil,
         eMobilityProviders:  [EMobilityProvider]?   = nil,
         chargingSessions:    [ChargingSession]?     = nil) {
        
        self.id                  = id
        self.description         = description
        self.eMobilityProviders  = eMobilityProviders ?? []
        self.chargingSessions    = chargingSessions   ?? []
        
    }
    
    /// Throws if the given key is missing or not a String
    static func parseMandatoryStringold(_ key: String, from data: [String: Any]) throws -> String {
        guard let value = data[key] as? String else {
            throw NSError(
                domain: "ChargeTransparencyRecord",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Missing or invalid '\(key)' field"]
            )
        }
        return value
    }


    
    static func parse(from data:     [String: Any],
                      value:         inout ChargeTransparencyRecord?,
                      errorResponse: inout String?) -> Bool {

        var id: String?
        if !data.parseMandatoryString("id", value: &id, errorResponse: &errorResponse) {
            return false
        }
        
        var description: I18NString?
        guard data.parseOptionalI18NString("description", value: &description, errorResponse: &errorResponse) else {
            return false
        }
                
//            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = .iso8601
            var sessionArray: [ChargingSession] = []

        value = ChargeTransparencyRecord(
                    id:                id!,
                    description:       description,
                    chargingSessions:  sessionArray
                )
        
        return true
        
    }

    func canonicalJSONForSignature(from json: Data) -> Data? {
        guard var jsonObj = try? JSONSerialization.jsonObject(with: json, options: []) as? [String: Any] else {
            return nil
        }
        jsonObj.removeValue(forKey: "signatures")
        return try? JSONSerialization.data(withJSONObject: jsonObj, options: [])
    }


    
    
    
    func validate() {
        for session in chargingSessions ?? [] {
            if session.validation == nil {
                session.validation = session.validateChargingSession()
            }
        }
    }

    
    
}
