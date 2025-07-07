//
//  ChargingSessions.swift
//  ChargyApp
//
//  Created by Achim Friedland on 07.07.25.
//

import Foundation

class ChargingSessions: Codable {
    var title: String
    var chargingSessions: [ChargingSession]

    init(title: String, chargingSessions: [ChargingSession]) {
        self.title = title
        self.chargingSessions = chargingSessions
    }
}
