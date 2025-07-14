//
//  ChargeTransparencyRecord.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 07.07.25.
//

import Foundation

class ChargeTransparencyRecord: Identifiable,
                                JSONSerializable {

    public private(set) var id:                         String
    public private(set) var context:                    String? //oder [String]
    public private(set) var begin:                      Date?
    public private(set) var end:                        Date?
    public private(set) var description:                I18NString?
    
    public private(set) var eMobilityProviders:         [EMobilityProvider]?
    public private(set) var contracts:                  [Contract]?

    public private(set) var chargingStationOperators:   [ChargingStationOperator]?
    public private(set) var chargingPools:              [ChargingPool]?
    public private(set) var chargingStations:           [ChargingStation]?
    public private(set) var chargingTariffs:            [ChargingTariff]?
    public private(set) var energyMeters:               [EnergyMeter]?
    public private(set) var chargingSessions:           [ChargingSession]?

    public private(set) var publicKeys:                 [PublicKey]?
    
    public private(set) var signatures:                 [Signature]?
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
    public private(set) var warnings:                   [String]?
    public private(set) var errors:                     [String]?
//    var status:                     SessionVerificationResult;
    
    var originalJSON:               String?


    init(id:                         String,
         context:                    String?                     = nil,
         begin:                      Date?                       = nil,
         end:                        Date?                       = nil,
         description:                I18NString?                 = nil,
         eMobilityProviders:        [EMobilityProvider]?         = nil,
         contracts:                 [Contract]?                  = nil,
         chargingStationOperators:  [ChargingStationOperator]?   = nil,
         chargingPools:             [ChargingPool]?              = nil,
         chargingStations:          [ChargingStation]?           = nil,
         chargingTariffs:           [ChargingTariff]?            = nil,
         energyMeters:              [EnergyMeter]?               = nil,
         chargingSessions:          [ChargingSession]?           = nil,
         publicKeys:                [PublicKey]?                 = nil,
         signatures:                [Signature]?                 = nil,
         warnings:                  [String]?                    = nil,
         errors:                    [String]?                    = nil,
         originalJSON:               String?                     = nil
    ) {
        self.id                        = id
        self.context                   = context
        self.begin                     = begin
        self.end                       = end
        self.description               = description
        self.eMobilityProviders        = eMobilityProviders
        self.contracts                 = contracts
        self.chargingStationOperators  = chargingStationOperators
        self.chargingPools             = chargingPools
        self.chargingStations          = chargingStations
        self.chargingTariffs           = chargingTariffs
        self.energyMeters              = energyMeters
        self.chargingSessions          = chargingSessions
        self.publicKeys                = publicKeys
        self.signatures                = signatures
        self.warnings                  = warnings
        self.errors                    = errors
        self.originalJSON              = originalJSON
    }
    
//    /// Throws if the given key is missing or not a String
//    static func parseMandatoryStringold(_ key: String, from data: [String: Any]) throws -> String {
//        guard let value = data[key] as? String else {
//            throw NSError(
//                domain: "ChargeTransparencyRecord",
//                code: 1,
//                userInfo: [NSLocalizedDescriptionKey: "Missing or invalid '\(key)' field"]
//            )
//        }
//        return value
//    }


    
    static func parse(from json:     [String: Any],
                      value:         inout ChargeTransparencyRecord?,
                      errorResponse: inout String?) -> Bool {

        var id: String?
        if !json.parseMandatoryString("@id", value: &id, errorResponse: &errorResponse) {
            return false
        }

        var context: String?
        if json.parseOptionalString("@context", value: &context, errorResponse: &errorResponse) {
            if (errorResponse != nil) {
                return false
            }
        }

        var begin: Date?
        if json.parseOptionalDate("begin", value: &begin, errorResponse: &errorResponse) {
            if (errorResponse != nil) {
                return false
            }
        }
        
        var end: Date?
        if json.parseOptionalDate("end", value: &end, errorResponse: &errorResponse) {
            if (errorResponse != nil) {
                return false
            }
        }

        var description: I18NString?
        if json.parseOptionalI18NString("description", value: &description, errorResponse: &errorResponse) {
            if (errorResponse != nil) {
                return false
            }
        }

        var eMobilityProviders: [EMobilityProvider]?
        if !json.parseOptionalArray(
            "eMobilityProviders",
            into:           &eMobilityProviders,
            errorResponse:  &errorResponse,
            using:          { json, provider, err in EMobilityProvider.parse(from: json, value: &provider, errorResponse: &err)}
        ) {
            return false
        }

        var contracts: [Contract]?
        if !json.parseOptionalArray(
            "contracts",
            into:           &contracts,
            errorResponse:  &errorResponse,
            using:          { json, contract, err in Contract.parse(from: json, value: &contract, errorResponse: &err)}
        ) {
            return false
        }

        var chargingStationOperators: [ChargingStationOperator]?
        if !json.parseOptionalArray("chargingStationOperators",
            into:           &chargingStationOperators,
            errorResponse:  &errorResponse,
            using:          { dict, op, err in ChargingStationOperator.parse(from: dict, value: &op, errorResponse: &err)}
        ) {
            return false
        }

        var chargingPools: [ChargingPool]?
        if !json.parseOptionalArray("chargingPools",
            into:           &chargingPools,
            errorResponse:  &errorResponse,
            using:          { dict, pool, err in ChargingPool.parse(from: dict, value: &pool, errorResponse: &err)}
        ) {
            return false
        }

        var chargingStations: [ChargingStation]?
        if !json.parseOptionalArray(
            "chargingStations",
            into:           &chargingStations,
            errorResponse:  &errorResponse,
            using:          { dict, station, err in ChargingStation.parse(from: dict, value: &station, errorResponse: &err)}
        ) {
            return false
        }

        var chargingTariffs: [ChargingTariff]?
        if !json.parseOptionalArray(
            "chargingTariffs",
            into:           &chargingTariffs,
            errorResponse:  &errorResponse,
            using:          { dict, tariff, err in ChargingTariff.parse(from: dict, value: &tariff, errorResponse: &err)}
        ) {
            return false
        }

        var energyMeters: [EnergyMeter]?
        if !json.parseOptionalArray(
            "energyMeters",
            into:           &energyMeters,
            errorResponse:  &errorResponse,
            using:          { dict, meter, err in EnergyMeter.parse(from: dict, value: &meter, errorResponse: &err)}
        ) {
            return false
        }

        var chargingSessions: [ChargingSession]? = []
        if !json.parseOptionalArray(
            "chargingSessions",
            into:           &chargingSessions,
            errorResponse:  &errorResponse,
            using:          { dict, session, err in ChargingSession.parse(from: dict, value: &session, errorResponse: &err)}
        ) {
            return false
        }

        var publicKeys: [PublicKey]?
        if !json.parseOptionalArray(
            "publicKeys",
            into:           &publicKeys,
            errorResponse:  &errorResponse,
            using:          { dict, key, err in PublicKey.parse(from: dict, value: &key, errorResponse: &err)}
        ) {
            return false
        }

        var signatures: [Signature]?
        if !json.parseOptionalArray("signatures",
            into:           &signatures,
            errorResponse:  &errorResponse,
            using:          { dict, sig, err in Signature.parse(from: dict, value: &sig, errorResponse: &err)}
        ) {
            return false
        }

        value = ChargeTransparencyRecord(
                    id:                        id!,
                    context:                   context,
                    begin:                     begin,
                    end:                       end,
                    description:               description,
                    eMobilityProviders:        eMobilityProviders,
                    contracts:                 contracts,
                    chargingStationOperators:  chargingStationOperators,
                    chargingPools:             chargingPools,
                    chargingStations:          chargingStations,
                    chargingTariffs:           chargingTariffs,
                    energyMeters:              energyMeters,
                    chargingSessions:          chargingSessions,
                    publicKeys:                publicKeys,
                    signatures:                signatures
                )

        return true
        
    }

    func toJSON() -> [String: Any] {

        var json: [String: Any] = [
            "@id": id
        ]

        if let context = context {
            json["@context"] = context
        }

        if let begin = begin {
            json["begin"] = ISO8601DateFormatter().string(from: begin)
        }

        if let end = end {
            json["end"] = ISO8601DateFormatter().string(from: end)
        }

        if let description = description {
            json["description"] = description.toJSON()
        }

        if let providers = eMobilityProviders {
            json["eMobilityProviders"] = providers.map { $0.toJSON() }
        }

        if let contracts = contracts {
            json["contracts"] = contracts.map { $0.toJSON() }
        }

        if let operators = chargingStationOperators {
            json["chargingStationOperators"] = operators.map { $0.toJSON() }
        }

        if let pools = chargingPools {
            json["chargingPools"] = pools.map { $0.toJSON() }
        }

        if let stations = chargingStations {
            json["chargingStations"] = stations.map { $0.toJSON() }
        }

        if let tariffs = chargingTariffs {
            json["chargingTariffs"] = tariffs.map { $0.toJSON() }
        }

        if let meters = energyMeters {
            json["energyMeters"] = meters.map { $0.toJSON() }
        }

        if let sessions = chargingSessions {
            json["chargingSessions"] = sessions.map { $0.toJSON() }
        }

        if let keys = publicKeys {
            json["publicKeys"] = keys.map { $0.toJSON() }
        }

        if let sigs = signatures {
            json["signatures"] = sigs.map { $0.toJSON() }
        }

        if let warnings = warnings {
            json["warnings"] = warnings
        }

        if let errors = errors {
            json["errors"] = errors
        }

        if let origJSON = originalJSON {
            json["originalJSON"] = origJSON
        }

        return json
        
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
