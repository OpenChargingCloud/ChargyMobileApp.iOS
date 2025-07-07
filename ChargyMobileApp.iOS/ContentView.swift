//
//  ContentView.swift
//  ChargyApp
//
//  Created by Achim Friedland on 07.07.25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ChargingSessionsViewModel()
    
    
    
    var body: some View {
        VStack {
            
            Button("JSON einfügen") {
                viewModel.pasteFromClipboard()
            }
            .padding()
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }

            List(viewModel.sessions) { session in
                VStack(alignment: .leading) {
                    if let startedAt = session.startedAt {
                        Text("Start: \(startedAt)")
                    }
                    if let endedAt = session.endedAt {
                        Text("Ende: \(endedAt)")
                    }
                    if let energy = session.energy {
                        Text(String(format: "Energie: %.2f kWh", energy))
                    }
                    if let signatures = session.signatures {
                        ForEach(signatures.indices, id: \.self) { i in
                            let sig = signatures[i]
                            Text("Signature \(i+1):")
                            if let pub = sig.publicKey { Text("  PublicKey: \(pub)") }
                            if let s   = sig.signature { Text("  Signature: \(s)") }
                        }
                    }
                    if let validation = session.validation {
                        Text("Validation: \(validation.rawValue)")
                    }
                }
            }
            
        }
        .navigationBarTitle("Ladevorgänge")

    }
}

#Preview {
    ContentView()
}
