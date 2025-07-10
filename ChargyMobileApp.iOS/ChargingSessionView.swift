//
//  ChargingSessionView.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 10.07.25.
//

import SwiftUI

struct ChargingSessionView: View {

    let session: ChargingSession

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Id: \(session.id)")
                Text("Begin: \(ChargeTransparencyDataView.dateFormatter.string(from: session.begin))")
                if let end = session.end {
                    Text("End: \(ChargeTransparencyDataView.dateFormatter.string(from: end))")
                }
//                if let energy = session.energy {
//                    Text("Energie: \(energy, specifier: \"%.2f\") kWh")
//                }
                if let signatures = session.signatures {
                    ForEach(signatures.indices, id: \.self) { i in
                        let sig = signatures[i]
                        Text("Signature \(i+1):")
                        if let pub = sig.publicKey {
                            Text("  PublicKey: \(pub)")
                        }
                        if let s = sig.signature {
                            Text("  Signature: \(s)")
                        }
                        if let v = sig.validation {
                            Text("  Validation: \(v.rawValue)")
                        }
                    }
                }
                if let validation = session.validation {
                    Text("Overall Validation: \(validation.rawValue)")
                }
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}


import Foundation

#Preview {
    ChargingSessionView(
        session: ChargingSession(
            id: "18a7a7f5-1a72-414b-97d1-8b18ffeb9c60",
            begin: ISO8601DateFormatter().date(from: "2024-07-06T19:00:00Z")!
        )
    )
}
