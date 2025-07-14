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
    public private(set) var description:                I18NString?

    public private(set) var evseId:                     String?
    public private(set) var chargingStationId:          String?

    public private(set) var energy:                     Double?
    public private(set) var meterValues:                [MeterValue]?

    public private(set) var signatures:                 [Signature]?
                        var validation:                 ValidationState?

    public private(set) var chargeTransparencyRecord:   ChargeTransparencyRecord?
    

//     ctr?:                       IChargeTransparencyRecord;
//     GUI?:                       HTMLDivElement;
//     internalSessionId?:         string;
//     chargingProductRelevance?:  IChargingProductRelevance,
    
//     chargingStationOperatorId?: string;
//     chargingStationOperator?:   IChargingStationOperator;
//     chargingPoolId?:            string;
//     chargingPool?:              IChargingPool;
//     chargingStationId?:         string;
//     chargingStation?:           IChargingStation;
//     EVSEId:                     string;
//     EVSE?:                      IEVSE;
//     meterId?:                   string;
//     meter?:                     IEnergyMeter;
//     publicKey?:                 IPublicKey;
//     tariffId?:                  string;
//     chargingTariffs?:           Array<IChargingTariff>;

//     chargingPeriods?:           Array<IChargingPeriod>;
//     totalCosts?:                IChargingCosts;
//     authorizationStart:         IAuthorization;
//     authorizationStop?:         IAuthorization;
//     product?:                   IChargingProduct;
//     measurements:               Array<IMeasurement>;
//     parking?:                   Array<IParking>;
//     transparencyInfos?:         ITransparencyInfos;
//     method?:                    ACrypt;
//     original?:                  string;
//     signature?:                 string|ISignatureRS;
//     hashValue?:                 string;
//     verificationResult?:        ISessionCryptoResult;

    
    /// “21:00:00 – Sa 22:34:00 (1 day 3h 34m)”
    var formattedTimeRange: String {

      let startStr = ChargeTransparencyDataView.timeFormatter.string(from: begin)
      let end: Date = self.end ?? Date()
      let endStr  = self.end != nil
        ? ChargeTransparencyDataView.timeFormatter.string(from: end) + " Uhr"
        : "still running"
      
      let duration = end.timeIntervalSince(begin)
      let days     = Int(duration / 86400)
      let dayStr   = self.end != nil && days > 0
        ? ChargeTransparencyDataView.weekdayFormatter.string(from: end) + " "
        : ""

      let totalSeconds = Int(duration)
      let d =  totalSeconds / 86400
      let h = (totalSeconds % 86400) / 3600
      let m = (totalSeconds % 3600)  / 60
      let s =  totalSeconds % 60

      let durationText: String

      if d > 1 {
        durationText = "\n(\(d) Tage \(h) Std. \(m) Min.)"
      } else if d > 0 {
        durationText = "\n(\(d) Tag \(h) Std. \(m) Min.)"
      } else if h > 0 {
        durationText = "(\(h) Std. \(m) Min.)"
      } else if m > 0 {
        durationText = "(\(m) Min. \(s) Sek.)"
      } else {
        durationText = "(\(s) Sek.)"
      }

      return "\(startStr) – \(dayStr)\(endStr) \(durationText)"

    }

    
    init(
        id:                        String,
        begin:                     Date,
        context:                   String?                     = nil,
        end:                       Date?                       = nil,
        description:               I18NString?                 = nil,
        
        evseId:                    String?                     = nil,
        chargingStationId:         String?                     = nil,
        
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
        self.description               = description
        
        self.evseId                    = evseId
        self.chargingStationId         = chargingStationId
        
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
    
    
    static func parse(from json:      [String: Any],
                      value:          inout ChargingSession?,
                      errorResponse:  inout String?) -> Bool {
                
        var id: String?
        if !json.parseMandatoryString("@id", value: &id, errorResponse: &errorResponse) {
            return false
        }

        var context: String?
        if json.parseOptionalString("context", value: &context, errorResponse: &errorResponse) {
            if (!(errorResponse == nil)) {
                return false
            }
        }

        var begin: Date?
        if !json.parseMandatoryDate("begin", value: &begin, errorResponse: &errorResponse) {
            if (!(errorResponse == nil)) {
                return false
            }
        }
        
        var end: Date?
        if json.parseOptionalDate("end", value: &end, errorResponse: &errorResponse) {
            if (!(errorResponse == nil)) {
                return false
            }
        }
        
        var description: I18NString?
        if json.parseOptionalI18NString("description", value: &description, errorResponse: &errorResponse) {
            if (!(errorResponse == nil)) {
                return false
            }
        }

        
        var evseId: String?
        if json.parseOptionalString("evseId", value: &evseId, errorResponse: &errorResponse) {
            if (!(errorResponse == nil)) {
                return false
            }
        }

        var chargingStationId: String?
        if json.parseOptionalString("chargingStationId", value: &chargingStationId, errorResponse: &errorResponse) {
            if (!(errorResponse == nil)) {
                return false
            }
        }


        var energy: Double?
        if json.parseOptionalDouble("energy", value: &energy, errorResponse: &errorResponse) {
            if (!(errorResponse == nil)) {
                return false
            }
        }

        var meterValues: [MeterValue]?
        if json.parseOptionalArray("meterValues", into: &meterValues, errorResponse: &errorResponse, using: MeterValue.parse) {
            if (!(errorResponse == nil)) {
                return false
            }
        }

        var signatures: [Signature]?
        if json.parseOptionalArray("signatures", into: &signatures, errorResponse: &errorResponse, using: Signature.parse) {
            if (!(errorResponse == nil)) {
                return false
            }
        }

        value = ChargingSession(

                    id:                  id!,
                    begin:               begin!,
                    context:             context,
                    end:                 end,
                    description:         description,
                    
                    evseId:              evseId,
                    chargingStationId:   chargingStationId,

                    energy:              energy,
                    meterValues:         meterValues,
                    signatures:          signatures
//                    description:         description,
//                    chargingSessions:    sessions

                )
        
        value!.rawJSON = json
        
        return true
        
    }
    
    func toJSON() -> [String: Any] {

        var json: [String: Any] = [
            "@id":    id,
            "begin":  ISO8601DateFormatter().string(from: begin)
        ]
        
        if let context = context {
            json["context"] = context
        }
        
        if let end = end {
            json["end"] = ISO8601DateFormatter().string(from: end)
        }
        
        if let description = description {
            json["description"] = description
        }
        
        
        if let evseId = evseId {
            json["evseId"] = evseId
        }
        
        if let chargingStationId = chargingStationId {
            json["chargingStationId"] = chargingStationId
        }


        if let energy = energy {
            json["energy"] = energy
        }
        
        if let meterValues = meterValues {
            json["meterValues"] = meterValues.map { $0.toJSON() }
        }
        
        if let signatures = signatures {
            json["signatures"] = signatures.map { $0.toJSON() }
        }
        
        return json
        
    }

}
