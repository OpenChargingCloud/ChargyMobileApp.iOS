//
//  SignatureInfos.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 09.07.25.
//

import Foundation

class SignatureInfos: JSONSerializable {

    var hash:            CryptoHashAlgorithms?  //|String
    var hashTrucation:   UInt8
    var algorithm:       CryptoAlgorithms?      //|String
    var curve:           ECCurves?              //|String
    var format:          SignatureFormats?      //|String
    var encoding:        Encoding?              //|String

    init(
        hash: CryptoHashAlgorithms? = nil,
        hashTrucation: UInt8,
        algorithm: CryptoAlgorithms? = nil,
        curve: ECCurves? = nil,
        format: SignatureFormats? = nil,
        encoding: Encoding? = nil
    ) {
        self.hash          = hash
        self.hashTrucation = hashTrucation
        self.algorithm     = algorithm
        self.curve         = curve
        self.format        = format
        self.encoding      = encoding
    }

    func toJSON() -> [String: Any] {
        var dict: [String: Any] = ["hashTrucation": hashTrucation]
        if let h = hash {
            dict["hash"] = h.rawValue
        }
        if let a = algorithm {
            dict["algorithm"] = a.rawValue
        }
        if let c = curve {
            dict["curve"] = c.rawValue
        }
        if let f = format {
            dict["format"] = f.rawValue
        }
        if let e = encoding {
            dict["encoding"] = e.rawValue
        }
        return dict
    }

    static func parse(
        from data: [String: Any],
        value: inout SignatureInfos?,
        errorResponse: inout String?
    ) -> Bool {
        // hash (optional enum)
        var hashRaw: String?
        _ = data.parseOptionalString("hash", value: &hashRaw, errorResponse: &errorResponse)
        let hashEnum = hashRaw.flatMap { CryptoHashAlgorithms(rawValue: $0) }

        // hashTrucation (mandatory UInt8 via Double)
        var truncDouble: Double?
        guard data.parseMandatoryDouble("hashTrucation", value: &truncDouble, errorResponse: &errorResponse),
              let trunc = truncDouble,
              trunc >= 0, trunc <= Double(UInt8.max) else {
            return false
        }
        let truncValue = UInt8(trunc)

        // algorithm (optional enum)
        var algRaw: String?
        _ = data.parseOptionalString("algorithm", value: &algRaw, errorResponse: &errorResponse)
        let algEnum = algRaw.flatMap { CryptoAlgorithms(rawValue: $0) }

        // curve (optional enum)
        var curveRaw: String?
        _ = data.parseOptionalString("curve", value: &curveRaw, errorResponse: &errorResponse)
        let curveEnum = curveRaw.flatMap { ECCurves(rawValue: $0) }

        // format (optional enum)
        var formatRaw: String?
        _ = data.parseOptionalString("format", value: &formatRaw, errorResponse: &errorResponse)
        let formatEnum = formatRaw.flatMap { SignatureFormats(rawValue: $0) }

        // encoding (optional enum)
        var encRaw: String?
        _ = data.parseOptionalString("encoding", value: &encRaw, errorResponse: &errorResponse)
        let encEnum = encRaw.flatMap { Encoding(rawValue: $0) }

        // instantiate
        value = SignatureInfos(
            hash: hashEnum,
            hashTrucation: truncValue,
            algorithm: algEnum,
            curve: curveEnum,
            format: formatEnum,
            encoding: encEnum
        )
        errorResponse = nil
        return true
    }

}
