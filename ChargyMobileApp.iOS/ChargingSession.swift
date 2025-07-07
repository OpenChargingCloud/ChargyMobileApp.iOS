//
//  chargingSession.swift
//  ChargyApp
//
//  Created by Achim Friedland on 07.07.25.
//

import Foundation

enum ValidationState: String, Codable {
    case valid
    case invalid
    case error
}

class ChargingSession: Identifiable, Codable {
    var originalJSONString: String?

    var id: UUID?
    var startedAt: String?
    var endedAt: String?
    var energy: Double?
    var signatures: [ChargingSessionSignature]?
    var validation: ValidationState?
}

class ChargingSessionSignature: Codable {
    var publicKey: String?
    var signature: String?
    var validation: ValidationState?
}
