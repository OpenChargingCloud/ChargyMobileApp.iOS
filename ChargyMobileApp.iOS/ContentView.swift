//
//  ContentView.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 07.07.25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ChargeTransparencyDataViewModel()
  
    static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "EE, d. MMMM yyyy"
            return formatter
        }()
    
    static let weekdayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "de_DE")
        f.dateFormat = "EE"
        return f
    }()
    
    static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "de_DE")
        f.dateFormat = "HH:mm:ss"
        return f
    }()
    
    var body: some View {
        VStack {
            
            Button("Transparenzdaten einfügen") {
                viewModel.pasteFromClipboard()
            }
            .padding()
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }
            
            if let ctrDescription = viewModel.description?["en"] {
                Text(ctrDescription)
                   .font(.headline)
                   .fontWeight(.bold)
                   .frame(maxWidth: .infinity, alignment: .center)
                   .padding(.vertical, 8)
                   .background(Color(.lightGray))
            }

            List(viewModel.sessions) { session in
                VStack(alignment: .leading) {

                    Text(Self.dateFormatter.string(from: session.begin))
                    
                    Text({
                        let startStr  = Self.timeFormatter.string(from: session.begin)
                        guard let end = session.end else { return "\(startStr) - still running" }
                        let duration  = end.timeIntervalSince(session.begin)
                        let days      = Int(duration / 86400)
                        let dayStr    = days > 0 ? Self.weekdayFormatter.string(from: end) + " " : ""
                        let endStr    = Self.timeFormatter.string(from: end) + " Uhr"
                        return "\(startStr) - \(dayStr)\(endStr)"
                    }())

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
            .listStyle(.plain)
            .frame(maxHeight: .infinity)
            .layoutPriority(1)

        }
        .navigationBarTitle("Ladevorgänge")

    }
}

#Preview {
    ContentView()
}
