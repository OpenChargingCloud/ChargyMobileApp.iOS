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
    
    var eMobilityProviders:         [EMobilityProvider]        = []
    var contracts:                  [Contract]                 = []

    var chargingStationOperators:   [ChargingStationOperator]  = []
    var chargingPools:              [ChargingPool]             = []
    var chargingStations:           [ChargingStation]          = []
    var chargingTariffs:            [ChargingTariff]           = []
    var energyMeters:               [EnergyMeter]              = []
    var chargingSessions:           [ChargingSession]          = []

    var publicKeys:                 [PublicKey]                = []
    
    var signatures:                 [Signature]                = []
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
    var warnings:                   [String] = []
    var errors:                     [String] = []
//    var status:                     SessionVerificationResult;
    
        
    init(id:                String,
         context:           String?              = nil, //oder [String]
         begin:             Date?                = nil,
         end:               Date?                = nil,
         description:       I18NString?          = nil,
         chargingSessions:  [ChargingSession]?   = nil,) {
        
        self.id                = id
        self.description       = description
        self.chargingSessions  = chargingSessions ?? []
        
    }
    
}
