//
//  EnergyMeter.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class EnergyMeter: Identifiable, JSONSerializable {
    
    var originalJSONString:  String?
    
    var id:                  String
    var context:             String?
    var description:         I18NString?
    var manufacturer:        Manufacturer?
    var model:               DeviceModel?
    var serialNumber:        String?
    var hardwareVersion:     String?
    var firmwareVersion:     String?
    var legalCompliance:     LegalCompliance?
    var signatureFormat:     String?
    var signatureInfos:      SignatureInfos?
    var publicKey:           String?

    var chargingPool:        ChargingPool?
    var chargingPoolId:      String?
    var chargingStation:     ChargingStation?
    var chargingStationId:   String?
    var EVSE:                EVSE?
    var EVSEId:              String?

    /// Designated initializer
    init(
        id: String,
        context: String? = nil,
        description: I18NString? = nil,
        manufacturer: Manufacturer? = nil,
        model: DeviceModel? = nil,
        serialNumber: String? = nil,
        hardwareVersion: String? = nil,
        firmwareVersion: String? = nil,
        legalCompliance: LegalCompliance? = nil,
        signatureFormat: String? = nil,
        signatureInfos: SignatureInfos? = nil,
        publicKey: String? = nil,
        chargingPool: ChargingPool? = nil,
        chargingPoolId: String? = nil,
        chargingStation: ChargingStation? = nil,
        chargingStationId: String? = nil,
        EVSE: EVSE? = nil,
        EVSEId: String? = nil,
        originalJSONString: String? = nil
    ) {
        self.originalJSONString = originalJSONString
        self.id                 = id
        self.context            = context
        self.description        = description
        self.manufacturer       = manufacturer
        self.model              = model
        self.serialNumber       = serialNumber
        self.hardwareVersion    = hardwareVersion
        self.firmwareVersion    = firmwareVersion
        self.legalCompliance    = legalCompliance
        self.signatureFormat    = signatureFormat
        self.signatureInfos     = signatureInfos
        self.publicKey          = publicKey
        self.chargingPool       = chargingPool
        self.chargingPoolId     = chargingPoolId
        self.chargingStation    = chargingStation
        self.chargingStationId  = chargingStationId
        self.EVSE               = EVSE
        self.EVSEId             = EVSEId
    }

    /// Converts this EnergyMeter into a JSON dictionary.
    func toJSON() -> [String: Any] {
        var dict: [String: Any] = ["id": id]
        if let context = context {
            dict["context"] = context
        }
        if let description = description {
            dict["description"] = description.toJSON()
        }
        if let manufacturer = manufacturer {
            dict["manufacturer"] = manufacturer.toJSON()
        }
        if let model = model {
            dict["model"] = model.toJSON()
        }
        if let serialNumber = serialNumber {
            dict["serialNumber"] = serialNumber
        }
        if let hardwareVersion = hardwareVersion {
            dict["hardwareVersion"] = hardwareVersion
        }
        if let firmwareVersion = firmwareVersion {
            dict["firmwareVersion"] = firmwareVersion
        }
        if let legalCompliance = legalCompliance {
            dict["legalCompliance"] = legalCompliance.toJSON()
        }
        if let signatureFormat = signatureFormat {
            dict["signatureFormat"] = signatureFormat
        }
        if let signatureInfos = signatureInfos {
            dict["signatureInfos"] = signatureInfos.toJSON()
        }
        if let publicKey = publicKey {
            dict["publicKey"] = publicKey
        }
        if let chargingPool = chargingPool {
            dict["chargingPool"] = chargingPool.toJSON()
        }
        if let chargingPoolId = chargingPoolId {
            dict["chargingPoolId"] = chargingPoolId
        }
        if let chargingStation = chargingStation {
            dict["chargingStation"] = chargingStation.toJSON()
        }
        if let chargingStationId = chargingStationId {
            dict["chargingStationId"] = chargingStationId
        }
        if let EVSE = EVSE {
            dict["EVSE"] = EVSE.toJSON()
        }
        if let EVSEId = EVSEId {
            dict["EVSEId"] = EVSEId
        }
        return dict
    }

    /// Parses an EnergyMeter from a JSON dictionary.
    static func parse(
        from data: [String: Any],
        value: inout EnergyMeter?,
        errorResponse: inout String?
    ) -> Bool {
        // id (mandatory)
        var idValue: String?
        guard data.parseMandatoryString("id", value: &idValue, errorResponse: &errorResponse),
              let id = idValue else {
            return false
        }
        // context (optional)
        let contextValue = data["context"] as? String
        // description (optional I18NString)
        var descValue: I18NString?
        guard data.parseOptionalI18NString("description", value: &descValue, errorResponse: &errorResponse) else {
            return false
        }
        // manufacturer (optional)
        var manuValue: Manufacturer?
        if let raw = data["manufacturer"] as? [String: Any] {
            guard Manufacturer.parse(from: raw, value: &manuValue, errorResponse: &errorResponse) else {
                return false
            }
        }
        // model (optional)
        var modelValue: DeviceModel?
        if let raw = data["model"] as? [String: Any] {
            guard DeviceModel.parse(from: raw, value: &modelValue, errorResponse: &errorResponse) else {
                return false
            }
        }
        // simple string fields
        let serialValue        = data["serialNumber"]        as? String
        let hardwareValue      = data["hardwareVersion"]     as? String
        let firmwareValue      = data["firmwareVersion"]     as? String
        let signatureFormatVal = data["signatureFormat"]     as? String
        let publicKeyValue     = data["publicKey"]           as? String
        // nested objects
        var legalValue: LegalCompliance?
        if let raw = data["legalCompliance"] as? [String: Any] {
            guard LegalCompliance.parse(from: raw, value: &legalValue, errorResponse: &errorResponse) else {
                return false
            }
        }
        var sigInfosValue: SignatureInfos?
        if let raw = data["signatureInfos"] as? [String: Any] {
            guard SignatureInfos.parse(from: raw, value: &sigInfosValue, errorResponse: &errorResponse) else {
                return false
            }
        }
        // chargingPool (optional)
        var poolValue: ChargingPool?
        if let raw = data["chargingPool"] as? [String: Any] {
            guard ChargingPool.parse(from: raw, value: &poolValue, errorResponse: &errorResponse) else {
                return false
            }
        }
        let poolIdValue = data["chargingPoolId"] as? String
        // chargingStation (optional)
        var stationValue: ChargingStation?
        if let raw = data["chargingStation"] as? [String: Any] {
            guard ChargingStation.parse(from: raw, value: &stationValue, errorResponse: &errorResponse) else {
                return false
            }
        }
        let stationIdValue = data["chargingStationId"] as? String
        
//        // EVSE (optional)
//        var evseValue: EVSE?
//        if let rawEVSE = data["EVSE"] as? [String: Any] {
//            guard EVSE.parse(from: rawEVSE, value: &evseValue, errorResponse: &errorResponse) else {
//                return false
//            }
//        }
//        let evseIdValue = data["EVSEId"] as? String
        
        // instantiate
        value = EnergyMeter(
            id: id,
            context: contextValue,
            description: descValue,
            manufacturer: manuValue,
            model: modelValue,
            serialNumber: serialValue,
            hardwareVersion: hardwareValue,
            firmwareVersion: firmwareValue,
            legalCompliance: legalValue,
            signatureFormat: signatureFormatVal,
            signatureInfos: sigInfosValue,
            publicKey: publicKeyValue,
            chargingPool: poolValue,
            chargingPoolId: poolIdValue,
            chargingStation: stationValue,
            chargingStationId: stationIdValue,
//            EVSE: evseValue,
//            EVSEId: evseIdValue,
//            originalJSONString: nil
        )
        errorResponse = nil
        return true
    }
}
